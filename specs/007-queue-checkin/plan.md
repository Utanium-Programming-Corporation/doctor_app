# Implementation Plan: Queue & Check-In System

**Branch**: `007-queue-checkin` | **Date**: 2026-04-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/007-queue-checkin/spec.md`

## Summary

Implement a digital queue and check-in system enabling clinic receptionists to check in patients (scheduled appointments or walk-ins), generate daily auto-incremented queue tokens, and manage patient flow with real-time updates. Doctors view their personal queue and control consultation lifecycle. Optional triage vitals can be recorded at check-in. The queue uses Supabase Realtime subscriptions with Bloc (event-driven) for live state management, backed by Postgres functions for token auto-increment and RLS for clinic isolation.

## Technical Context

**Language/Version**: Dart 3.8.0+ / Flutter (latest stable)
**Primary Dependencies**: supabase_flutter, flutter_bloc, go_router, get_it, dartz, freezed, equatable, json_annotation, json_serializable, build_runner
**Storage**: Supabase (PostgreSQL) — `queue_tokens`, `triage_assessments` tables with RLS
**Testing**: bloc_test, mocktail, flutter_test
**Target Platform**: iOS, Android
**Project Type**: Mobile app (Flutter clean architecture)
**Performance Goals**: 60 fps UI, Realtime subscription latency < 2 seconds for queue updates
**Constraints**: HIPAA-compliant — no PHI in logs, RLS on all tables, clinic_id isolation
**Scale/Scope**: Multi-tenant clinic app — queue tokens scoped per clinic per day

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Notes |
|---|-----------|--------|-------|
| I | Clean Architecture | ✅ PASS | Three-layer separation: domain (entities, repo interfaces, use cases), data (models, data sources, repo impls), presentation (Bloc/Cubit, pages, widgets). All use cases implement one of the four abstract interfaces. Stream interfaces used for realtime use cases. |
| II | Type-Safe Functional Error Handling | ✅ PASS | All use cases return `Either<Failure, T>` or `Stream<Either<Failure, T>>`. Entities extend Equatable. Models use freezed + json_serializable. Nullable fields (appointment_id, location_id) have documented semantics. |
| III | Security & HIPAA Compliance | ✅ PASS | RLS on queue_tokens and triage_assessments filtered by clinic_id. No PHI in logs. Audit logging via DB triggers for status transitions. |
| IV | Feature-Modular Organization | ✅ PASS | Self-contained `lib/features/queue/` with domain/, data/, presentation/. DI via `initQueue()`. No direct imports from other features — shared contracts through core/ or use case injection. |
| V | Cubit-Default State Management | ✅ PASS | **Bloc justified for QueueBloc and MyQueueBloc**: Supabase Realtime delivers queue changes as a stream of events (INSERT, UPDATE, DELETE) which map directly to Bloc events. The Bloc pattern naturally handles merging realtime stream events with user-initiated actions (call next, skip, etc.) into a single event pipeline. TriageCubit uses Cubit (simple form submission, no streams). |
| VI | Supabase-First Backend | ✅ PASS | Token auto-increment via Postgres function. RLS policies. Realtime subscriptions for live queue updates. Business logic (token number generation) in DB functions. |
| VII | UI File Size Discipline | ✅ PASS | All pages and widgets ≤ 100 lines. Complex pages decomposed into widgets/ subfolder. |
| VIII | Unified Text Input | ✅ PASS | All text fields use AppFormField helpers. Validation via AppValidators. |

**Bloc vs Cubit Justification (Constitution V)**:

The queue feature subscribes to Supabase Realtime on the `queue_tokens` table. This delivers a stream of database change events (INSERT, UPDATE, DELETE). These map to distinct Bloc events:

- `QueueTokenInserted` → new patient checked in
- `QueueTokenUpdated` → status changed (called, in_progress, completed, etc.)
- `QueueTokenDeleted` → token removed

Additionally, the user can trigger actions that are also events:

- `CallNextRequested`
- `SkipTokenRequested`
- `MarkNoShowRequested`
- `StartConsultationRequested`
- `CompleteTokenRequested`
- `LoadQueueRequested`

Using Bloc, both the realtime stream and user actions feed into a single `mapEventToState` pipeline, enabling deterministic event ordering and predictable state transitions. A Cubit cannot natively accept a stream of external events — it would require manual stream subscription management inside the Cubit, breaking the clean event model.

## Project Structure

### Documentation (this feature)

```text
specs/007-queue-checkin/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (SQL migrations, RLS)
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
lib/features/queue/
├── domain/
│   ├── entities/
│   │   ├── queue_token.dart
│   │   ├── queue_token_status.dart
│   │   ├── queue_priority.dart
│   │   └── triage_assessment.dart
│   ├── repositories/
│   │   ├── queue_repository.dart
│   │   └── triage_repository.dart
│   └── usecases/
│       ├── check_in_patient.dart
│       ├── call_next_patient.dart
│       ├── start_consultation.dart
│       ├── complete_queue_token.dart
│       ├── skip_queue_token.dart
│       ├── mark_no_show.dart
│       ├── get_queue_for_clinic.dart      # StreamUseCaseWithParams
│       ├── get_my_queue.dart              # StreamUseCaseWithParams
│       ├── record_triage.dart
│       └── get_triage_for_token.dart
├── data/
│   ├── models/
│   │   ├── queue_token_model.dart         # freezed
│   │   └── triage_assessment_model.dart   # freezed
│   ├── datasources/
│   │   ├── queue_remote_data_source.dart
│   │   └── triage_remote_data_source.dart
│   └── repositories/
│       ├── queue_repository_impl.dart
│       └── triage_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   ├── queue_bloc.dart
│   │   ├── queue_event.dart
│   │   └── queue_state.dart
│   ├── bloc/
│   │   ├── my_queue_bloc.dart
│   │   ├── my_queue_event.dart
│   │   └── my_queue_state.dart
│   ├── cubit/
│   │   ├── triage_cubit.dart
│   │   └── triage_state.dart
│   └── pages/
│       ├── queue_list_page.dart
│       ├── my_queue_page.dart
│       ├── check_in_page.dart
│       ├── triage_form_page.dart
│       ├── waiting_room_display_page.dart  # placeholder
│       └── widgets/
│           ├── queue_token_tile.dart
│           ├── queue_action_buttons.dart
│           ├── triage_summary_card.dart
│           ├── check_in_appointment_list.dart
│           ├── walk_in_form.dart
│           └── queue_status_chip.dart
└── di/
    └── queue_injection.dart
```

**Structure Decision**: Standard Flutter clean architecture feature module under `lib/features/queue/`. Follows the same pattern as existing `scheduling/`, `patient/`, and `clinic/` features. Two Bloc instances (QueueBloc for receptionist, MyQueueBloc for doctor) justified by Supabase Realtime stream requirement. TriageCubit for simple form submission.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Bloc instead of Cubit (QueueBloc, MyQueueBloc) | Supabase Realtime delivers database changes as a stream of events that must be merged with user actions in a single event pipeline | Cubit would require manual stream subscription management, breaking the clean event-driven model and making test/debug harder |