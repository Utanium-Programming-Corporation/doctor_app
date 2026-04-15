# Research: Scheduling & Appointments

**Feature**: 006-scheduling-appointments
**Date**: 2026-04-12

## Research Tasks

### 1. PostgreSQL EXCLUDE Constraint for Double-Booking Prevention

**Decision**: Use `EXCLUDE USING gist` constraint on `(provider_id WITH =, tstzrange(start_time, end_time) WITH &&)` to prevent overlapping appointments for the same provider at the database level.

**Rationale**: This is the standard PostgreSQL approach for preventing range overlaps. The `btree_gist` extension enables combining equality (`=`) and range overlap (`&&`) operators in a single exclusion constraint. It is enforced at the transaction level, making it race-condition-proof — even concurrent inserts are serialized.

**Alternatives considered**:
- Application-level locking: Rejected — race conditions possible under concurrent access.
- Advisory locks: Rejected — adds complexity; EXCLUDE constraint is simpler and more reliable.
- Unique constraint on discrete time slots: Rejected — inflexible; doesn't handle variable-duration appointments.

**Implementation detail**: The constraint excludes cancelled and no-show appointments (they shouldn't block future bookings). This is achieved by adding a `WHERE status NOT IN ('cancelled', 'no_show')` partial index, or by conditioning the constraint. Since PostgreSQL EXCLUDE constraints don't support WHERE clauses directly, we use a **partial exclusion constraint** via a workaround: create a GiST index with the constraint only on non-terminal-status rows. Alternative: handle in application layer by filtering out cancelled/no_show from the conflict check query, and rely on the EXCLUDE constraint as a final safety net (which may occasionally reject bookings that would replace cancelled ones — acceptable for v1).

**Final approach for v1**: Apply the EXCLUDE constraint unconditionally (on all rows regardless of status). When a slot has a cancelled appointment, the old row's time range still "occupies" the constraint space. To allow re-booking a cancelled slot, the application must first verify availability client-side (filtering out cancelled/no_show), and if the EXCLUDE constraint fires on insert, catch the error. In practice, since cancelled appointments are relatively rare and the slot computation already filters them out, this is acceptable. A future optimization could use a conditional trigger or partial index.

**Revised final approach**: Use a boolean column `is_blocking` (default true, set to false when status becomes cancelled/no_show) and include it in the EXCLUDE constraint: `EXCLUDE USING gist (provider_id WITH =, tstzrange(start_time, end_time) WITH &&) WHERE (is_blocking = true)`. PostgreSQL EXCLUDE constraints DO support WHERE clauses for partial constraints. This cleanly handles the cancelled slot re-use.

### 2. Time Zone Handling for Appointments

**Decision**: Store all times as `timestamptz` in PostgreSQL. The Flutter client sends/receives ISO 8601 strings. Time comparisons happen in the database using the server's timezone setting or explicit `AT TIME ZONE` casts.

**Rationale**: Using `timestamptz` ensures correct behavior across timezones. The clinic's timezone is implicit — all users in a clinic share the same timezone context. Supabase returns timestamptz as ISO 8601 with UTC offset, which Dart's `DateTime.parse()` handles correctly.

**Alternatives considered**:
- Storing as `timestamp` (without timezone): Rejected — ambiguous when the server or client timezone changes.
- Storing timezone per clinic: Deferred — adds complexity; not needed while all clinics operate in a single timezone context.

### 3. Slot Generation Strategy (Client-Side vs Server-Side)

**Decision**: Compute available slots **client-side** in a domain use case. The client fetches three datasets (provider availability, blocked dates, existing appointments) and computes slots locally.

**Rationale**: Typical clinic volumes are small (~20 appointments/provider/day, ~5 availability windows/provider/week). The computation is O(windows × slots_per_window × appointments) which is negligible. Client-side computation avoids a custom Supabase Edge Function and keeps the logic in the testable domain layer.

**Alternatives considered**:
- PostgreSQL function (`get_available_slots`): Rejected for v1 — adds migration complexity and moves business logic to SQL. May be worthwhile for v2 if performance is an issue.
- Supabase Edge Function: Rejected — adds Deno deployment complexity for a simple computation.

### 4. Appointment Status Validation Strategy

**Decision**: Validate status transitions in the **domain layer** (Dart `AppointmentStatus` entity with `canTransitionTo()` method). The database stores status as a `text` column with a CHECK constraint for valid values but no transition validation.

**Rationale**: Status transitions are business logic that belongs in the domain layer. DB-level triggers for state machine validation add complexity and make the logic harder to test and change. The domain validation is sufficient because all writes go through the use cases.

**Alternatives considered**:
- PostgreSQL trigger for transition validation: Rejected — harder to test, harder to change, and the domain layer already validates.
- Database enum type: Rejected — PostgreSQL enums are difficult to alter (adding values requires ALTER TYPE). Text with CHECK constraint is more flexible.

### 5. Multi-Step Booking Flow State Management

**Decision**: Single `BookAppointmentCubit` with a `currentStep` integer tracking the wizard step. State is a single sealed class with step-specific data accumulated as the user progresses.

**Rationale**: The booking flow is linear (no branching). A single cubit simplifies state management — each step's selection is stored in the state and used by subsequent steps. The cubit calls different use cases at each step (search patients, get types, get slots, create appointment).

**Alternatives considered**:
- Separate cubit per step: Rejected — would require passing state between cubits, adding unnecessary complexity.
- Bloc with events: Rejected — no complex event streams; cubit methods are sufficient.

### 6. Cross-Feature Integration Pattern (Patient Search)

**Decision**: Inject `SearchPatients` use case (from 005-patients) into `BookAppointmentCubit` via GetIt DI. The scheduling feature imports only the `Patient` entity and `SearchPatientsParams` from the patient domain layer.

**Rationale**: This follows Constitution Principle IV — cross-feature communication through shared domain contracts. The patient entity and search params are stable interfaces. No direct imports of patient data or presentation layers.

**Alternatives considered**:
- Copy patient search logic into scheduling: Rejected — violates DRY and requires maintaining duplicate code.
- Extract patient search to core/: Rejected — patient search is patient-domain-specific; moving to core would bloat the core module.
- Pass patient search as a constructor callback: Rejected — unnecessary indirection when DI handles it cleanly.

### 7. Provider Availability Modeling

**Decision**: Each availability entry is a single row: `(provider_id, day_of_week, start_time, end_time, location_id, is_active)`. Multiple entries per day create the work windows; gaps between entries are breaks.

**Rationale**: Simple, flexible, and requires no additional "break" entity. A provider working Mon 9-13 and 14-17 just has two rows for Monday. The slot computation iterates each window independently.

**Alternatives considered**:
- Single entry per day with embedded breaks array (JSONB): Rejected — harder to query and validate.
- Separate break_periods table: Rejected — adds a table for something naturally expressed as gaps.
