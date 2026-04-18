# Quickstart: Queue & Check-In System

**Feature**: 007-queue-checkin
**Branch**: `007-queue-checkin`

## Prerequisites

1. Phases 001–006 implemented (core, auth, clinic, patient, scheduling)
2. Supabase project with Realtime enabled
3. Flutter SDK installed, `flutter pub get` run

## Setup Steps

### 1. Database Migration

Run the SQL migration in your Supabase SQL editor:
```
specs/007-queue-checkin/contracts/001-migration.sql
```

This creates:
- `queue_tokens` table with RLS
- `triage_assessments` table with RLS
- `generate_queue_token_number()` function (daily auto-increment)
- `check_in_patient()` RPC (atomic check-in + appointment status update)
- `call_next_patient()` RPC (atomic priority-based next patient selection)
- Realtime publication for `queue_tokens`

### 2. Build Generated Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Verify

```bash
dart analyze
flutter test
```

## Key Architecture Decisions

- **Bloc over Cubit**: QueueBloc and MyQueueBloc use the Bloc pattern because Supabase Realtime delivers queue changes as a stream of events. Bloc's `on<Event>` handlers naturally merge realtime events with user actions. See `research.md` R1 and `plan.md` Constitution Check V.
- **Check-in RPC**: Token creation and appointment status update happen atomically in a Postgres function to prevent race conditions with concurrent receptionists.
- **Call Next RPC**: Uses `FOR UPDATE SKIP LOCKED` to prevent two providers from calling the same patient simultaneously.
- **Triage**: Separate table (1:1 with queue token) — optional vitals recorded post check-in, displayed in doctor's queue view.

## File Map

| Layer | Key Files |
|-------|-----------|
| Domain entities | `lib/features/queue/domain/entities/queue_token.dart`, `triage_assessment.dart` |
| Domain repos | `lib/features/queue/domain/repositories/queue_repository.dart`, `triage_repository.dart` |
| Domain use cases | `lib/features/queue/domain/usecases/` (10 use cases) |
| Data models | `lib/features/queue/data/models/queue_token_model.dart`, `triage_assessment_model.dart` |
| Data sources | `lib/features/queue/data/datasources/` (queue + triage remote) |
| Data repos | `lib/features/queue/data/repositories/` (queue + triage impl) |
| Bloc | `lib/features/queue/presentation/bloc/` (QueueBloc, MyQueueBloc) |
| Cubit | `lib/features/queue/presentation/cubit/` (TriageCubit) |
| Pages | `lib/features/queue/presentation/pages/` (5 pages + widgets/) |
| DI | `lib/features/queue/di/queue_injection.dart` |
| Routes | `lib/core/router/route_names.dart`, `app_router.dart` |
