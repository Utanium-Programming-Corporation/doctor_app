# Implementation Plan: Clinic & Multi-Tenant Setup

**Branch**: `004-clinic-tenancy` | **Date**: 2026-04-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/004-clinic-tenancy/spec.md`

## Summary

Implement clinic creation, clinic joining via invite code, multi-clinic selection, and clinic administration. After a doctor completes profile setup (003-auth), they must create or join a clinic before accessing the dashboard. A `ClinicCubit` at the app root manages the currently selected clinic ID, which flows through all subsequent data operations. Supabase tables (`clinics`, `staff_clinic_assignments`, `locations`) with RLS enforce multi-tenant data isolation. The GoRouter redirect chain is extended to include a clinic-assignment check after profile verification.

## Technical Context

**Language/Version**: Dart 3.11.4+ / Flutter (latest stable)
**Primary Dependencies**: supabase_flutter, flutter_bloc, go_router, get_it, dartz, freezed, equatable, json_annotation, json_serializable, build_runner
**Storage**: Supabase (PostgreSQL) — `clinics`, `staff_clinic_assignments`, `locations` tables with RLS
**Testing**: flutter_test, mocktail, bloc_test
**Target Platform**: iOS, Android (web deferred)
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Clinic creation/join flow < 5s, 60fps UI, clinic selector renders instantly
**Constraints**: No PHI in logs, RLS on all tables with `clinic_id`, offline not supported, all domain tables must include `clinic_id`
**Scale/Scope**: Single feature (clinic), ~30 files, 8 use cases, 1 cubit, 6 pages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | ✅ PASS | Three layers: domain (pure Dart entities + abstract repo), data (Supabase models + data source), presentation (ClinicCubit + pages). All use cases implement one of the four abstract interfaces. |
| II. Type-Safe Functional Error Handling | ✅ PASS | All use cases return `Either<Failure, T>` via `FutureResult<T>`. Entities use Equatable. Models use freezed + json_serializable. |
| III. Security & HIPAA Compliance | ✅ PASS | RLS on all three tables. `clinic_id` column on `staff_clinic_assignments` and `locations`. Invite code validation server-side. No PHI in logs. |
| IV. Feature-Modular Organization | ✅ PASS | Self-contained under `lib/features/clinic/` with `initClinic()` in DI. Cross-feature communication through GoRouter redirect reading both AuthCubit and ClinicCubit state. |
| V. Cubit-Default State Management | ✅ PASS | ClinicCubit for all clinic state (no complex event streams — Cubit is appropriate). |
| VI. Supabase-First Backend | ✅ PASS | Invite code generation via Postgres function (`generate_invite_code()`). RLS policies reference `auth.uid()`. |
| VII. UI File Size Discipline | ✅ PASS | Each page ≤ 100 lines. Complex pages split into `widgets/` subfolder. |
| VIII. Unified Text Input | ✅ PASS | All forms use `AppFormField` via `buildTextField` helpers. Validation uses `AppValidators`. |

**Pre-check result**: ALL GATES PASS. No violations to justify.

## Project Structure

### Documentation (this feature)

```text
specs/004-clinic-tenancy/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── supabase-migration.sql
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart  # MODIFY — add initClinic() call
│   ├── router/
│   │   ├── app_router.dart           # MODIFY — add clinic routes + redirect logic
│   │   └── route_names.dart          # MODIFY — add clinic route names
│   └── error/
│       └── failures.dart             # MODIFY — add ClinicFailure if needed
├── features/
│   └── clinic/
│       ├── di/
│       │   └── clinic_injection.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── clinic.dart
│       │   │   ├── staff_assignment.dart
│       │   │   ├── location.dart
│       │   │   ├── clinic_type.dart
│       │   │   └── staff_role.dart
│       │   ├── repositories/
│       │   │   └── clinic_repository.dart
│       │   └── usecases/
│       │       ├── create_clinic.dart
│       │       ├── join_clinic_by_code.dart
│       │       ├── get_my_clinic_assignments.dart
│       │       ├── get_clinic_staff.dart
│       │       ├── update_clinic.dart
│       │       ├── update_staff_role.dart
│       │       ├── deactivate_staff.dart
│       │       └── regenerate_invite_code.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── clinic_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── clinic_model.dart
│       │   │   ├── staff_assignment_model.dart
│       │   │   └── location_model.dart
│       │   └── repositories/
│       │       └── clinic_repository_impl.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── clinic_cubit.dart
│           │   └── clinic_state.dart
│           └── pages/
│               ├── clinic_or_join_page.dart
│               ├── create_clinic_page.dart
│               ├── join_clinic_page.dart
│               ├── clinic_selector_page.dart
│               ├── clinic_settings_page.dart
│               ├── staff_list_page.dart
│               └── widgets/
│                   ├── clinic_type_dropdown.dart
│                   ├── clinic_card.dart
│                   ├── staff_member_tile.dart
│                   └── role_selector_dialog.dart
```

**Structure Decision**: Feature-modular under `lib/features/clinic/` following the same pattern as `lib/features/auth/`. All pages in `pages/`, reusable presentation components in `pages/widgets/`.

## Clinic ID Flow Through the App

### Architecture

```
┌─────────────┐     ┌──────────────┐     ┌────────────────────┐
│ ClinicCubit  │────▶│ Use Cases    │────▶│ ClinicRepository   │
│ (app root)   │     │ (domain)     │     │ (abstract)         │
│              │     │              │     │                    │
│ selectedId   │     │ pass clinicId│     │ pass clinicId      │
└──────┬───────┘     └──────────────┘     └────────┬───────────┘
       │                                           │
       │ BlocProvider<ClinicCubit>                  │ implements
       │ at MaterialApp root                       │
       ▼                                           ▼
┌─────────────┐                          ┌────────────────────┐
│ Pages       │                          │ ClinicRepoImpl     │
│ read cubit  │                          │ (data layer)       │
│ via context │                          │                    │
│             │                          │ Supabase queries   │
│             │                          │ filter by clinicId │
└─────────────┘                          └────────────────────┘
```

1. **ClinicCubit** is provided at the app root (alongside AuthCubit) via `MultiBlocProvider` in `app.dart`.
2. **ClinicCubit.state** holds the currently selected `clinicId` and the list of user's clinic assignments.
3. **Pages** read the selected `clinicId` from `ClinicCubit` when dispatching use case calls.
4. **Use cases** receive `clinicId` as part of their `Params` objects.
5. **Repository implementation** passes `clinicId` to Supabase queries as filter.
6. **Supabase RLS** provides defense-in-depth: even if client sends the wrong `clinic_id`, RLS blocks unauthorized access.

### Router Redirect Chain (Extended)

```dart
String? _redirect(BuildContext context, GoRouterState state) {
  final auth = authCubit.state;
  final clinic = clinicCubit.state;
  final location = state.matchedLocation;

  // 1. Auth loading — no redirect
  if (auth is AuthInitial || auth is AuthLoading) return null;

  // 2. Not authenticated → welcome
  if (auth is Unauthenticated || auth is AuthError) {
    return location == '/welcome' ? null : '/welcome';
  }

  // 3. Authenticated, no profile → profile setup
  if (auth is Authenticated && auth.profile == null) {
    return location == '/profile-setup' ? null : '/profile-setup';
  }

  // 4. Has profile, no clinic assignments → create/join clinic
  if (auth is Authenticated && clinic is ClinicLoaded && clinic.assignments.isEmpty) {
    return location == '/clinic-setup' ? null : '/clinic-setup';
  }

  // 5. Has multiple clinics, none selected → clinic selector
  if (auth is Authenticated && clinic is ClinicLoaded && clinic.selectedClinicId == null) {
    if (clinic.assignments.length > 1) {
      return location == '/clinic-selector' ? null : '/clinic-selector';
    }
    // Auto-select if only one clinic
    clinicCubit.selectClinic(clinic.assignments.first.clinicId);
    return null;
  }

  // 6. Fully set up — leave onboarding screens
  if (auth is Authenticated && clinic is ClinicLoaded && clinic.selectedClinicId != null) {
    const onboarding = ['/welcome', '/profile-setup', '/clinic-setup', '/clinic-selector'];
    if (onboarding.contains(location)) return '/home';
  }

  return null;
}
```

### Invite Code Generation Strategy

- **Server-side**: A Postgres function `generate_invite_code()` generates a random 8-character uppercase alphanumeric string using `chr()` with random ASCII codes.
- **Uniqueness**: The function queries `clinics.invite_code` in a loop (up to 10 iterations) and retries on collision. The `invite_code` column has a UNIQUE constraint as backup.
- **Client-side**: The Flutter app calls a Supabase RPC function `create_clinic_with_defaults` that wraps clinic creation + invite code generation + default location creation in a single transaction.
- **Regeneration**: A separate RPC `regenerate_clinic_invite_code` updates the invite code atomically.
- **Validation**: Client queries `clinics` table filtered by `invite_code` and `is_active = true`. RLS allows reading clinic name/id by invite code for authenticated users.

## Integration with Existing Auth Flow

### Changes to `app.dart`

- Replace single `BlocProvider<AuthCubit>` with `MultiBlocProvider` wrapping both `AuthCubit` and `ClinicCubit` at the root.

### Changes to `app_router.dart`

- Accept `ClinicCubit` and a second `ChangeNotifier` bridge as dependencies.
- Add routes: `/clinic-setup`, `/clinic-selector`, `/create-clinic`, `/join-clinic`, `/clinic-settings`, `/staff-list`.
- Extend `_redirect` with clinic-state checks (steps 4-6 in redirect chain above).
- Combine both `AuthCubitRefreshListenable` and `ClinicCubitRefreshListenable` into a single `Listenable.merge()` for `refreshListenable`.

### Changes to `injection_container.dart`

- Call `await initClinic()` after `initAuth()`.
- Register `ClinicCubitRefreshListenable`.
- Update `AppRouter` constructor to accept additional clinic dependencies.

### Changes to `route_names.dart`

- Add: `clinicSetup`, `clinicSelector`, `createClinic`, `joinClinic`, `clinicSettings`, `staffList`.

### Post-Login Flow Sequence

```
Sign-in → AuthCubit(Authenticated, profile != null)
  → ClinicCubit.loadAssignments(userId)
    → 0 assignments: /clinic-setup (choose create or join)
      → Create: /create-clinic → creates clinic → loadAssignments → /home
      → Join:   /join-clinic → joins clinic → loadAssignments → /home
    → 1 assignment:  auto-select → /home
    → N assignments: /clinic-selector → user selects → /home
```

## Complexity Tracking

> No constitution violations. Table left empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| (none) | — | — |
