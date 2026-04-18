# Research: Patient Management (005-patients)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Research Tasks

### 1. Pagination Strategy: Offset vs Cursor-Based

**Decision**: Offset-based pagination via Supabase `.range(from, to)`

**Rationale**:
- Supabase Dart client has native `.range(from, to)` that maps directly to SQL `LIMIT/OFFSET`.
- Patient data is clinic-scoped (max ~50k per clinic per SC-007). At this scale, offset pagination is performant with proper indexes.
- The patient list is read-most, not real-time. No need for gap-free cursor guarantees.
- Cursor-based would add complexity (maintaining cursor tokens, encoding sort position) without meaningful benefit at this scale.

**Alternatives considered**:
- **Cursor-based (keyset)**: More efficient for very large datasets (100k+) but adds complexity. Rejected because clinic-scoped patient lists won't hit these volumes in the foreseeable future.
- **Supabase Realtime subscriptions for live list**: Overkill for a patient list that changes infrequently. Deferred to future iteration if needed.

### 2. Search Implementation: Full-Text Search vs ILIKE

**Decision**: Multi-field `ilike` with `or` filter via Supabase client SDK

**Rationale**:
- Full-text search (`tsvector`/`tsquery`) requires creating and maintaining a generated column plus a GIN index. The added complexity is not justified for searching 4-5 fields with simple substring matching.
- `ilike` with `%query%` is sufficient for the expected data volumes and search patterns (find patient by name fragment, phone prefix, or patient number).
- Composite indexes on `(clinic_id, last_name, first_name)` and `(clinic_id, phone_number)` optimize the two most common search patterns.
- Supabase client SDK's `.or()` filter composes cleanly for multi-field search.

**Alternatives considered**:
- **Postgres full-text search (tsvector)**: Better for natural language queries and large text bodies. Rejected because patient search fields are short, structured values — not prose text.
- **Supabase Edge Function with custom search logic**: Adds unnecessary network hop and function deployment overhead for a simple query.
- **pg_trgm (trigram) extension**: Good for fuzzy matching but requires extension setup and more complex query patterns. Deferred — can be added later if users need typo-tolerant search.

### 3. Patient Number Auto-Generation

**Decision**: Postgres function `generate_patient_number(p_clinic_id uuid)` called via trigger on INSERT

**Rationale**:
- Server-side generation via database function ensures atomicity and prevents race conditions when two staff members create patients simultaneously.
- Format: `P-NNNN` (e.g., P-0001). Uses `COALESCE(MAX(...)+ 1, 1)` to find the next number from existing records.
- The function reads the highest existing patient number for the given clinic and increments it.
- A UNIQUE constraint on `(clinic_id, patient_number)` provides a safety net.

**Alternatives considered**:
- **Client-side number generation**: Race condition risk when multiple staff create patients at the same time. Rejected.
- **Supabase RPC for number generation**: Viable but a trigger is simpler — it fires automatically on INSERT without requiring the client to call an extra function. Chosen: trigger approach.
- **UUID-only (no human-readable number)**: Violates the requirement for a P-NNNN formatted patient number visible to staff.

### 4. Route Registration Pattern

**Decision**: Nest patient routes inside the `StatefulShellRoute` home branch as sub-routes of `/home`

**Rationale**:
- The existing GoRouter setup uses `StatefulShellRoute.indexedStack` for the main shell with a bottom nav bar.
- Patient pages should display within the shell (nav bar visible) so users can navigate back to home or settings.
- Sub-routes under `/home` (e.g., `/home/patients`, `/home/patients/new`, `/home/patients/:id`) keep the shell context alive.
- The form and detail pages use the same shell structure — no need to break out of the shell for patient management.

**Alternatives considered**:
- **Top-level routes (`/patients`)**: Would lose the bottom nav bar shell context. Rejected.
- **Separate ShellBranch for patients**: Overly complex for routes that logically belong under the home area. Rejected.

### 5. Integration with ClinicCubit for clinic_id

**Decision**: Pages read `clinicId` from `context.read<ClinicCubit>().state` and pass it explicitly to cubit methods

**Rationale**:
- Keeps the patient feature completely decoupled from clinic internals. No direct import of clinic feature files.
- The `ClinicCubit` is provided at the app root via `MultiBlocProvider`. Any page can read it via `context.read<ClinicCubit>()`.
- Patient cubits accept `clinicId` as a parameter to their methods (e.g., `loadPatients(clinicId)`, `createPatient(params)` where params include `clinicId`). They do NOT hold a reference to `ClinicCubit`.

**Alternatives considered**:
- **Inject clinicId into PatientListCubit constructor**: Would require recreating the cubit whenever the clinic changes. Rejected.
- **Shared domain service for current clinic**: Over-engineering for a simple value read. Rejected.

### 6. Two Cubits vs One PatientCubit

**Decision**: Two separate cubits — `PatientListCubit` and `PatientDetailCubit`

**Rationale**:
- `PatientListCubit` manages list state (patients, pagination offset, search query, loading/error) and is scoped to the `PatientListPage`.
- `PatientDetailCubit` manages single-patient state (load by ID, create, update, deactivate) and is scoped to `PatientDetailPage`/`PatientFormPage`.
- Separating concerns means list operations don't interfere with detail operations, and each cubit has a smaller, more testable state surface.
- The list cubit can refresh independently when returning from a create/edit operation.

**Alternatives considered**:
- **Single PatientCubit**: Would conflate list pagination state with single-patient CRUD state, making state management more complex. Rejected.
- **Three cubits (list + detail + form)**: Unnecessary split — `PatientDetailCubit` handles both viewing and CRUD. The form page is a UI abstraction, not a state abstraction. Rejected.

### 7. New AppValidators Needed

**Decision**: Add `dateNotFuture` validator to `AppValidators`

**Implementation**:
```dart
static String? Function(String?) dateNotFuture({
  String message = 'Date cannot be in the future',
}) {
  return (value) {
    if (value == null || value.trim().isEmpty) return null;
    final date = DateTime.tryParse(value);
    if (date != null && date.isAfter(DateTime.now())) return message;
    return null;
  };
}
```

**Note**: Existing validators `required`, `phone`, `email`, and `compose` are already sufficient for other patient form fields. The `phoneValid` mentioned in requirements maps to `AppValidators.phone()`. The `emailValid` maps to `AppValidators.email()`.

## Summary

All research questions resolved. No NEEDS CLARIFICATION items remain. Ready for Phase 1 design.
