# Research: Clinic & Multi-Tenant Setup (004-clinic-tenancy)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## R1: Invite Code Generation in Postgres

**Task**: Research best approach for generating unique 8-character invite codes server-side in Postgres.

**Decision**: Use a Postgres function `generate_invite_code()` that generates an uppercase alphanumeric string using `chr()` and `floor(random() * ...)`. The function loops up to 10 times checking for uniqueness against `clinics.invite_code`. A UNIQUE constraint on the column provides safety net.

**Rationale**: Server-side generation ensures codes are unique even with concurrent requests. Client-side generation would require a round-trip to check uniqueness and is vulnerable to race conditions. The 8-char alphanumeric space (36^8 = ~2.8 trillion combinations) makes collisions virtually impossible at our scale.

**Alternatives considered**:
- UUID-based short codes: Rejected — UUIDs are too long to type manually and truncating loses uniqueness guarantees.
- Sequential numeric codes: Rejected — predictable, guessable, and reveals information about system state.
- Client-generated with server validation: Rejected — race condition on concurrent joins, extra round trip.

## R2: Multi-Tenant RLS Strategy for Supabase

**Task**: Research the best RLS pattern for multi-tenant clinic isolation where a user can belong to multiple tenants.

**Decision**: RLS policies check `auth.uid()` against `staff_clinic_assignments` to determine which clinic IDs the user can access. For `clinics` table: user can SELECT clinics they are a member of (via JOIN on `staff_clinic_assignments`). For `staff_clinic_assignments`: user can SELECT/INSERT/UPDATE only rows where they are the user or are a `clinic_admin` of that clinic. For `locations`: filtered by `clinic_id` via same membership check.

**Rationale**: This is the standard Supabase multi-tenant pattern. The JOIN-based approach is more maintainable than storing clinic IDs in JWT claims (which would require token refresh on clinic changes).

**Alternatives considered**:
- JWT custom claims with clinic_id: Rejected — requires token refresh when user changes clinics or joins new ones. Not compatible with multi-clinic switching.
- Application-level filtering only: Rejected — violates constitution principle III (defense-in-depth requires DB-level enforcement).
- Postgres `SET` variables per request: Rejected — Supabase doesn't support per-request connection variables from the client SDK.

## R3: ClinicCubit State Design

**Task**: Research optimal state design for a cubit that manages both clinic selection and clinic CRUD operations.

**Decision**: Use a sealed class hierarchy for `ClinicState`:
- `ClinicInitial` — app just started, no data loaded
- `ClinicLoading` — fetching assignments
- `ClinicLoaded` — has assignments list + optional selected clinic ID + optional clinic details
- `ClinicError` — error with message

The `ClinicLoaded` state carries:
- `List<StaffAssignment> assignments` — all of the user's active clinic assignments
- `String? selectedClinicId` — currently selected clinic (null if none selected yet)
- `Clinic? selectedClinic` — full clinic details of selected clinic (for settings)
- `List<StaffAssignment>? staff` — staff list for the selected clinic (null until loaded from settings page)

**Rationale**: A single cubit with a loaded state that holds both the assignment list and the selected clinic keeps the state management simple. The selected clinic ID is the critical piece that other features need. Staff list is nullable because it's only loaded when clinic admin navigates to staff management.

**Alternatives considered**:
- Separate ClinicSelectionCubit + ClinicManagementCubit: Rejected — over-engineering for the current scope. The two concerns share the same data (clinic assignments) and the selection state needs to be readable from management pages.
- Bloc with events: Rejected — no complex event streams. All operations are request/response (no realtime, no concurrent channels). Cubit matches constitution principle V.

## R4: Integrating ClinicCubit with GoRouter Refresh

**Task**: Research how to merge multiple cubit-driven refresh notifiers for GoRouter.

**Decision**: Create a `ClinicCubitRefreshListenable` (same pattern as existing `AuthCubitRefreshListenable`). In `AppRouter`, combine both listenables using `Listenable.merge([authRefresh, clinicRefresh])` and pass the merged listenable as `refreshListenable` to `GoRouter`.

**Rationale**: GoRouter accepts a single `Listenable` for refresh. `Listenable.merge` is a built-in Flutter utility that creates a composite listenable notifying on changes from any source. This avoids custom ChangeNotifier implementations.

**Alternatives considered**:
- Single combined ChangeNotifier: Rejected — more code, harder to maintain, couples auth and clinic concerns.
- Stream-based refresh: Rejected — GoRouter expects a `Listenable`, not a `Stream`.

## R5: Clinic Creation Transaction — RPC vs Client-Side

**Task**: Research whether to use a Supabase RPC function or client-side sequential inserts for the create clinic flow (clinic + invite code + default location + staff assignment).

**Decision**: Use a Supabase RPC function `create_clinic_with_defaults(p_name, p_phone, p_address, p_type)` that:
1. Generates an invite code via `generate_invite_code()`
2. Inserts into `clinics`
3. Inserts a `staff_clinic_assignments` row with role `clinic_admin`
4. Inserts a default `locations` row using the clinic's address/phone
5. Returns the full clinic row

All within a single transaction.

**Rationale**: Transactional consistency is critical — if the location insert or staff assignment fails, the entire clinic creation should roll back. Client-side sequential inserts cannot guarantee atomicity. The RPC function also runs with the caller's auth context, so RLS still applies.

**Alternatives considered**:
- Client-side sequential inserts: Rejected — no transactional guarantee. Partial failure (clinic created but no admin assignment) would leave orphaned data.
- Edge Function: Rejected — overkill for a simple transactional write. RPC functions are simpler and run within the same Postgres transaction.

## R6: StaffRole Enum — Reuse vs. New

**Task**: Research whether to reuse the existing `UserRole` enum from auth (which includes clinicAdmin, doctor, nurse, receptionist, pharmacist) or create a separate `StaffRole` enum for the clinic feature.

**Decision**: Create a separate `StaffRole` enum in the clinic domain layer with values: `clinicAdmin`, `doctor`, `receptionist`, `nurse`, `other`. This is distinct from the `UserRole` in the auth domain.

**Rationale**: `UserRole` in auth represents the global profile role, while `StaffRole` represents a user's role within a specific clinic. A user could be a `doctor` globally but a `clinic_admin` in one clinic and a `doctor` in another. Separating the enums avoids semantic confusion. The `staff_clinic_assignments.role` column uses its own DB enum type (`staff_role_type`) independent of `user_role_type`.

**Alternatives considered**:
- Reuse `UserRole`: Rejected — mixing global profile role with clinic-specific assignment role creates confusion. A user's clinic role may differ from their profile role.
- Shared enum in `core/`: Rejected — the enums serve different purposes. Coupling them would create a false dependency between auth and clinic features.
