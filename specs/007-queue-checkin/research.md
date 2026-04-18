# Research: Queue & Check-In System

**Feature**: 007-queue-checkin
**Date**: 2026-04-12

## R1: Supabase Realtime Integration with flutter_bloc

**Decision**: Use `supabase_flutter` Realtime channels to subscribe to `queue_tokens` table changes, piping events into Bloc via `add()`.

**Rationale**: Supabase Realtime provides PostgreSQL CDC (Change Data Capture) over WebSocket channels. The `stream()` API on `SupabaseClient` returns a `Stream<List<Map<String, dynamic>>>` for a table filtered by conditions. This stream naturally maps to Bloc events. The Bloc `on<Event>` handlers process both realtime events and user-initiated actions in a single sequential pipeline, preventing race conditions.

**Pattern**:
```dart
// In QueueRemoteDataSource:
Stream<List<QueueTokenModel>> watchQueueForClinic(String clinicId) {
  return _client
    .from('queue_tokens')
    .stream(primaryKey: ['id'])
    .eq('clinic_id', clinicId)
    .order('created_at')
    .map((rows) => rows.map((r) => QueueTokenModel.fromJson(r)).toList());
}

// In QueueBloc:
on<QueueSubscriptionRequested>((event, emit) async {
  await emit.forEach(
    _getQueueForClinic(params),
    onData: (either) => either.fold(
      (failure) => QueueError(failure.message),
      (tokens) => QueueLoaded(tokens: tokens),
    ),
  );
});
```

**Alternatives considered**:
- Polling with Timer: Rejected — introduces latency (minimum poll interval) and unnecessary network traffic.
- StreamController in Cubit: Rejected — Cubit lacks native event pipeline; manual subscription management is error-prone and harder to test.

---

## R2: Daily Token Auto-Increment via Postgres Function

**Decision**: Use a Postgres function `generate_queue_token_number(p_clinic_id UUID)` that atomically computes the next token number per clinic per day.

**Rationale**: Token numbering must be: (a) atomic to prevent duplicates under concurrent check-ins, (b) scoped per clinic, (c) reset daily. A Postgres function with `SELECT ... FOR UPDATE` or `COALESCE(MAX(...), 0) + 1` within a transaction satisfies all three. An advisory lock or `SELECT FOR UPDATE` prevents race conditions.

**Implementation**:
```sql
CREATE OR REPLACE FUNCTION generate_queue_token_number(p_clinic_id UUID)
RETURNS INTEGER AS $$
DECLARE
  next_number INTEGER;
BEGIN
  SELECT COALESCE(MAX(token_number), 0) + 1
  INTO next_number
  FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND created_at::date = CURRENT_DATE;
  RETURN next_number;
END;
$$ LANGUAGE plpgsql;
```

Called as a default column value or invoked explicitly in the check-in RPC.

**Alternatives considered**:
- Client-side counter: Rejected — race conditions with multiple receptionists.
- Postgres SEQUENCE: Rejected — sequences are global and don't reset daily per clinic.
- Separate counter table: Considered but adds complexity; the `MAX()` approach is simpler and sufficient for expected throughput (< 100 tokens/day/clinic).

---

## R3: Check-In Flow — Appointment vs Walk-In

**Decision**: Two check-in paths converge at a shared `check_in_patient` RPC: (A) from appointment (pre-fills patient/provider/type), (B) walk-in (creates appointment on the fly, then checks in).

**Rationale**: Both paths end with the same result — a queue token linked to an appointment. The appointment serves as the canonical patient-visit record. Walk-ins create a "walk-in" appointment type to maintain referential integrity.

**Flow A — Scheduled Appointment**:
1. Receptionist navigates to check-in page → sees today's confirmed appointments
2. Selects appointment → presses "Check In"
3. System: updates appointment status → `checked_in`, calls `generate_queue_token_number()`, inserts queue token with `status = waiting`
4. Optionally navigates to triage form

**Flow B — Walk-In**:
1. Receptionist navigates to check-in page → presses "Walk-In"
2. Searches/selects patient (reuses existing `SearchPatients` from patient feature)
3. Selects provider and appointment type
4. System: creates appointment (status = `checked_in`, type = selected or "Walk-In"), calls `generate_queue_token_number()`, inserts queue token with `status = waiting`
5. Optionally navigates to triage form

**Alternatives considered**:
- Queue token without appointment for walk-ins: Rejected — breaks referential integrity and reporting. Every visit should have an appointment record.

---

## R4: Queue Priority Algorithm (Call Next)

**Decision**: "Call Next" selects the highest-priority waiting token for the specified provider, ordered by priority (urgent first) then creation time (FIFO within same priority). Skipped tokens go to the end with their original priority.

**Rationale**: Simple two-tier priority (urgent/normal) with FIFO within each tier. Skipped tokens are re-inserted by updating their status back to "waiting" but with an incremented `skip_count` which pushes them after other same-priority tokens.

**Algorithm**:
```sql
SELECT id FROM queue_tokens
WHERE clinic_id = $1
  AND provider_id = $2
  AND status = 'waiting'
  AND created_at::date = CURRENT_DATE
ORDER BY
  CASE priority WHEN 'urgent' THEN 0 ELSE 1 END,
  skip_count ASC,
  created_at ASC
LIMIT 1;
```

**Alternatives considered**:
- Numeric priority (1-10 scale): Rejected — over-engineered for two tiers.
- Separate priority queue data structure: Rejected — the SQL ORDER BY approach is sufficient and keeps logic in the database.

---

## R5: Triage Data Flow

**Decision**: Triage is a separate `triage_assessments` table linked to `queue_token_id`. Recorded optionally after check-in via a dedicated form page. Displayed as a summary card in the doctor's queue view.

**Rationale**: Keeping triage separate from the queue token keeps the token entity focused on queue management. Triage data is medical data that may later link to EHR encounters. The 1:1 relationship (one triage per token) is enforced by a UNIQUE constraint on `queue_token_id`.

**Fields**: blood_pressure_systolic (int), blood_pressure_diastolic (int), heart_rate (int), temperature (decimal), weight (decimal), spo2 (int), chief_complaint (text), recorded_by (UUID), created_at (timestamptz).

**Alternatives considered**:
- Embed vitals in queue_tokens table: Rejected — violates single responsibility, makes the token model bloated, and triage is optional.
- Separate vitals per measurement: Rejected — over-normalized for a simple set of initial vitals.

---

## R6: Valid Status Transitions

**Decision**: Enforce valid status transitions at the domain layer (Dart) and optionally via a Postgres CHECK trigger.

**Rationale**: Defense in depth — the domain entity validates transitions before they reach the data layer, and the DB provides a safety net.

**Transition Map**:
```
waiting    → called, skipped
called     → in_progress, no_show, skipped
in_progress → completed
completed  → (terminal)
no_show    → (terminal)
skipped    → waiting (re-queued)
```

The `QueueTokenStatus` enum will have an `isValidTransition(QueueTokenStatus next)` method, mirroring the pattern already used in `AppointmentStatus`.

---

## R7: Cross-Feature Integration

**Decision**: The queue feature depends on the scheduling feature's `AppointmentStatus` enum and the patient feature's search capability. These are accessed via injected use cases, not direct feature imports.

**Rationale**: Constitution IV prohibits cross-feature imports. The `UpdateAppointmentStatus` use case from the scheduling feature is injected into the queue's `CheckInPatient` use case via GetIt. Patient search reuses the existing `SearchPatients` use case from the patient feature.

**Dependencies injected via DI**:
- `UpdateAppointmentStatus` (from scheduling) — to transition appointment to `checked_in`
- `CreateAppointment` (from scheduling) — for walk-in appointments
- `SearchPatients` (from patient) — for patient lookup during walk-in check-in

**Alternatives considered**:
- Direct import of scheduling repo: Rejected — violates Constitution IV.
- Duplicating appointment update logic: Rejected — violates DRY.
