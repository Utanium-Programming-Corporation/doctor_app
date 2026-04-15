# Tasks: Scheduling & Appointments

**Input**: Design documents from `/specs/006-scheduling-appointments/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/supabase-migration.sql ✅

**Tests**: Not explicitly requested — test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create feature module directory structure and run database migration

- [X] T001 Create scheduling feature directory structure per plan.md under `lib/features/scheduling/` (domain/, data/, presentation/, di/ with all subdirectories)
- [X] T002 Run Supabase migration from `specs/006-scheduling-appointments/contracts/supabase-migration.sql` (creates appointment_types, provider_availability, provider_blocked_dates, appointments tables with RLS, EXCLUDE constraint, triggers, and indexes)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain entities, enums, repository interfaces, and param classes that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] Create AppointmentStatus enum with transition map, `canTransitionTo()`, `fromDbValue()`, `toDbValue()`, `displayName`, `isTerminal` in `lib/features/scheduling/domain/entities/appointment_status.dart`
- [X] T004 [P] Create AppointmentType entity (Equatable) with all fields from data-model.md in `lib/features/scheduling/domain/entities/appointment_type.dart`
- [X] T005 [P] Create ProviderAvailability entity (Equatable) with all fields from data-model.md in `lib/features/scheduling/domain/entities/provider_availability.dart`
- [X] T006 [P] Create BlockedDate entity (Equatable) with all fields from data-model.md in `lib/features/scheduling/domain/entities/blocked_date.dart`
- [X] T007 [P] Create TimeSlot value object (Equatable) with startTime, endTime, durationMinutes, formattedTimeRange in `lib/features/scheduling/domain/entities/time_slot.dart`
- [X] T008 Create Appointment entity (Equatable) with all 18 fields, 4 denormalized join fields, and computed properties (durationMinutes, isEditable, canCancel) in `lib/features/scheduling/domain/entities/appointment.dart` (depends on T003 for AppointmentStatus)
- [X] T009 [P] Create all 11 param classes (Equatable) — CreateAppointmentParams, CancelAppointmentParams, RescheduleAppointmentParams, UpdateAppointmentStatusParams, GetAppointmentsForDateParams, GetMyAppointmentsTodayParams, CreateAppointmentTypeParams, UpdateAppointmentTypeParams, GetProviderAvailabilityParams, SetProviderAvailabilityParams, AddBlockedDateParams, GetAvailableSlotsParams — in `lib/features/scheduling/domain/repositories/` (one file per param or grouped by repository)
- [X] T010 [P] Create AppointmentRepository abstract interface with 7 methods from data-model.md in `lib/features/scheduling/domain/repositories/appointment_repository.dart`
- [X] T011 [P] Create AvailabilityRepository abstract interface with 9 methods from data-model.md in `lib/features/scheduling/domain/repositories/availability_repository.dart`
- [X] T012 [P] Create AppointmentTypeModel (freezed) with JsonKey mappings and `toEntity()` extension in `lib/features/scheduling/data/models/appointment_type_model.dart`
- [X] T013 [P] Create ProviderAvailabilityModel (freezed) with JsonKey mappings and `toEntity()` extension in `lib/features/scheduling/data/models/provider_availability_model.dart`
- [X] T014 [P] Create BlockedDateModel (freezed) with JsonKey mappings and `toEntity()` extension in `lib/features/scheduling/data/models/blocked_date_model.dart`
- [X] T015 Create AppointmentModel (freezed) with JsonKey mappings, AppointmentStatusConverter, nested join extraction for denormalized fields, and `toEntity()` extension in `lib/features/scheduling/data/models/appointment_model.dart` (depends on T003 for AppointmentStatus)
- [X] T016 Run `dart run build_runner build --delete-conflicting-outputs` to generate freezed/json_serializable code for all 4 models
- [X] T017 [P] Create AppointmentRemoteDataSource abstract interface and implementation with Supabase queries (CRUD for appointments, query by date/provider, status update) in `lib/features/scheduling/data/datasources/appointment_remote_data_source.dart`
- [X] T018 [P] Create AvailabilityRemoteDataSource abstract interface and implementation with Supabase queries (appointment types CRUD, provider availability CRUD, blocked dates CRUD, slot computation query) in `lib/features/scheduling/data/datasources/availability_remote_data_source.dart`
- [X] T019 Create AppointmentRepositoryImpl implementing AppointmentRepository with NetworkInfo check, exception-to-failure mapping (ServerException → ServerFailure, NetworkFailure) in `lib/features/scheduling/data/repositories/appointment_repository_impl.dart` (depends on T010, T017)
- [X] T020 Create AvailabilityRepositoryImpl implementing AvailabilityRepository with NetworkInfo check, exception-to-failure mapping, and client-side slot computation algorithm (3 queries → local generation per plan.md design decision #1) in `lib/features/scheduling/data/repositories/availability_repository_impl.dart` (depends on T011, T018)

**Checkpoint**: Foundation ready — all entities, models, data sources, and repositories are in place. User story implementation can now begin.

---

## Phase 3: User Story 1 — Book an Appointment (Priority: P1) 🎯 MVP

**Goal**: Staff can book an appointment by selecting a patient, provider, appointment type, date, and available time slot. The system computes available slots and prevents double-booking.

**Independent Test**: Navigate to booking page, select a patient, choose provider and type, pick a slot, confirm. Appointment appears in provider's daily list.

### Use Cases for User Story 1

- [X] T021 [P] [US1] Create CreateAppointment use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/create_appointment.dart`
- [X] T022 [P] [US1] Create GetAvailableSlots use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/get_available_slots.dart`
- [X] T023 [P] [US1] Create GetAppointmentTypes use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/get_appointment_types.dart`

### Presentation for User Story 1

- [X] T024 [US1] Create BookAppointmentState (sealed class) with currentStep (0-3), selectedPatient, selectedAppointmentType, selectedProvider, selectedDate, selectedSlot, availableSlots, isLoading, error in `lib/features/scheduling/presentation/cubit/book_appointment_state.dart`
- [X] T025 [US1] Create BookAppointmentCubit with 4-step wizard logic (selectPatient → selectType → selectProviderDateSlot → confirm), injecting CreateAppointment, GetAvailableSlots, GetAppointmentTypes, SearchPatients (from 005-patients) in `lib/features/scheduling/presentation/cubit/book_appointment_cubit.dart` (depends on T024)
- [X] T026 [P] [US1] Create PatientSelectorStep widget using SearchPatients use case with search field and results list in `lib/features/scheduling/presentation/pages/widgets/patient_selector_step.dart`
- [X] T027 [P] [US1] Create TypeSelectorStep widget displaying active appointment types as selectable cards in `lib/features/scheduling/presentation/pages/widgets/type_selector_step.dart`
- [X] T028 [P] [US1] Create SlotSelectorStep widget with provider dropdown (from ClinicCubit.state.staff filtered by doctor role), date picker, and available slot grid in `lib/features/scheduling/presentation/pages/widgets/slot_selector_step.dart`
- [X] T029 [P] [US1] Create BookingConfirmationStep widget showing selected patient, type, provider, date, slot with confirm button in `lib/features/scheduling/presentation/pages/widgets/booking_confirmation_step.dart`
- [X] T030 [US1] Create BookAppointmentPage orchestrating the 4 step widgets via BlocBuilder on BookAppointmentCubit in `lib/features/scheduling/presentation/pages/book_appointment_page.dart` (depends on T025-T029)

### Routing & DI for User Story 1

- [X] T031 [US1] Add scheduling route names (appointments, bookAppointment, appointmentDetail, myDay, availability, appointmentTypes, appointmentTypeForm) to `lib/core/router/route_names.dart`
- [X] T032 [US1] Create scheduling DI registration function `initScheduling()` in `lib/features/scheduling/di/scheduling_injection.dart` — register data sources, repositories, use cases (T021-T023), and BookAppointmentCubit as factory
- [X] T033 [US1] Register `initScheduling()` call in `lib/core/di/injection_container.dart`
- [X] T034 [US1] Add `/home/appointments/book` route to `lib/core/router/app_router.dart` under the `/home` branch of StatefulShellRoute

**Checkpoint**: User Story 1 (MVP) is complete. Staff can book appointments through the multi-step flow. Available slots are computed from provider availability. Double-booking is prevented by the EXCLUDE constraint.

---

## Phase 4: User Story 2 — View Daily Appointments (Priority: P1)

**Goal**: Staff can view all appointments for a selected provider and date, ordered by time.

**Independent Test**: Create appointments for a provider on a date, navigate to appointment list, select that date/provider, verify appointments appear chronologically.

### Use Cases for User Story 2

- [X] T035 [P] [US2] Create GetAppointmentsForDate use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/get_appointments_for_date.dart`

### Presentation for User Story 2

- [X] T036 [US2] Create AppointmentListState (sealed class) with appointments list, selectedDate, selectedProviderId, isLoading, error in `lib/features/scheduling/presentation/cubit/appointment_list_state.dart`
- [X] T037 [US2] Create AppointmentListCubit with loadAppointments(date, providerId?), changeDate, changeProvider methods in `lib/features/scheduling/presentation/cubit/appointment_list_cubit.dart` (depends on T036)
- [X] T038 [P] [US2] Create AppointmentListTile widget displaying patient name, type, time range, duration, status badge, and type color indicator in `lib/features/scheduling/presentation/pages/widgets/appointment_list_tile.dart`
- [X] T039 [P] [US2] Create DateProviderFilterBar widget with date picker and provider dropdown in `lib/features/scheduling/presentation/pages/widgets/date_provider_filter_bar.dart`
- [X] T040 [US2] Create AppointmentListPage with filter bar, scrollable appointment list, empty state, and tap-to-detail navigation in `lib/features/scheduling/presentation/pages/appointment_list_page.dart` (depends on T037-T039)

### DI & Routing for User Story 2

- [X] T041 [US2] Register GetAppointmentsForDate use case and AppointmentListCubit in `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T042 [US2] Add `/home/appointments` route to `lib/core/router/app_router.dart`

**Checkpoint**: User Stories 1 and 2 are complete. Staff can book appointments and view the daily schedule.

---

## Phase 5: User Story 3 — Doctor's "My Day" View (Priority: P1)

**Goal**: Logged-in doctor sees only their own appointments for today, with quick status transitions.

**Independent Test**: Log in as a doctor with today's appointments, navigate to "My Day," verify only their appointments appear.

### Use Cases for User Story 3

- [X] T043 [P] [US3] Create GetMyAppointmentsToday use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/get_my_appointments_today.dart`

### Presentation for User Story 3

- [X] T044 [US3] Create MyDayState (sealed class) with todayAppointments list, isLoading, error in `lib/features/scheduling/presentation/cubit/my_day_state.dart`
- [X] T045 [US3] Create MyDayCubit with loadToday() using auth uid as providerId in `lib/features/scheduling/presentation/cubit/my_day_cubit.dart` (depends on T044)
- [X] T046 [US3] Create MyDayPage with today's appointment list (reusing AppointmentListTile from T038), empty state, and tap-to-detail in `lib/features/scheduling/presentation/pages/my_day_page.dart` (depends on T045)

### DI & Routing for User Story 3

- [X] T047 [US3] Register GetMyAppointmentsToday use case and MyDayCubit in `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T048 [US3] Add `/home/my-day` route to `lib/core/router/app_router.dart`

**Checkpoint**: All P1 stories complete. Booking, daily list, and doctor's My Day view are functional.

---

## Phase 6: User Story 4 — Manage Appointment Status (Priority: P2)

**Goal**: Staff can transition appointment status through the workflow (scheduled → confirmed → checked_in → in_progress → completed) and cancel or mark no-show. Invalid transitions are rejected.

**Independent Test**: Create an appointment, open detail screen, step through valid transitions, verify invalid transitions are blocked.

### Use Cases for User Story 4

- [X] T049 [P] [US4] Create UpdateAppointmentStatus use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/update_appointment_status.dart`
- [X] T050 [P] [US4] Create CancelAppointment use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/cancel_appointment.dart`

### Presentation for User Story 4

- [X] T051 [P] [US4] Create StatusActionButtons widget that shows only valid next-status actions based on `canTransitionTo()`, cancel button (with reason dialog), and no-show button in `lib/features/scheduling/presentation/pages/widgets/status_action_buttons.dart`
- [X] T052 [US4] Create AppointmentDetailPage showing all appointment details (patient, provider, type, time, status, notes) with StatusActionButtons, edit notes, and navigation to reschedule in `lib/features/scheduling/presentation/pages/appointment_detail_page.dart` (depends on T051)

### DI & Routing for User Story 4

- [X] T053 [US4] Register UpdateAppointmentStatus and CancelAppointment use cases in `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T054 [US4] Add `/home/appointments/:id` route to `lib/core/router/app_router.dart`

**Checkpoint**: Status management works. Staff can confirm, check-in, start, complete, cancel, and mark no-show on appointments.

---

## Phase 7: User Story 5 — Cancel and Reschedule Appointments (Priority: P2)

**Goal**: Staff can reschedule an appointment (cancel original + book new slot) or cancel outright with a reason.

**Independent Test**: Create appointment, tap Reschedule, pick new slot, confirm. Old appointment is cancelled with reason "Rescheduled," new appointment exists at new time.

### Use Cases for User Story 5

- [X] T055 [US5] Create RescheduleAppointment use case (UseCaseWithParams) that cancels original appointment with reason "Rescheduled" and creates new appointment in `lib/features/scheduling/domain/usecases/reschedule_appointment.dart`

### Presentation for User Story 5

- [X] T056 [US5] Add reschedule flow to BookAppointmentCubit — initialize with pre-selected patient and provider, start at step 2 (slot selection), on confirm cancel old + create new in `lib/features/scheduling/presentation/cubit/book_appointment_cubit.dart`
- [X] T057 [US5] Add "Reschedule" button to AppointmentDetailPage (visible when appointment.isEditable) that navigates to BookAppointmentPage in reschedule mode in `lib/features/scheduling/presentation/pages/appointment_detail_page.dart`

### DI Updates for User Story 5

- [X] T058 [US5] Register RescheduleAppointment use case in `lib/features/scheduling/di/scheduling_injection.dart`

**Checkpoint**: Rescheduling works end-to-end. Cancellation with reason is fully functional.

---

## Phase 8: User Story 6 — Manage Appointment Types (Priority: P2)

**Goal**: Clinic admin can create, edit, and activate/deactivate appointment types (name, duration, color, description).

**Independent Test**: Navigate to appointment type management, create a type, verify it appears in list and in booking flow. Deactivate it, verify it disappears from booking.

### Use Cases for User Story 6

- [X] T059 [P] [US6] Create CreateAppointmentType use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/create_appointment_type.dart`
- [X] T060 [P] [US6] Create UpdateAppointmentType use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/update_appointment_type.dart`

### Presentation for User Story 6

- [X] T061 [US6] Create AppointmentTypeState (sealed class) with types list, isLoading, error in `lib/features/scheduling/presentation/cubit/appointment_type_state.dart`
- [X] T062 [US6] Create AppointmentTypeCubit with loadTypes(), createType(), updateType(), toggleActive() in `lib/features/scheduling/presentation/cubit/appointment_type_cubit.dart` (depends on T061)
- [X] T063 [US6] Create AppointmentTypeListPage displaying active/inactive types with add button and tap-to-edit in `lib/features/scheduling/presentation/pages/appointment_type_list_page.dart` (depends on T062)
- [X] T064 [US6] Create AppointmentTypeFormPage with name (AppFormField), duration selector (15/30/45/60/90/120), color picker, description, active toggle, and save button in `lib/features/scheduling/presentation/pages/appointment_type_form_page.dart` (depends on T062)

### DI & Routing for User Story 6

- [X] T065 [US6] Register CreateAppointmentType, UpdateAppointmentType use cases and AppointmentTypeCubit in `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T066 [US6] Add `/home/appointment-types`, `/home/appointment-types/new`, `/home/appointment-types/:id` routes to `lib/core/router/app_router.dart`

**Checkpoint**: Appointment type management is complete. Types are reflected in the booking flow.

---

## Phase 9: User Story 7 — Set Provider Weekly Availability (Priority: P2)

**Goal**: Provider or admin sets weekly schedule (days, start/end times per day). Breaks are gaps between consecutive entries. Availability drives slot computation.

**Independent Test**: Set availability for Monday 9:00–13:00 and 14:00–17:00, then verify booking only shows slots within those windows (with 13:00–14:00 excluded as break).

### Use Cases for User Story 7

- [X] T067 [P] [US7] Create SetProviderAvailability use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/set_provider_availability.dart`
- [X] T068 [P] [US7] Create GetProviderAvailability use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/get_provider_availability.dart`

### Presentation for User Story 7

- [X] T069 [US7] Create AvailabilityState (sealed class) with weeklyEntries (grouped by day), isLoading, error in `lib/features/scheduling/presentation/cubit/availability_state.dart`
- [X] T070 [US7] Create AvailabilityCubit with loadAvailability(providerId), addEntry(), removeEntry(), toggleActive(), saveAll() in `lib/features/scheduling/presentation/cubit/availability_cubit.dart` (depends on T069)
- [X] T071 [P] [US7] Create AvailabilityDayCard widget showing a day's entries with start/end time pickers, add entry, remove entry, active toggle in `lib/features/scheduling/presentation/pages/widgets/availability_day_card.dart`
- [X] T072 [US7] Create ManageAvailabilityPage with 7-day list (Mon–Sun) of AvailabilityDayCards, save button, and provider selector (for admin) in `lib/features/scheduling/presentation/pages/manage_availability_page.dart` (depends on T070-T071)

### DI & Routing for User Story 7

- [X] T073 [US7] Register SetProviderAvailability, GetProviderAvailability use cases and AvailabilityCubit in `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T074 [US7] Add `/home/availability` route to `lib/core/router/app_router.dart`

**Checkpoint**: Provider availability is configurable. Slot computation correctly uses the configured availability windows.

---

## Phase 10: User Story 8 — Set Time-Off / Blocked Dates (Priority: P3)

**Goal**: Admin or provider blocks specific dates so no appointments can be booked on those days.

**Independent Test**: Block a date for a provider, attempt to book on that date. Verify no slots are available. Remove the block, verify slots return.

### Use Cases for User Story 8

- [X] T075 [P] [US8] Create AddBlockedDate use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/add_blocked_date.dart`
- [X] T076 [P] [US8] Create RemoveBlockedDate use case (UseCaseWithParams) in `lib/features/scheduling/domain/usecases/remove_blocked_date.dart`

### Presentation for User Story 8

- [X] T077 [P] [US8] Create BlockedDateList widget displaying blocked dates with date, reason, and remove button in `lib/features/scheduling/presentation/pages/widgets/blocked_date_list.dart`
- [X] T078 [US8] Add blocked dates section to ManageAvailabilityPage — date picker to add blocked date with optional reason, BlockedDateList to view/remove existing blocks in `lib/features/scheduling/presentation/pages/manage_availability_page.dart` (depends on T077)

### DI Updates for User Story 8

- [X] T079 [US8] Register AddBlockedDate and RemoveBlockedDate use cases in `lib/features/scheduling/di/scheduling_injection.dart`

**Checkpoint**: All 8 user stories are complete. Full scheduling functionality is in place.

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Final integration, validation, and cleanup

- [X] T080 [P] Verify all scheduling routes are properly registered and navigable from the home screen in `lib/core/router/app_router.dart`
- [X] T081 [P] Verify all DI registrations are complete and `initScheduling()` order is correct in `lib/core/di/injection_container.dart` and `lib/features/scheduling/di/scheduling_injection.dart`
- [X] T082 Run `dart run build_runner build --delete-conflicting-outputs` to ensure all generated code is up to date
- [X] T083 Run `dart analyze` and fix any lint issues in `lib/features/scheduling/`
- [X] T084 Run quickstart.md verification steps (create type → set availability → book appointment → verify double-booking prevention → verify My Day → test status transitions → cancel → reschedule)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — BLOCKS all user stories
- **Phase 3 (US1 — Book)**: Depends on Phase 2
- **Phase 4 (US2 — Daily View)**: Depends on Phase 2 (can run in parallel with US1)
- **Phase 5 (US3 — My Day)**: Depends on Phase 2 + reuses AppointmentListTile from US2 (T038)
- **Phase 6 (US4 — Status)**: Depends on Phase 2
- **Phase 7 (US5 — Reschedule)**: Depends on US1 (T025 BookAppointmentCubit) and US4 (T052 AppointmentDetailPage)
- **Phase 8 (US6 — Types)**: Depends on Phase 2
- **Phase 9 (US7 — Availability)**: Depends on Phase 2
- **Phase 10 (US8 — Blocked Dates)**: Depends on US7 (T072 ManageAvailabilityPage)
- **Phase 11 (Polish)**: Depends on all user stories being complete

### User Story Dependencies

```
Setup → Foundational → ┬─ US1 (Book) ────────────────────────┐
                        ├─ US2 (Daily View) ──┐               │
                        ├─ US4 (Status) ──────┤               │
                        ├─ US6 (Types) ────── │               │
                        └─ US7 (Availability)─┤               │
                                              │               │
                        US3 (My Day) ←── US2 (AppointmentListTile)
                        US5 (Reschedule) ←── US1 + US4        │
                        US8 (Blocked Dates) ←── US7            │
                                              │               │
                                              └── Polish ◄────┘
```

### Within Each Phase

- Models/entities before repositories
- Repositories before use cases
- Use cases before cubits
- Cubits/states before pages
- Widgets before pages that compose them

### Parallel Opportunities

- Phase 2: T003–T007 (all entities) can run in parallel; T009–T011 (params + repos) in parallel; T012–T014 (models) in parallel; T017–T018 (data sources) in parallel
- Phase 3: T021–T023 (use cases) in parallel; T026–T029 (widgets) in parallel
- Phase 4+: US2, US4, US6, US7 can all start after Phase 2 (independent of US1)

---

## Parallel Example: User Story 1

```bash
# After Phase 2 is complete, launch US1 use cases in parallel:
Task T021: "Create CreateAppointment use case"
Task T022: "Create GetAvailableSlots use case"
Task T023: "Create GetAppointmentTypes use case"

# Then launch US1 widgets in parallel:
Task T026: "Create PatientSelectorStep widget"
Task T027: "Create TypeSelectorStep widget"
Task T028: "Create SlotSelectorStep widget"
Task T029: "Create BookingConfirmationStep widget"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1 (Book an Appointment)
4. **STOP and VALIDATE**: Test booking flow end-to-end
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (Book) → Test booking independently → **MVP!**
3. Add US2 (Daily View) + US3 (My Day) → Test views → Deploy
4. Add US4 (Status) + US5 (Reschedule) → Test status workflow → Deploy
5. Add US6 (Types) + US7 (Availability) → Test configuration → Deploy
6. Add US8 (Blocked Dates) → Test time-off → Deploy
7. Polish → Final validation

### Suggested MVP Scope

**User Story 1 (Book an Appointment)** is the MVP. It demonstrates the core value: patient selection, slot computation, and appointment creation with double-booking prevention. All other stories add operational convenience on top.

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [Story] label maps task to specific user story for traceability
- All text inputs MUST use AppFormField.buildTextField (Constitution VIII)
- All validation MUST use AppValidators (Constitution VIII)
- All use cases return FutureResult<T> (Constitution II)
- All repository impls check NetworkInfo before remote calls (existing pattern)
- Cross-feature patient search via DI injection — no direct imports of patient data/presentation layers
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
