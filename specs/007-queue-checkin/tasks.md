# Tasks: Queue & Check-In System

**Input**: Design documents from `/specs/007-queue-checkin/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not requested — test tasks omitted. 

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create queue feature directory structure and configure dependencies

- [X] T001 Create queue feature directory structure under lib/features/queue/ with domain/entities/, domain/repositories/, domain/usecases/, data/models/, data/datasources/, data/repositories/, presentation/bloc/, presentation/cubit/, presentation/pages/widgets/, di/
- [X] T002 Verify supabase_flutter, flutter_bloc, dartz, freezed, equatable, json_annotation, json_serializable, build_runner are in pubspec.yaml (add if missing)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain entities, enums, repository interfaces, and data models that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 [P] Create QueueTokenStatus enum with valid transitions map in lib/features/queue/domain/entities/queue_token_status.dart — values: waiting, called, inProgress, completed, noShow, skipped; include `bool isValidTransition(QueueTokenStatus next)` method and `Set<QueueTokenStatus> get validNextStatuses`
- [X] T004 [P] Create QueuePriority enum in lib/features/queue/domain/entities/queue_priority.dart — values: normal, urgent
- [X] T005 [P] Create QueueToken entity in lib/features/queue/domain/entities/queue_token.dart — Equatable class with all fields from data-model.md (id, clinicId, locationId, tokenNumber, patientId, appointmentId, providerId, status, priority, skipCount, calledAt, startedAt, completedAt, createdAt, patientName, providerName); add `String get formattedToken => 'Q-${tokenNumber.toString().padLeft(3, '0')}'`
- [X] T006 [P] Create TriageAssessment entity in lib/features/queue/domain/entities/triage_assessment.dart — Equatable class with all fields from data-model.md (id, queueTokenId, clinicId, bloodPressureSystolic, bloodPressureDiastolic, heartRate, temperature, weight, spo2, chiefComplaint, recordedBy, createdAt)
- [X] T007 [P] Create QueueRepository abstract class in lib/features/queue/domain/repositories/queue_repository.dart — per contracts/002-dart-interfaces.md: checkInPatient, watchQueueForClinic, watchMyQueue, callNextPatient, startConsultation, completeQueueToken, skipQueueToken, markNoShow
- [X] T008 [P] Create TriageRepository abstract class in lib/features/queue/domain/repositories/triage_repository.dart — per contracts/002-dart-interfaces.md: recordTriage, getTriageForToken
- [X] T009 [P] Create QueueTokenModel (freezed) in lib/features/queue/data/models/queue_token_model.dart — @freezed with all JSON keys from data-model.md, custom _QueueTokenStatusConverter and _QueuePriorityConverter, toEntity() extension, fromSupabaseJoin() for denormalized patient/provider names
- [X] T010 [P] Create TriageAssessmentModel (freezed) in lib/features/queue/data/models/triage_assessment_model.dart — @freezed with all JSON keys from data-model.md, toEntity() extension
- [X] T011 Create QueueRemoteDataSource interface and implementation in lib/features/queue/data/datasources/queue_remote_data_source.dart — methods: checkInPatient (calls Supabase RPC 'check_in_patient'), watchQueueForClinic (Supabase .stream()), watchMyQueue (Supabase .stream() filtered by provider), callNextPatient (calls Supabase RPC 'call_next_patient'), updateTokenStatus (update single token row), getTokenById
- [X] T012 [P] Create TriageRemoteDataSource interface and implementation in lib/features/queue/data/datasources/triage_remote_data_source.dart — methods: recordTriage (insert into triage_assessments), getTriageForToken (select by queue_token_id)
- [X] T013 Create QueueRepositoryImpl in lib/features/queue/data/repositories/queue_repository_impl.dart — implements QueueRepository, wraps QueueRemoteDataSource with try/catch → Either<Failure, T>, maps models to entities via toEntity(), stream methods wrap in Stream.map with error handling
- [X] T014 [P] Create TriageRepositoryImpl in lib/features/queue/data/repositories/triage_repository_impl.dart — implements TriageRepository, wraps TriageRemoteDataSource with try/catch → Either<Failure, T>
- [X] T015 Run `flutter pub run build_runner build --delete-conflicting-outputs` and verify generated files for QueueTokenModel and TriageAssessmentModel compile without errors
- [X] T016 Run `dart analyze` on lib/features/queue/ and fix any errors

**Checkpoint**: Foundation ready — all entities, repos, models, data sources compiled. User story implementation can begin.

---

## Phase 3: User Story 1 — Patient Check-In & Queue Token Generation (Priority: P1) 🎯 MVP

**Goal**: Receptionist checks in a patient (scheduled or walk-in), system generates queue token with daily auto-incremented number

**Independent Test**: Check in a scheduled patient → verify token created with Q-001 format, appointment status → checked_in. Check in walk-in → verify appointment created + token generated.

### Use Cases

- [X] T017 [P] [US1] Create CheckInPatient use case in lib/features/queue/domain/usecases/check_in_patient.dart — UseCaseWithParams<QueueToken, CheckInPatientParams>; params: clinicId, patientId, appointmentId, providerId, priority, locationId; calls queueRepository.checkInPatient

### Presentation

- [X] T018 [P] [US1] Create CheckInPage in lib/features/queue/presentation/pages/check_in_page.dart — shows two tabs/sections: "Scheduled Appointments" and "Walk-In"; takes optional appointmentId param for pre-filled check-in; uses BlocProvider for QueueBloc
- [X] T019 [P] [US1] Create CheckInAppointmentList widget in lib/features/queue/presentation/pages/widgets/check_in_appointment_list.dart — lists today's confirmed appointments for the clinic with "Check In" button per row; uses existing AppointmentListCubit from scheduling or loads via Supabase query
- [X] T020 [P] [US1] Create WalkInForm widget in lib/features/queue/presentation/pages/widgets/walk_in_form.dart — patient search field (reuses SearchPatients use case), provider dropdown (from ClinicCubit staff), appointment type selector, priority toggle (normal/urgent), "Check In" button; all text fields use AppFormField, validation via AppValidators

### DI & Routes

- [X] T021 [US1] Create queue_injection.dart in lib/features/queue/di/queue_injection.dart — register: QueueRemoteDataSource, TriageRemoteDataSource, QueueRepositoryImpl, TriageRepositoryImpl, CheckInPatient use case; register factory for QueueBloc
- [X] T022 [US1] Update lib/core/di/injection_container.dart — add `import queue_injection.dart` and call `await initQueue()` after `await initScheduling()`
- [X] T023 [US1] Add route name constants to lib/core/router/route_names.dart — queueList, queueCheckIn, queueCheckInAppointment, queueTriage, myQueue, waitingRoom
- [X] T024 [US1] Add queue routes to lib/core/router/app_router.dart — /home/queue → QueueListPage (placeholder initially), /home/queue/check-in → CheckInPage, /home/queue/check-in/:appointmentId → CheckInPage(appointmentId:)

**Checkpoint**: Check-in flow works — scheduled and walk-in patients can be checked in, tokens are created with auto-numbered Q-XXX format.

---

## Phase 4: User Story 2 — Queue Management by Receptionist (Priority: P1)

**Goal**: Receptionist sees full clinic queue in real time, can call next patient, skip, and mark no-show

**Independent Test**: Check in 3 patients → view queue list → call next → verify called status → skip one → verify reordered → mark no-show → verify status. All updates visible in real time.

### Use Cases

- [X] T025 [P] [US2] Create GetQueueForClinic use case in lib/features/queue/domain/usecases/get_queue_for_clinic.dart — StreamUseCaseWithParams<List<QueueToken>, String>; clinicId param; calls queueRepository.watchQueueForClinic
- [X] T026 [P] [US2] Create CallNextPatient use case in lib/features/queue/domain/usecases/call_next_patient.dart — UseCaseWithParams<QueueToken, CallNextPatientParams>; params: clinicId, providerId; calls queueRepository.callNextPatient
- [X] T027 [P] [US2] Create SkipQueueToken use case in lib/features/queue/domain/usecases/skip_queue_token.dart — UseCaseWithParams<QueueToken, String>; tokenId param; calls queueRepository.skipQueueToken
- [X] T028 [P] [US2] Create MarkNoShow use case in lib/features/queue/domain/usecases/mark_no_show.dart — UseCaseWithParams<QueueToken, String>; tokenId param; calls queueRepository.markNoShow

### Bloc

- [X] T029 [P] [US2] Create QueueEvent sealed class in lib/features/queue/presentation/bloc/queue_event.dart — events: QueueSubscriptionRequested(clinicId), QueueCallNextRequested(clinicId, providerId), QueueSkipRequested(tokenId), QueueMarkNoShowRequested(tokenId), QueueStartConsultationRequested(tokenId), QueueCompleteRequested(tokenId); all extend Equatable
- [X] T030 [P] [US2] Create QueueState sealed class in lib/features/queue/presentation/bloc/queue_state.dart — states: QueueInitial, QueueLoading, QueueLoaded(tokens: List<QueueToken>, isActioning: bool), QueueError(message: String); all extend Equatable
- [X] T031 [US2] Create QueueBloc in lib/features/queue/presentation/bloc/queue_bloc.dart — handles QueueSubscriptionRequested via emit.forEach on GetQueueForClinic stream; handles CallNext/Skip/NoShow by calling respective use cases then letting realtime stream update state; handles StartConsultation/Complete for convenience (shared actions)

### Widgets & Page

- [X] T032 [P] [US2] Create QueueStatusChip widget in lib/features/queue/presentation/pages/widgets/queue_status_chip.dart — color-coded chip per QueueTokenStatus (waiting=blue, called=orange, inProgress=green, completed=grey, noShow=red, skipped=amber)
- [X] T033 [P] [US2] Create QueueTokenTile widget in lib/features/queue/presentation/pages/widgets/queue_token_tile.dart — Card showing: token number (Q-XXX), patient name, provider name, priority badge (if urgent), status chip, check-in time; onTap callback
- [X] T034 [P] [US2] Create QueueActionButtons widget in lib/features/queue/presentation/pages/widgets/queue_action_buttons.dart — renders valid action buttons based on current token status: Call Next (for waiting), Start (for called), Complete (for inProgress), Skip, No-Show (for called); dispatches corresponding QueueBloc events
- [X] T035 [US2] Create QueueListPage in lib/features/queue/presentation/pages/queue_list_page.dart — BlocProvider for QueueBloc, dispatches QueueSubscriptionRequested on init; AppBar with "Check In" action button → navigates to check-in route; provider filter dropdown; ListView.builder with QueueTokenTile + QueueActionButtons per token; BlocBuilder with pattern matching on QueueState

### DI Update

- [X] T036 [US2] Update lib/features/queue/di/queue_injection.dart — register GetQueueForClinic, CallNextPatient, SkipQueueToken, MarkNoShow use cases; update QueueBloc factory with all injected use cases

**Checkpoint**: Receptionist queue view works with real-time updates. Call next, skip, and no-show actions functional.

---

## Phase 5: User Story 3 — Doctor's Personal Queue (Priority: P1)

**Goal**: Doctor sees only their own assigned tokens, can call next, start consultation, and complete

**Independent Test**: Log in as doctor → open My Queue → see only assigned tokens → call next → start consultation → complete → verify transitions and timestamps.

### Use Cases

- [X] T037 [P] [US3] Create GetMyQueue use case in lib/features/queue/domain/usecases/get_my_queue.dart — StreamUseCaseWithParams<List<QueueToken>, GetMyQueueParams>; params: clinicId, providerId; calls queueRepository.watchMyQueue
- [X] T038 [P] [US3] Create StartConsultation use case in lib/features/queue/domain/usecases/start_consultation.dart — UseCaseWithParams<QueueToken, String>; tokenId param; calls queueRepository.startConsultation
- [X] T039 [P] [US3] Create CompleteQueueToken use case in lib/features/queue/domain/usecases/complete_queue_token.dart — UseCaseWithParams<QueueToken, String>; tokenId param; calls queueRepository.completeQueueToken

### Bloc

- [X] T040 [P] [US3] Create MyQueueEvent sealed class in lib/features/queue/presentation/bloc/my_queue_event.dart — events: MyQueueSubscriptionRequested(clinicId, providerId), MyQueueCallNextRequested(clinicId, providerId), MyQueueStartConsultationRequested(tokenId), MyQueueCompleteRequested(tokenId); all extend Equatable
- [X] T041 [P] [US3] Create MyQueueState sealed class in lib/features/queue/presentation/bloc/my_queue_state.dart — states: MyQueueInitial, MyQueueLoading, MyQueueLoaded(tokens: List<QueueToken>, isActioning: bool), MyQueueError(message: String); all extend Equatable
- [X] T042 [US3] Create MyQueueBloc in lib/features/queue/presentation/bloc/my_queue_bloc.dart — handles MyQueueSubscriptionRequested via emit.forEach on GetMyQueue stream; handles CallNext/StartConsultation/Complete via respective use cases

### Page

- [X] T043 [US3] Create MyQueuePage in lib/features/queue/presentation/pages/my_queue_page.dart — BlocProvider for MyQueueBloc, dispatches MyQueueSubscriptionRequested(clinicId, currentUserId) on init; shows doctor's name in AppBar; ListView of QueueTokenTile (reuse from US2) with action buttons (Call Next, Start Consultation, Complete); empty state when no tokens; BlocBuilder with pattern matching

### DI & Routes

- [X] T044 [US3] Update lib/features/queue/di/queue_injection.dart — register GetMyQueue, StartConsultation, CompleteQueueToken use cases; register MyQueueBloc factory
- [X] T045 [US3] Add my-queue route to lib/core/router/app_router.dart — /home/my-queue → MyQueuePage

**Checkpoint**: Doctor's personal queue works with real-time updates. Call next, start consultation, complete actions functional. Only provider's own tokens visible.

---

## Phase 6: User Story 4 — Basic Triage on Check-In (Priority: P2)

**Goal**: Optionally record vitals during check-in, display triage data in doctor's queue view

**Independent Test**: Check in a patient → navigate to triage form → enter vitals → save → view doctor queue → verify vitals displayed next to patient.

### Use Cases

- [X] T046 [P] [US4] Create RecordTriage use case in lib/features/queue/domain/usecases/record_triage.dart — UseCaseWithParams<TriageAssessment, RecordTriageParams>; params: queueTokenId, clinicId, recordedBy, bloodPressureSystolic?, bloodPressureDiastolic?, heartRate?, temperature?, weight?, spo2?, chiefComplaint?; calls triageRepository.recordTriage
- [X] T047 [P] [US4] Create GetTriageForToken use case in lib/features/queue/domain/usecases/get_triage_for_token.dart — UseCaseWithParams<TriageAssessment?, String>; queueTokenId param; calls triageRepository.getTriageForToken

### Cubit

- [X] T048 [P] [US4] Create TriageState in lib/features/queue/presentation/cubit/triage_state.dart — sealed: TriageInitial, TriageLoading, TriageSaved(assessment: TriageAssessment), TriageLoaded(assessment: TriageAssessment?), TriageError(message: String); all extend Equatable
- [X] T049 [US4] Create TriageCubit in lib/features/queue/presentation/cubit/triage_cubit.dart — methods: recordTriage(params), loadTriage(tokenId); emits appropriate states; uses RecordTriage and GetTriageForToken use cases

### Widgets & Page

- [X] T050 [P] [US4] Create TriageSummaryCard widget in lib/features/queue/presentation/pages/widgets/triage_summary_card.dart — compact card showing: BP (sys/dia), HR, temp, weight, SpO2, chief complaint (truncated); takes TriageAssessment? param; shows "No triage recorded" if null
- [X] T051 [US4] Create TriageFormPage in lib/features/queue/presentation/pages/triage_form_page.dart — BlocProvider for TriageCubit; form fields for BP systolic/diastolic, heart rate, temperature, weight, SpO2, chief complaint; all using AppFormField; validation via AppValidators (range checks per data-model.md); Save button; BlocListener for success → pop; takes queueTokenId and clinicId as params
- [X] T052 [US4] Update QueueTokenTile in lib/features/queue/presentation/pages/widgets/queue_token_tile.dart — add optional TriageAssessment? param; if provided, show TriageSummaryCard below the tile content
- [X] T053 [US4] Update MyQueuePage to load triage data for each token and pass to QueueTokenTile in lib/features/queue/presentation/pages/my_queue_page.dart

### DI & Routes

- [X] T054 [US4] Update lib/features/queue/di/queue_injection.dart — register RecordTriage, GetTriageForToken use cases; register TriageCubit factory
- [X] T055 [US4] Add triage route to lib/core/router/app_router.dart — /home/queue/:tokenId/triage → TriageFormPage(queueTokenId:, clinicId:)
- [X] T056 [US4] Update CheckInPage to show "Record Triage" button after successful check-in that navigates to triage route in lib/features/queue/presentation/pages/check_in_page.dart

**Checkpoint**: Triage vitals can be recorded at check-in and displayed in doctor's queue view. Form validates vital ranges.

---

## Phase 7: User Story 5 — Status Workflow & Transitions (Priority: P2)

**Goal**: Enforce valid status transitions, reject invalid ones with user-friendly feedback

**Independent Test**: Attempt invalid transitions (completed → called, noShow → inProgress) → verify rejection with error message. Attempt valid transitions → verify success.

- [X] T057 [US5] Add transition validation to QueueRemoteDataSource in lib/features/queue/data/datasources/queue_remote_data_source.dart — before any status update, validate current status allows transition using QueueTokenStatus.isValidTransition(); throw ServerException with descriptive message for invalid transitions
- [X] T058 [US5] Update QueueBloc and MyQueueBloc to handle transition errors gracefully — on failed action, emit QueueLoaded/MyQueueLoaded with previous tokens list plus show error via a transient error field or separate error event; do not lose the realtime stream subscription on action failure
- [X] T059 [US5] Add user-friendly error SnackBar to QueueListPage and MyQueuePage — BlocListener for error states from action failures; display descriptive message (e.g., "Cannot complete: patient hasn't started consultation yet")

**Checkpoint**: Invalid transitions are rejected at data layer and UI shows user-friendly error. Valid transitions continue working.

---

## Phase 8: User Story 6 — Waiting Room Display Placeholder (Priority: P3)

**Goal**: Placeholder page and route for future waiting room display screen

**Independent Test**: Navigate to /home/waiting-room → see placeholder page with "Coming Soon" message.

- [X] T060 [US6] Create WaitingRoomDisplayPage placeholder in lib/features/queue/presentation/pages/waiting_room_display_page.dart — simple Center widget with Text "Waiting Room Display — Coming Soon" and an icon; ≤ 30 lines
- [X] T061 [US6] Add waiting-room route to lib/core/router/app_router.dart — /home/waiting-room → WaitingRoomDisplayPage, name: RouteNames.waitingRoom

**Checkpoint**: Placeholder route exists and loads.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final build, analysis, and verification across all user stories

- [X] T062 Run `flutter pub run build_runner build --delete-conflicting-outputs` — verify all generated files (queue_token_model.g.dart, queue_token_model.freezed.dart, triage_assessment_model.g.dart, triage_assessment_model.freezed.dart) compile
- [X] T063 Run `dart analyze` on full project — fix any errors, target 0 errors
- [X] T064 Verify all routes are reachable — navigate to /home/queue, /home/queue/check-in, /home/queue/check-in/:id, /home/queue/:tokenId/triage, /home/my-queue, /home/waiting-room
- [X] T065 Verify all DI registrations complete — check that initQueue() registers all data sources, repos, use cases (10), blocs (2), cubit (1)
- [X] T066 Review quickstart.md against implementation — confirm all file paths, setup steps, and architecture decisions match actual code

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — BLOCKS all user stories
- **US1 Check-In (Phase 3)**: Depends on Phase 2 — provides core check-in flow
- **US2 Queue Management (Phase 4)**: Depends on Phase 2 — can run in parallel with US1
- **US3 Doctor's Queue (Phase 5)**: Depends on Phase 2 — can run in parallel with US1/US2; reuses QueueTokenTile from US2
- **US4 Triage (Phase 6)**: Depends on Phase 2 — can run in parallel with US1-US3; updates CheckInPage (US1 dep) and MyQueuePage (US3 dep)
- **US5 Status Workflow (Phase 7)**: Depends on US2 (QueueBloc) and US3 (MyQueueBloc)
- **US6 Placeholder (Phase 8)**: Depends on Phase 1 only — can run in parallel with everything
- **Polish (Phase 9)**: Depends on all phases being complete

### User Story Dependencies

- **US1 (P1)**: After Phase 2 — no cross-story dependencies
- **US2 (P1)**: After Phase 2 — creates QueueBloc, QueueTokenTile, QueueActionButtons shared by US3
- **US3 (P1)**: After Phase 2 — reuses widgets from US2 (QueueTokenTile, QueueStatusChip)
- **US4 (P2)**: After Phase 2 — updates US1 CheckInPage and US3 MyQueuePage
- **US5 (P2)**: After US2+US3 — modifies QueueBloc/MyQueueBloc error handling
- **US6 (P3)**: After Phase 1 — fully independent

### Parallel Opportunities

**Within Phase 2** (all [P] tasks):
```
T003, T004, T005, T006, T007, T008, T009, T010, T012, T014 — all in parallel
Then: T011 (depends on T009), T013 (depends on T011, T009)
Then: T015, T016
```

**Across User Stories** (after Phase 2):
```
US1 (T017-T024) | US2 (T025-T036) | US3 (T037-T045) | US6 (T060-T061)
  — all can start in parallel
```

**Within US2**:
```
T025, T026, T027, T028 — use cases in parallel
T029, T030 — event/state in parallel
Then: T031 (bloc depends on events, state, use cases)
T032, T033, T034 — widgets in parallel
Then: T035 (page depends on widgets, bloc)
Then: T036 (DI update)
```

---

## Implementation Strategy

### MVP First (US1 + US2 + US3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: US1 Check-In
4. Complete Phase 4: US2 Queue Management
5. Complete Phase 5: US3 Doctor's Queue
6. **STOP and VALIDATE**: Core queue system fully functional with real-time updates
7. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 → Check-in flow operational (MVP entry point!)
3. Add US2 → Receptionist can manage queue in real time
4. Add US3 → Doctor can manage their own queue
5. Add US4 → Triage vitals enhance doctor preparation
6. Add US5 → Status validation hardens the system
7. Add US6 → Placeholder for future display
8. Polish → Build, analyze, verify

### Suggested MVP Scope

**US1 + US2 + US3** — these three P1 stories together form the minimum viable queue system. US1 creates tokens, US2 manages them from the receptionist view, US3 from the doctor view. All three are essential for basic daily operations.

---

## Notes

- **Bloc over Cubit**: QueueBloc and MyQueueBloc use Bloc pattern (justified: Supabase Realtime stream). TriageCubit uses Cubit (simple form).
- **Cross-feature integration**: CheckInPatient calls Supabase RPC `check_in_patient` which atomically creates token + updates appointment status. No direct scheduling feature imports needed at the Dart level.
- All UI files MUST be ≤ 100 lines (Constitution VII). Decompose into widgets/ as needed.
- All text fields MUST use AppFormField helpers (Constitution VIII).
- RLS enforced on both tables via contracts/001-migration.sql.
- Token auto-increment handled by Postgres function — no client-side numbering logic needed.
