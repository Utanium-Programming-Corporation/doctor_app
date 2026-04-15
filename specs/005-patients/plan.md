# Implementation Plan: Patient Management

**Branch**: `005-patients` | **Date**: 2026-04-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/005-patients/spec.md`

## Summary

Implement patient registration, search, paginated list, profile view/edit, and soft-delete (deactivation) for clinic-scoped patient records. A `patients` table in Supabase with RLS enforces clinic-level data isolation. A Postgres function auto-generates sequential patient numbers (P-0001, P-0002, …) per clinic. The presentation layer uses two Cubits — `PatientListCubit` (list + pagination + in-list search) and `PatientDetailCubit` (single patient CRUD) — exposed under `/patients` routes nested inside the main shell. Global search is implemented via a `PatientSearchDelegate` accessible from the app bar. The feature depends on 004-clinic-tenancy for the current `clinicId` (read from `ClinicCubit.state`).

## Technical Context

**Language/Version**: Dart 3.8.0+ / Flutter (latest stable)
**Primary Dependencies**: supabase_flutter, flutter_bloc, go_router, get_it, dartz, freezed, equatable, json_annotation, json_serializable, build_runner
**Storage**: Supabase (PostgreSQL) — `patients` table with RLS, indexes for search
**Testing**: flutter_test, mocktail, bloc_test
**Target Platform**: iOS, Android (web deferred)
**Project Type**: Mobile app (Flutter)
**Performance Goals**: First page of 20 patients loads in <2s, search results in <1s, 60fps UI
**Constraints**: No PHI in logs, RLS on `patients` table with `clinic_id`, all text inputs via AppFormField, all UI files ≤100 lines
**Scale/Scope**: Single feature, ~25 files, 6 use cases, 2 cubits, 4 pages + search delegate, 1 Supabase table

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | ✅ PASS | Three layers: domain (Patient entity + abstract PatientRepository + 6 use cases), data (PatientModel freezed + PatientRemoteDataSource + PatientRepositoryImpl), presentation (PatientListCubit + PatientDetailCubit + pages). All use cases implement UseCaseWithParams or UseCaseWithoutParams. |
| II. Type-Safe Functional Error Handling | ✅ PASS | All use cases return `FutureResult<T>`. Patient entity uses Equatable. PatientModel uses freezed + json_serializable. |
| III. Security & HIPAA Compliance | ✅ PASS | RLS on `patients` table. `clinic_id` column enforced by RLS referencing `auth.uid()` via `staff_clinic_assignments`. No PHI in logs. |
| IV. Feature-Modular Organization | ✅ PASS | Self-contained under `lib/features/patient/` with `initPatient()` DI function. Reads `clinicId` from ClinicCubit state (no direct feature-to-feature import — goes through DI/context). |
| V. Cubit-Default State Management | ✅ PASS | Two Cubits: PatientListCubit (list/search/pagination), PatientDetailCubit (single patient CRUD). No complex event streams — Cubit is appropriate. |
| VI. Supabase-First Backend | ✅ PASS | Patient number generation via Postgres function `generate_patient_number()`. RLS policies reference `auth.uid()`. |
| VII. UI File Size Discipline | ✅ PASS | Each page ≤100 lines. PatientFormPage content split into `widgets/` subfolder (form sections). |
| VIII. Unified Text Input | ✅ PASS | All form fields use `AppFormField.buildTextField`. Validation uses `AppValidators` composables. New validators added: `dateNotFuture`. |

**Pre-check result**: ALL GATES PASS. No violations to justify.

## Project Structure

### Documentation (this feature)

```text
specs/005-patients/
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
│   │   └── injection_container.dart  # MODIFY — add initPatient() call
│   ├── router/
│   │   ├── app_router.dart           # MODIFY — add patient routes inside shell
│   │   └── route_names.dart          # MODIFY — add patient route names
│   └── utils/
│       └── app_validators.dart       # MODIFY — add dateNotFuture validator
├── features/
│   └── patient/
│       ├── di/
│       │   └── patient_injection.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── patient.dart
│       │   │   ├── gender.dart
│       │   │   └── blood_type.dart
│       │   ├── repositories/
│       │   │   └── patient_repository.dart
│       │   └── usecases/
│       │       ├── create_patient.dart
│       │       ├── update_patient.dart
│       │       ├── get_patient_by_id.dart
│       │       ├── search_patients.dart
│       │       ├── get_patients_list.dart
│       │       └── deactivate_patient.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── patient_remote_data_source.dart
│       │   ├── models/
│       │   │   └── patient_model.dart
│       │   └── repositories/
│       │       └── patient_repository_impl.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── patient_list_cubit.dart
│           │   ├── patient_list_state.dart
│           │   ├── patient_detail_cubit.dart
│           │   └── patient_detail_state.dart
│           ├── pages/
│           │   ├── patient_list_page.dart
│           │   ├── patient_detail_page.dart
│           │   ├── patient_form_page.dart
│           │   ├── patient_search_delegate.dart
│           │   └── widgets/
│           │       ├── patient_list_tile.dart
│           │       ├── patient_info_section.dart
│           │       ├── patient_form_fields.dart
│           │       ├── blood_type_dropdown.dart
│           │       ├── gender_selector.dart
│           │       └── coming_soon_tab.dart
```

**Structure Decision**: Feature-modular under `lib/features/patient/` following the same pattern as `lib/features/clinic/`. All pages in `pages/`, reusable presentation components in `pages/widgets/`. Two separate cubits for list vs detail to keep responsibilities clean.

## Patient Routes in GoRouter

Patient routes live **inside** the `StatefulShellRoute` home branch as sub-routes, so the bottom navigation bar persists. The route tree:

```dart
// Inside the home StatefulShellBranch routes:
GoRoute(
  path: '/home',
  name: RouteNames.home,
  builder: (context, state) => const HomePlaceholderPage(),
  routes: [
    GoRoute(
      path: 'patients',
      name: RouteNames.patientList,
      builder: (context, state) => const PatientListPage(),
      routes: [
        GoRoute(
          path: 'new',
          name: RouteNames.patientNew,
          builder: (context, state) => const PatientFormPage(),
        ),
        GoRoute(
          path: ':id',
          name: RouteNames.patientDetail,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PatientDetailPage(patientId: id);
          },
          routes: [
            GoRoute(
              path: 'edit',
              name: RouteNames.patientEdit,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PatientFormPage(patientId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
),
```

Resulting paths: `/home/patients`, `/home/patients/new`, `/home/patients/:id`, `/home/patients/:id/edit`.

## Pagination Strategy

**Decision**: Offset-based pagination using Supabase `.range(from, to)`.

**Rationale**:
- Supabase's client SDK has first-class support for `.range()` which maps to SQL `LIMIT/OFFSET`.
- Cursor-based pagination would require maintaining a cursor token and more complex query logic. For a patient list that is sorted by `created_at DESC` or `last_name ASC` with a single clinic scope (max ~50k rows per SC-007), offset pagination is performant.
- The patient list is not real-time and doesn't need gap-free pagination guarantees.
- Page size: 20 records. Load more on scroll via `PatientListCubit.loadMore()`.

**Implementation**:
```dart
// In PatientRemoteDataSource:
final from = page * pageSize;
final to = from + pageSize - 1;
final response = await supabase
    .from('patients')
    .select()
    .eq('clinic_id', clinicId)
    .eq('is_active', true)
    .order('created_at', ascending: false)
    .range(from, to);
```

## Search Strategy

**Decision**: Supabase `ilike` with `or` filter for multi-field search.

**Rationale**:
- Full-text search (Postgres `tsvector`/`tsquery`) is overkill for searching 4 fields (name, phone, national_id, patient_number) with simple prefix/contains matching.
- `ilike` with `%query%` patterns is simple, well-supported by Supabase client SDK, and sufficient for the expected data volumes (≤50k patients per clinic).
- The composite indexes on `(clinic_id, last_name, first_name)` and `(clinic_id, phone_number)` will speed up the most common lookups.

**Implementation**:
```dart
// In PatientRemoteDataSource:
final query = searchQuery.trim();
final response = await supabase
    .from('patients')
    .select()
    .eq('clinic_id', clinicId)
    .eq('is_active', true)
    .or('first_name.ilike.%$query%,last_name.ilike.%$query%,'
        'phone_number.ilike.%$query%,national_id.ilike.%$query%,'
        'patient_number.ilike.%$query%')
    .order('last_name')
    .limit(20);
```

**Global search**: Uses `PatientSearchDelegate` (extends Flutter's `SearchDelegate`) which internally calls `SearchPatients` use case with debounced input (300ms via `Timer`).

## Integration with ClinicCubit

Patient operations are scoped to the currently selected clinic. The `clinicId` flows as follows:

```
ClinicCubit.state (ClinicLoaded)
  ↓ .selectedClinicId
PatientListPage / PatientFormPage (reads from BlocProvider<ClinicCubit>)
  ↓ passes clinicId to cubit methods
PatientListCubit.loadPatients(clinicId) / PatientDetailCubit.createPatient(params)
  ↓ params include clinicId
Use Cases (CreatePatient, GetPatientsList, SearchPatients, etc.)
  ↓ params.clinicId
PatientRepository → PatientRemoteDataSource
  ↓ .eq('clinic_id', clinicId)
Supabase (RLS provides defense-in-depth)
```

Patient cubits do NOT hold a reference to ClinicCubit. Instead, pages read `clinicId` from `context.read<ClinicCubit>().state` and pass it explicitly to cubit methods. This keeps the patient feature decoupled from clinic internals.

## Complexity Tracking

> No constitution violations. Table left empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| (none) | — | — |
