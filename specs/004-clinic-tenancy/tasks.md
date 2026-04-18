# Tasks: Clinic & Multi-Tenant Setup

**Input**: Design documents from `/specs/004-clinic-tenancy/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/supabase-migration.sql

**Tests**: Not requested — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, Supabase migration, and shared directory scaffolding

- [x] T001 Apply Supabase migration from specs/004-clinic-tenancy/contracts/supabase-migration.sql (enum types, tables, triggers, RLS policies, RPC functions)
- [x] T002 Create feature directory structure under lib/features/clinic/ (di/, domain/entities/, domain/repositories/, domain/usecases/, data/datasources/, data/models/, data/repositories/, presentation/cubit/, presentation/pages/, presentation/pages/widgets/)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain entities, enums, abstract repository, data models, data source, and repository implementation that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 [P] Create ClinicType enum with dbValue getter and fromDbValue factory in lib/features/clinic/domain/entities/clinic_type.dart
- [x] T004 [P] Create StaffRole enum with dbValue getter and fromDbValue factory in lib/features/clinic/domain/entities/staff_role.dart
- [x] T005 [P] Create Clinic entity (Equatable) with fields: id, name, phone, address, type, inviteCode, isActive, createdAt, updatedAt in lib/features/clinic/domain/entities/clinic.dart
- [x] T006 [P] Create StaffAssignment entity (Equatable) with fields: id, userId, clinicId, role, isActive, joinedAt, updatedAt, userName in lib/features/clinic/domain/entities/staff_assignment.dart
- [x] T007 [P] Create Location entity (Equatable) with fields: id, clinicId, name, address, phone, isActive, createdAt, updatedAt in lib/features/clinic/domain/entities/location.dart
- [x] T008 Create abstract ClinicRepository with all 8 methods (createClinic, joinClinicByCode, getMyClinicAssignments, getClinicStaff, updateClinic, updateStaffRole, deactivateStaff, regenerateInviteCode) in lib/features/clinic/domain/repositories/clinic_repository.dart
- [x] T009 [P] Create ClinicModel (freezed + json_serializable) with toEntity()/fromEntity() in lib/features/clinic/data/models/clinic_model.dart
- [x] T010 [P] Create StaffAssignmentModel (freezed + json_serializable) with toEntity()/fromEntity() in lib/features/clinic/data/models/staff_assignment_model.dart
- [x] T011 [P] Create LocationModel (freezed + json_serializable) with toEntity()/fromEntity() in lib/features/clinic/data/models/location_model.dart
- [x] T012 Create ClinicRemoteDataSource (abstract + implementation) with Supabase queries and RPC calls for all 8 operations in lib/features/clinic/data/datasources/clinic_remote_data_source.dart
- [x] T013 Create ClinicRepositoryImpl implementing ClinicRepository, delegating to ClinicRemoteDataSource, mapping exceptions to Failures in lib/features/clinic/data/repositories/clinic_repository_impl.dart
- [x] T014 Run `dart run build_runner build --delete-conflicting-outputs` to generate .freezed.dart and .g.dart files for all three models

**Checkpoint**: Foundation ready — domain, data, and models are complete. User story implementation can now begin.

---

## Phase 3: User Story 1 — Create a New Clinic (Priority: P1) 🎯 MVP

**Goal**: A doctor with no clinic can create one, becoming clinic_admin, with invite code and default location auto-generated.

**Independent Test**: Sign in as a new doctor → complete profile → choose "Create Clinic" → fill form → verify clinic created with admin role and invite code.

### Use Cases for User Story 1

- [x] T015 [P] [US1] Create CreateClinic use case (UseCaseWithParams<Clinic, CreateClinicParams>) with CreateClinicParams (Equatable) in lib/features/clinic/domain/usecases/create_clinic.dart
- [x] T016 [P] [US1] Create GetMyClinicAssignments use case (UseCaseWithoutParams<List<StaffAssignment>>) in lib/features/clinic/domain/usecases/get_my_clinic_assignments.dart

### Presentation for User Story 1

- [x] T017 [US1] Create ClinicState sealed class (ClinicInitial, ClinicLoading, ClinicLoaded, ClinicError) in lib/features/clinic/presentation/cubit/clinic_state.dart
- [x] T018 [US1] Create ClinicCubit with loadAssignments(), selectClinic(), createClinic() methods in lib/features/clinic/presentation/cubit/clinic_cubit.dart
- [x] T019 [US1] Create ClinicCubitRefreshListenable (ChangeNotifier bridge for GoRouter) in lib/features/clinic/presentation/cubit/clinic_cubit_refresh_listenable.dart
- [x] T020 [P] [US1] Create ClinicTypeDropdown widget for clinic type selection in lib/features/clinic/presentation/pages/widgets/clinic_type_dropdown.dart
- [x] T021 [US1] Create ClinicOrJoinPage with "Create Clinic" and "Join Clinic" choice buttons in lib/features/clinic/presentation/pages/clinic_or_join_page.dart
- [x] T022 [US1] Create CreateClinicPage with form fields (name, phone, address, type) using AppFormField and AppValidators in lib/features/clinic/presentation/pages/create_clinic_page.dart

### Integration for User Story 1

- [x] T023 [US1] Create initClinic() DI function registering data source, repository, use cases (CreateClinic, GetMyClinicAssignments), and ClinicCubit in lib/features/clinic/di/clinic_injection.dart
- [x] T024 [US1] Modify lib/core/di/injection_container.dart to import and call await initClinic() after initAuth()
- [x] T025 [US1] Modify lib/core/router/route_names.dart to add clinicSetup, createClinic, joinClinic route name constants
- [x] T026 [US1] Modify lib/core/router/app_router.dart to accept ClinicCubit, add /clinic-setup and /create-clinic routes, extend redirect logic with clinic-state checks (steps 4-6), merge AuthCubitRefreshListenable + ClinicCubitRefreshListenable via Listenable.merge
- [x] T027 [US1] Modify lib/app.dart to replace BlocProvider<AuthCubit> with MultiBlocProvider wrapping both AuthCubit and ClinicCubit

**Checkpoint**: A doctor can create a clinic and reach the dashboard. Core flow (auth → profile → clinic → dashboard) is complete.

---

## Phase 4: User Story 2 — Join an Existing Clinic via Invite Code (Priority: P1)

**Goal**: A doctor with no clinic enters an invite code, confirms the clinic name, and is added as a staff member with role "doctor".

**Independent Test**: Create a clinic (US1) → copy invite code → sign in as different doctor → enter code → confirm → verify added to staff.

### Use Cases for User Story 2

- [x] T028 [P] [US2] Create JoinClinicByCode use case (UseCaseWithParams<StaffAssignment, JoinClinicByCodeParams>) with JoinClinicByCodeParams (Equatable) in lib/features/clinic/domain/usecases/join_clinic_by_code.dart

### Presentation for User Story 2

- [x] T029 [US2] Add joinClinic() and lookupClinicByCode() methods to ClinicCubit in lib/features/clinic/presentation/cubit/clinic_cubit.dart
- [x] T030 [US2] Create JoinClinicPage with invite code input field, clinic name confirmation, and confirm button using AppFormField in lib/features/clinic/presentation/pages/join_clinic_page.dart

### Integration for User Story 2

- [x] T031 [US2] Register JoinClinicByCode use case in initClinic() in lib/features/clinic/di/clinic_injection.dart
- [x] T032 [US2] Modify lib/core/router/route_names.dart to add joinClinic route constant (if not done in T025) and add /join-clinic route in lib/core/router/app_router.dart

**Checkpoint**: Both clinic creation and joining via invite code work. Any new doctor can enter the system.

---

## Phase 5: User Story 3 — Select a Clinic After Login (Priority: P2)

**Goal**: A multi-clinic doctor sees a clinic selector after login, selects a clinic, and all subsequent data is scoped to it.

**Independent Test**: Join a doctor to two clinics → sign in → verify selector appears → select one → verify dashboard loads scoped to that clinic.

### Presentation for User Story 3

- [x] T033 [P] [US3] Create ClinicCard widget for displaying clinic info in selector in lib/features/clinic/presentation/pages/widgets/clinic_card.dart
- [x] T034 [US3] Create ClinicSelectorPage showing list of user's active clinics with tap-to-select in lib/features/clinic/presentation/pages/clinic_selector_page.dart

### Integration for User Story 3

- [x] T035 [US3] Modify lib/core/router/route_names.dart to add clinicSelector route constant and add /clinic-selector route in lib/core/router/app_router.dart
- [x] T036 [US3] Verify router redirect logic handles: 1 clinic → auto-select + skip selector, >1 clinic → show selector, 0 clinics → clinic-setup

**Checkpoint**: Multi-clinic flow works. Single-clinic doctors skip selector. Multi-clinic doctors choose which clinic to work in.

---

## Phase 6: User Story 4 — Manage Clinic Settings (Priority: P3)

**Goal**: A clinic admin can edit clinic details (name, phone, address, type) and regenerate the invite code.

**Independent Test**: Sign in as clinic admin → navigate to settings → change clinic name → save → verify change persists. Regenerate invite code → verify old code rejects.

### Use Cases for User Story 4

- [x] T037 [P] [US4] Create UpdateClinic use case (UseCaseWithParams<Clinic, UpdateClinicParams>) with UpdateClinicParams (Equatable) in lib/features/clinic/domain/usecases/update_clinic.dart
- [x] T038 [P] [US4] Create RegenerateInviteCode use case (UseCaseWithParams<Clinic, RegenerateInviteCodeParams>) with RegenerateInviteCodeParams (Equatable) in lib/features/clinic/domain/usecases/regenerate_invite_code.dart

### Presentation for User Story 4

- [x] T039 [US4] Add updateClinic() and regenerateInviteCode() methods to ClinicCubit in lib/features/clinic/presentation/cubit/clinic_cubit.dart
- [x] T040 [US4] Create ClinicSettingsPage with editable form fields for clinic details and regenerate invite code button in lib/features/clinic/presentation/pages/clinic_settings_page.dart

### Integration for User Story 4

- [x] T041 [US4] Register UpdateClinic and RegenerateInviteCode use cases in initClinic() in lib/features/clinic/di/clinic_injection.dart
- [x] T042 [US4] Modify lib/core/router/route_names.dart to add clinicSettings route constant and add /clinic-settings route in lib/core/router/app_router.dart

**Checkpoint**: Clinic admins can manage their clinic details and rotate invite codes.

---

## Phase 7: User Story 5 — Manage Clinic Staff (Priority: P3)

**Goal**: A clinic admin can view staff, change roles, and deactivate members (with safeguards against removing last admin or self-deactivating).

**Independent Test**: Sign in as admin → view staff list → change a member's role → verify change → deactivate a member → verify removed from active list. Attempt self-deactivation → verify prevented.

### Use Cases for User Story 5

- [x] T043 [P] [US5] Create GetClinicStaff use case (UseCaseWithParams<List<StaffAssignment>, GetClinicStaffParams>) with GetClinicStaffParams (Equatable) in lib/features/clinic/domain/usecases/get_clinic_staff.dart
- [x] T044 [P] [US5] Create UpdateStaffRole use case (UseCaseWithParams<StaffAssignment, UpdateStaffRoleParams>) with UpdateStaffRoleParams (Equatable) in lib/features/clinic/domain/usecases/update_staff_role.dart
- [x] T045 [P] [US5] Create DeactivateStaff use case (UseCaseWithParams<void, DeactivateStaffParams>) with DeactivateStaffParams (Equatable) in lib/features/clinic/domain/usecases/deactivate_staff.dart

### Presentation for User Story 5

- [x] T046 [US5] Add loadStaff(), updateStaffRole(), and deactivateStaff() methods to ClinicCubit in lib/features/clinic/presentation/cubit/clinic_cubit.dart
- [x] T047 [P] [US5] Create StaffMemberTile widget showing name, role, and action buttons in lib/features/clinic/presentation/pages/widgets/staff_member_tile.dart
- [x] T048 [P] [US5] Create RoleSelectorDialog for changing a staff member's role in lib/features/clinic/presentation/pages/widgets/role_selector_dialog.dart
- [x] T049 [US5] Create StaffListPage displaying active staff with role change and deactivate actions in lib/features/clinic/presentation/pages/staff_list_page.dart

### Integration for User Story 5

- [x] T050 [US5] Register GetClinicStaff, UpdateStaffRole, and DeactivateStaff use cases in initClinic() in lib/features/clinic/di/clinic_injection.dart
- [x] T051 [US5] Modify lib/core/router/route_names.dart to add staffList route constant and add /staff-list route in lib/core/router/app_router.dart

**Checkpoint**: Full staff management works. Admin safeguards (no self-deactivation, no last-admin removal) enforced by RPC.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Code generation, static analysis, and final validation

- [x] T052 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate .freezed.dart and .g.dart after all model changes
- [x] T053 Run `flutter analyze` and fix any warnings or errors to achieve zero issues
- [x] T054 Verify full redirect chain: unauthenticated → welcome → auth → profile-setup → clinic-setup → create/join → (selector if multi) → dashboard
- [x] T055 Run quickstart.md validation: confirm all 37 files from quickstart.md exist and are non-empty

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (directory structure) — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Phase 2 completion
- **User Story 2 (Phase 4)**: Depends on Phase 2 completion. Can run in parallel with US1 but shares ClinicCubit (best done after US1)
- **User Story 3 (Phase 5)**: Depends on Phase 2. Depends on US1 for ClinicCubit/router setup
- **User Story 4 (Phase 6)**: Depends on Phase 2. Depends on US1 for ClinicCubit
- **User Story 5 (Phase 7)**: Depends on Phase 2. Depends on US1 for ClinicCubit
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Gateway story — establishes ClinicCubit, router integration, and DI. Should be implemented FIRST.
- **US2 (P1)**: Can start after US1 (needs ClinicCubit + router from US1). Adds to existing cubit/router.
- **US3 (P2)**: Can start after US1. Adds selector page and routing refinement.
- **US4 (P3)**: Can start after US1. Adds settings page + use cases.
- **US5 (P3)**: Can start after US1. Adds staff page + use cases.

### Within Each User Story

- Use cases (domain) before presentation (depends on use case types)
- Cubit methods before pages (pages call cubit)
- DI registration before router integration (router needs registered cubit)

### Parallel Opportunities

Within Phase 2 (Foundational):
- T003, T004, T005, T006, T007 (all entities/enums) — all parallel
- T009, T010, T011 (all models) — all parallel (after entities exist)

Within Phase 3 (US1):
- T015, T016 (use cases) — parallel

Within Phase 7 (US5):
- T043, T044, T045 (use cases) — all parallel
- T047, T048 (widgets) — parallel

After US1 is complete:
- US3 (P2), US4 (P3), US5 (P3) can theoretically run in parallel

---

## Parallel Example: Foundational Phase

```bash
# Launch all entities/enums in parallel:
T003: Create ClinicType enum in lib/features/clinic/domain/entities/clinic_type.dart
T004: Create StaffRole enum in lib/features/clinic/domain/entities/staff_role.dart
T005: Create Clinic entity in lib/features/clinic/domain/entities/clinic.dart
T006: Create StaffAssignment entity in lib/features/clinic/domain/entities/staff_assignment.dart
T007: Create Location entity in lib/features/clinic/domain/entities/location.dart

# Then launch all models in parallel:
T009: Create ClinicModel in lib/features/clinic/data/models/clinic_model.dart
T010: Create StaffAssignmentModel in lib/features/clinic/data/models/staff_assignment_model.dart
T011: Create LocationModel in lib/features/clinic/data/models/location_model.dart
```

## Parallel Example: User Story 5

```bash
# Launch all use cases in parallel:
T043: Create GetClinicStaff use case
T044: Create UpdateStaffRole use case
T045: Create DeactivateStaff use case

# Launch widgets in parallel:
T047: Create StaffMemberTile widget
T048: Create RoleSelectorDialog widget
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (Supabase migration + directory scaffolding)
2. Complete Phase 2: Foundational (entities, models, data source, repository)
3. Complete Phase 3: User Story 1 (create clinic + full routing + DI)
4. **STOP and VALIDATE**: A new doctor can create a clinic and reach dashboard
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (Create Clinic) → Test: new doctor creates clinic → **MVP!**
3. Add US2 (Join Clinic) → Test: doctor joins via invite code → Deploy/Demo
4. Add US3 (Clinic Selector) → Test: multi-clinic doctor selects clinic → Deploy/Demo
5. Add US4 (Clinic Settings) → Test: admin edits clinic + regenerates code → Deploy/Demo
6. Add US5 (Staff Management) → Test: admin manages staff roles/deactivation → Deploy/Demo
7. Polish phase → Full redirect chain verified, flutter analyze clean

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (MUST go first — establishes cubit + routing)
3. Once US1 is done:
   - Developer A: User Story 2
   - Developer B: User Story 3
   - Developer C: User Stories 4 + 5
4. Stories integrate independently via shared ClinicCubit

---

## Notes

- [P] tasks = different files, no dependencies on other incomplete tasks
- [Story] label maps task to specific user story for traceability
- US1 is the gateway story — it creates ClinicCubit, router integration, and DI that all other stories build on
- US2 is P1 alongside US1 but best done sequentially since it extends the same cubit
- US4 and US5 are both P3 and independent of each other
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
