# Tasks: Patient Management

**Input**: Design documents from `/specs/005-patients/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: Not requested — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/features/patient/` for feature code, `lib/core/` for shared core modifications
- Paths are relative to repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Database migration and core utility preparation

- [X] T001 Apply Supabase migration from specs/005-patients/contracts/supabase-migration.sql in the Supabase SQL editor (creates patients table, patient_gender enum, generate_patient_number() trigger, indexes, RLS policies)
- [X] T002 [P] Add dateNotFuture validator to lib/core/utils/app_validators.dart — static method returning `String? Function(String?)` that rejects future dates; follows existing pattern (required, phone, email, compose)
- [X] T003 [P] Add patient route names (patientList, patientNew, patientDetail, patientEdit) to lib/core/router/route_names.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain entities, data model, repository, use cases, data layer, and DI registration. MUST be complete before any user story phase.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### Domain Entities

- [X] T004 [P] Create Gender enum (male, female, other) with fromString/toString converters in lib/features/patient/domain/entities/gender.dart
- [X] T005 [P] Create BloodType enum (aPositive, aNegative, bPositive, bNegative, abPositive, abNegative, oPositive, oNegative) with fromString/toString converters mapping to DB values ('A+', 'A-', etc.) in lib/features/patient/domain/entities/blood_type.dart
- [X] T006 Create Patient entity (Equatable, 18 fields, computed fullName and age) in lib/features/patient/domain/entities/patient.dart — imports Gender and BloodType enums

### Data Model

- [X] T007 Create PatientModel (@freezed) with toEntity() extension and JSON field mappings (snake_case ↔ camelCase) using Gender/BloodType converters in lib/features/patient/data/models/patient_model.dart

### Repository Interface

- [X] T008 Create abstract PatientRepository with 6 methods (createPatient, updatePatient, getPatientById, searchPatients, getPatientsList, deactivatePatient) in lib/features/patient/domain/repositories/patient_repository.dart — include CreatePatientParams, UpdatePatientParams, SearchPatientsParams, GetPatientsListParams as Equatable classes in the same file

### Use Cases

- [X] T009 [P] Create CreatePatient use case (UseCaseWithParams<Patient, CreatePatientParams>) in lib/features/patient/domain/usecases/create_patient.dart
- [X] T010 [P] Create UpdatePatient use case (UseCaseWithParams<Patient, UpdatePatientParams>) in lib/features/patient/domain/usecases/update_patient.dart
- [X] T011 [P] Create GetPatientById use case (UseCaseWithParams<Patient, String>) in lib/features/patient/domain/usecases/get_patient_by_id.dart
- [X] T012 [P] Create SearchPatients use case (UseCaseWithParams<List<Patient>, SearchPatientsParams>) in lib/features/patient/domain/usecases/search_patients.dart
- [X] T013 [P] Create GetPatientsList use case (UseCaseWithParams<List<Patient>, GetPatientsListParams>) in lib/features/patient/domain/usecases/get_patients_list.dart
- [X] T014 [P] Create DeactivatePatient use case (UseCaseWithParams<void, String>) in lib/features/patient/domain/usecases/deactivate_patient.dart

### Data Layer

- [X] T015 Create PatientRemoteDataSource (abstract + impl) with all 6 Supabase query methods (create, update, getById, search with ilike/or, paginated list with .range(), deactivate) in lib/features/patient/data/datasources/patient_remote_data_source.dart
- [X] T016 Create PatientRepositoryImpl (implements PatientRepository, wraps data source calls with try/catch returning Either<Failure, T>) in lib/features/patient/data/repositories/patient_repository_impl.dart

### Dependency Injection

- [X] T017 Create patient DI registration function initPatient() registering data source, repository, all 6 use cases, and both cubits (PatientListCubit as factory, PatientDetailCubit as factory) in lib/features/patient/di/patient_injection.dart — follow clinic_injection.dart pattern
- [X] T018 Register initPatient() call in lib/core/di/injection_container.dart — add `await initPatient();` after `await initClinic();` and before the router registration block

### Code Generation

- [X] T019 Run `dart run build_runner build --delete-conflicting-outputs` to generate freezed/json_serializable code for PatientModel

**Checkpoint**: Foundation ready — all domain, data, and DI layers complete. User story implementation can now begin.

---

## Phase 3: User Story 3 — Browse Patient List with Pagination (Priority: P1) 🏠 Entry Point

**Goal**: Staff can see a paginated list of patients for their current clinic. Each list item shows patient number, full name, phone, and age. Infinite scroll loads 20 patients per page. In-list search filters by name, phone, national ID, or patient number.

**Independent Test**: Open app → select clinic → navigate to patients → list displays. Scroll to load more pages. Type in search bar to filter.

### Implementation for User Story 3

- [X] T020 [P] [US3] Create PatientListState sealed class (PatientListInitial, PatientListLoading, PatientListLoaded with patients/page/hasMore/searchQuery, PatientListError with message) in lib/features/patient/presentation/cubit/patient_list_state.dart
- [X] T021 [US3] Create PatientListCubit with loadPatients(clinicId), loadMore(clinicId), searchPatients(clinicId, query) methods — uses GetPatientsList and SearchPatients use cases, manages pagination offset in lib/features/patient/presentation/cubit/patient_list_cubit.dart
- [X] T022 [P] [US3] Create PatientListTile widget showing patient number, fullName, phoneNumber, and computed age in lib/features/patient/presentation/pages/widgets/patient_list_tile.dart
- [X] T023 [US3] Create PatientListPage with search bar at top, ListView.builder with infinite scroll (fires loadMore on scroll end), empty state ("No patients yet. Tap + to register your first patient."), loading/error states — uses BlocProvider<PatientListCubit>, reads clinicId from context.read<ClinicCubit>().state in lib/features/patient/presentation/pages/patient_list_page.dart
- [X] T024 [US3] Register /home/patients GoRoute as sub-route of /home in lib/core/router/app_router.dart — builder returns PatientListPage

**Checkpoint**: Patient list page loads with pagination and in-list search. No FAB yet — browsing only.

---

## Phase 4: User Story 1 — Register a New Patient (Priority: P1) 🎯 MVP

**Goal**: Staff can create a new patient with required fields (first name, last name, DOB, phone) and optional fields (gender, email, national ID, blood type, address, emergency contact, notes). On save, patient is created with auto-generated P-NNNN number and user navigates to detail screen.

**Independent Test**: Open patient list → tap FAB → fill required fields → save → patient detail screen shows new patient with generated number → back to list → new patient appears.

### Implementation for User Story 1

- [X] T025 [P] [US1] Create PatientDetailState sealed class (PatientDetailInitial, PatientDetailLoading, PatientDetailLoaded with patient, PatientDetailSaved with patient, PatientDetailError with message) in lib/features/patient/presentation/cubit/patient_detail_state.dart
- [X] T026 [US1] Create PatientDetailCubit with createPatient(CreatePatientParams) and loadPatient(String id) methods — uses CreatePatient and GetPatientById use cases in lib/features/patient/presentation/cubit/patient_detail_cubit.dart
- [X] T027 [P] [US1] Create GenderSelector widget (segmented buttons or dropdown for Gender enum) in lib/features/patient/presentation/pages/widgets/gender_selector.dart
- [X] T028 [P] [US1] Create BloodTypeDropdown widget (DropdownButtonFormField for BloodType enum values: A+, A−, B+, B−, AB+, AB−, O+, O−) in lib/features/patient/presentation/pages/widgets/blood_type_dropdown.dart
- [X] T029 [P] [US1] Create PatientFormFields widget composing all form fields using AppFormField.buildTextField with AppValidators (required for firstName/lastName/DOB/phone, email validator for email, phone validator for emergencyContactPhone, dateNotFuture for DOB) in lib/features/patient/presentation/pages/widgets/patient_form_fields.dart
- [X] T030 [US1] Create PatientFormPage in create mode — Form with PatientFormFields + GenderSelector + BloodTypeDropdown, Save button triggers PatientDetailCubit.createPatient, BlocListener navigates to detail on PatientDetailSaved, preserves form data on error (FR-014) in lib/features/patient/presentation/pages/patient_form_page.dart
- [X] T031 [P] [US1] Create PatientInfoSection widget displaying all patient fields in a structured layout in lib/features/patient/presentation/pages/widgets/patient_info_section.dart
- [X] T032 [US1] Create PatientDetailPage (view mode) showing patient info via PatientInfoSection, basic AppBar with title — uses BlocProvider<PatientDetailCubit>, loads patient by id in lib/features/patient/presentation/pages/patient_detail_page.dart
- [X] T033 [US1] Register /home/patients/new, /home/patients/:id, and /home/patients/:id/edit GoRoutes as sub-routes of /home/patients in lib/core/router/app_router.dart — :id routes extract pathParameters['id']
- [X] T034 [US1] Add FloatingActionButton to PatientListPage that navigates to RouteNames.patientNew in lib/features/patient/presentation/pages/patient_list_page.dart

**Checkpoint**: Full registration flow — list → add → fill form → save → view detail → back to list (refreshed). Patient number auto-generated by Supabase trigger.

---

## Phase 5: User Story 2 — View and Edit Patient Profile (Priority: P1)

**Goal**: Staff can view a patient's full profile with tabbed sections (Info, Appointments, Medical History, Billing — last 3 show "Coming Soon"). Staff can tap Edit to modify any field.

**Independent Test**: Tap patient in list → detail screen with tabs → Info tab shows all data → tap Edit → form pre-fills → change a field → save → detail reflects change.

### Implementation for User Story 2

- [X] T035 [P] [US2] Create ComingSoonTab widget (centered icon + "Coming Soon" text) in lib/features/patient/presentation/pages/widgets/coming_soon_tab.dart
- [X] T036 [US2] Enhance PatientDetailPage with TabBar/TabBarView (Info tab using PatientInfoSection, Appointments/Medical History/Billing tabs using ComingSoonTab), add Edit IconButton in AppBar in lib/features/patient/presentation/pages/patient_detail_page.dart
- [X] T037 [US2] Add updatePatient(UpdatePatientParams) method to PatientDetailCubit in lib/features/patient/presentation/cubit/patient_detail_cubit.dart
- [X] T038 [US2] Add edit mode to PatientFormPage — accept optional patientId parameter, when present load patient via PatientDetailCubit.loadPatient and pre-fill all form fields, Save triggers updatePatient instead of createPatient in lib/features/patient/presentation/pages/patient_form_page.dart

**Checkpoint**: Full view + edit flow — list → detail (with tabs) → edit → save → updated detail screen.

---

## Phase 6: User Story 4 — Search Patients Globally (Priority: P2)

**Goal**: Staff can tap a search icon to perform global patient search with debounced real-time results (300ms). Tapping a result navigates to patient detail.

**Independent Test**: Tap search icon → type 2+ characters → results appear within 300ms → tap result → patient detail screen opens.

### Implementation for User Story 4

- [X] T039 [US4] Create PatientSearchDelegate (extends SearchDelegate) with debounced search (300ms Timer), calls SearchPatients use case, displays results as PatientListTile items, tap navigates to RouteNames.patientDetail in lib/features/patient/presentation/pages/patient_search_delegate.dart
- [X] T040 [US4] Add search IconButton to PatientListPage AppBar that launches showSearch with PatientSearchDelegate in lib/features/patient/presentation/pages/patient_list_page.dart

**Checkpoint**: Global search accessible from patient list with real-time debounced results.

---

## Phase 7: User Story 5 — Deactivate a Patient (Priority: P3)

**Goal**: Staff can soft-delete a patient from the detail screen. Deactivated patients disappear from list and search results.

**Independent Test**: Open patient detail → tap Deactivate → confirm → patient disappears from list and search.

### Implementation for User Story 5

- [X] T041 [US5] Add deactivatePatient(String id) method to PatientDetailCubit using DeactivatePatient use case in lib/features/patient/presentation/cubit/patient_detail_cubit.dart
- [X] T042 [US5] Add Deactivate action to PatientDetailPage — menu item or button with confirmation dialog, on confirm calls PatientDetailCubit.deactivatePatient, navigates back to list on success in lib/features/patient/presentation/pages/patient_detail_page.dart

**Checkpoint**: Deactivation works — patient removed from active list and search results.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Validation and quality assurance across all user stories

- [X] T043 [P] Verify all form fields use AppFormField.buildTextField with AppValidators.compose for composed validators in lib/features/patient/presentation/pages/widgets/patient_form_fields.dart
- [X] T044 [P] Verify no PHI (patient names, DOB, phone numbers) appears in debug logs or error messages across all files in lib/features/patient/
- [X] T045 Run quickstart.md validation flow (specs/005-patients/quickstart.md) end-to-end: sign in → select clinic → patients → create → list → detail → edit → search → deactivate

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 completion (route names needed for DI, validator needed for form validation) — **BLOCKS all user stories**
- **US3 — List (Phase 3)**: Depends on Phase 2 completion — first presentation layer
- **US1 — Register (Phase 4)**: Depends on Phase 3 completion (PatientListPage must exist to add FAB)
- **US2 — View/Edit (Phase 5)**: Depends on Phase 4 completion (PatientDetailPage and PatientFormPage must exist to enhance)
- **US4 — Global Search (Phase 6)**: Depends on Phase 3 completion (PatientListPage AppBar must exist; PatientSearchDelegate is independent)
- **US5 — Deactivate (Phase 7)**: Depends on Phase 4 completion (PatientDetailCubit and PatientDetailPage must exist to extend)
- **Polish (Phase 8)**: Depends on all user story phases being complete

### User Story Dependencies

- **US3 (P1) — List**: Can start after Foundational (Phase 2) — no dependencies on other stories
- **US1 (P1) — Register**: Depends on US3 (needs list page for FAB and navigation entry point)
- **US2 (P1) — View/Edit**: Depends on US1 (needs detail page and form page to enhance)
- **US4 (P2) — Global Search**: Can start after US3 (needs list page AppBar) — independent of US1/US2
- **US5 (P3) — Deactivate**: Can start after US1 (needs detail page and cubit) — independent of US2/US4

### Within Each User Story

- State classes before cubits
- Widgets before pages (pages compose widgets)
- Pages before route registration (routes reference page classes)
- Core implementation before integration touches (e.g., adding FAB to existing page)

### Parallel Opportunities

**Phase 1**: T002 and T003 can run in parallel (different files)
**Phase 2**: T004+T005 in parallel → T006 depends on both → T007 depends on T006 → T008 after T006 → T009–T014 all in parallel → T015 after T008 → T016 after T008+T015 → T017 after all above → T018 after T017 → T019 after T007+T017
**Phase 3**: T020+T022 in parallel → T021 after T020 → T023 after T021+T022 → T024 after T023
**Phase 4**: T025+T027+T028+T029+T031 all in parallel → T026 after T025 → T030 after T026+T027+T028+T029 → T032 after T026+T031 → T033 after T030+T032 → T034 after T033
**Phase 5**: T035 can start immediately → T036 after T035 → T037 independent → T038 after T037
**Phase 6**: T039 independent → T040 after T039
**Phase 7**: T041 independent → T042 after T041

---

## Parallel Example: Phase 2 (Foundational)

```text
# Parallel batch 1 — enums (different files, no dependencies):
T004: Create Gender enum in lib/features/patient/domain/entities/gender.dart
T005: Create BloodType enum in lib/features/patient/domain/entities/blood_type.dart

# Sequential — entity depends on enums:
T006: Create Patient entity in lib/features/patient/domain/entities/patient.dart

# Sequential — model depends on entity + enums:
T007: Create PatientModel in lib/features/patient/data/models/patient_model.dart

# Sequential — repository interface depends on entity:
T008: Create PatientRepository in lib/features/patient/domain/repositories/patient_repository.dart

# Parallel batch 2 — all use cases (different files, depend on T008):
T009–T014: All 6 use cases in parallel

# Sequential — data source depends on repository interface:
T015: Create PatientRemoteDataSource
T016: Create PatientRepositoryImpl

# Sequential — DI depends on all above:
T017: patient_injection.dart
T018: injection_container.dart

# Sequential — code gen depends on T007:
T019: build_runner
```

## Parallel Example: Phase 4 (US1 — Register)

```text
# Parallel batch 1 — state + widgets (different files, no dependencies):
T025: PatientDetailState sealed class
T027: GenderSelector widget
T028: BloodTypeDropdown widget
T029: PatientFormFields widget
T031: PatientInfoSection widget

# Sequential — cubit depends on state:
T026: PatientDetailCubit

# Sequential — form page depends on cubit + widgets:
T030: PatientFormPage

# Sequential — detail page depends on cubit + info section:
T032: PatientDetailPage

# Sequential — routes depend on pages:
T033: Register routes in app_router.dart

# Sequential — FAB depends on routes:
T034: Add FAB to PatientListPage
```

---

## Implementation Strategy

### MVP First (US3 + US1)

1. Complete Phase 1: Setup (migration + validators + route names)
2. Complete Phase 2: Foundational (all domain + data + DI)
3. Complete Phase 3: US3 — Patient list with pagination and search
4. Complete Phase 4: US1 — Patient registration flow
5. **STOP and VALIDATE**: Register a patient, see it in the list, view detail
6. Deploy/demo if ready — this is the minimum viable patient management

### Incremental Delivery

1. Phase 1 + Phase 2 → Foundation ready
2. + Phase 3 (US3) → Browse patients (empty state or seeded data)
3. + Phase 4 (US1) → Register patients → **MVP COMPLETE**
4. + Phase 5 (US2) → Full view/edit → Core CRUD complete
5. + Phase 6 (US4) → Global search → Enhanced discovery
6. + Phase 7 (US5) → Deactivation → Administrative housekeeping
7. + Phase 8 → Polish → Production-ready

### Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [Story] label maps task to specific user story for traceability
- Each user story phase is independently testable after the preceding dependencies
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- US3 is ordered before US1 (both P1) because the list page is the entry point for the registration flow
