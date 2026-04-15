# Feature Specification: Queue & Check-In System

**Feature Branch**: `007-queue-checkin`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Implement a digital queue system for the clinic waiting room. Patients check in, get a queue token, and providers call the next patient."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Patient Check-In & Queue Token Generation (Priority: P1)

A receptionist checks in a patient who has a scheduled appointment. The system transitions the appointment status to checked_in, generates a daily auto-incremented queue token (e.g., Q-001), and the patient appears in the waiting queue. Walk-in patients without a prior appointment can also be added — the system creates an appointment on the fly and issues a queue token.

**Why this priority**: Check-in is the entry point of the entire queue workflow. Without it, no tokens exist and no downstream actions (call, start, complete) are possible. This is the foundational capability.

**Independent Test**: Can be fully tested by checking in a patient (scheduled or walk-in) and verifying a queue token is created with the correct daily number, correct status (waiting), and correct association to the patient and clinic.

**Acceptance Scenarios**:

1. **Given** a patient has a scheduled appointment with status "confirmed", **When** the receptionist selects the appointment and presses "Check In", **Then** the appointment status transitions to "checked_in", a queue token is created with status "waiting", a daily auto-incremented token number is assigned (e.g., Q-001), and the patient appears in the queue list.
2. **Given** a walk-in patient arrives with no prior appointment, **When** the receptionist selects "Walk-In" and enters the patient details, **Then** an appointment is created on the fly, a queue token is created with status "waiting" and the next available daily token number, and the patient appears in the queue list.
3. **Given** three patients have already been checked in today at this clinic, **When** the next patient is checked in, **Then** the token number is Q-004.
4. **Given** it is a new day, **When** the first patient is checked in, **Then** the token number resets to Q-001 regardless of yesterday's count.

---

### User Story 2 - Queue Management by Receptionist (Priority: P1)

The receptionist views the full queue for the clinic and manages patient flow using actions: call next patient, skip a patient, or mark a patient as no-show. The queue updates in real time via Supabase Realtime so multiple staff members see the same live state.

**Why this priority**: Queue management is the core operational workflow. Without the ability to call, skip, and manage patients, the queue system serves no purpose beyond check-in.

**Independent Test**: Can be fully tested by checking in multiple patients, calling the next patient, skipping a patient, marking a no-show, and verifying statuses and ordering update correctly — all visible in real time without refresh.

**Acceptance Scenarios**:

1. **Given** three patients are waiting in the queue, **When** the receptionist presses "Call Next" for a specific provider, **Then** the highest-priority waiting token assigned to that provider transitions to "called" status and a timestamp is recorded.
2. **Given** an urgent-priority patient and a normal-priority patient are both waiting, **When** "Call Next" is pressed, **Then** the urgent-priority patient is called first.
3. **Given** a patient has been called but does not respond, **When** the receptionist presses "No-Show", **Then** the token status transitions to "no_show".
4. **Given** a patient is waiting in the queue, **When** the receptionist presses "Skip", **Then** the token status transitions to "skipped" and the patient moves to the end of the queue with lower effective priority.
5. **Given** another staff member checks in a new patient on a different device, **When** that check-in is completed, **Then** the receptionist's queue list updates automatically without manual refresh.

---

### User Story 3 - Doctor's Personal Queue (Priority: P1)

A doctor views only their own assigned queue tokens with a "Call Next" button to call the next waiting patient and a "Start Consultation" button to begin seeing a called patient. The queue updates in real time.

**Why this priority**: Doctors need their own filtered, focused view to efficiently manage patient flow. This is essential for daily clinical operations alongside the receptionist view.

**Independent Test**: Can be fully tested by logging in as a doctor, viewing only tokens assigned to that doctor, calling the next patient, and starting a consultation — verifying correct status transitions and real-time updates.

**Acceptance Scenarios**:

1. **Given** a doctor is logged in, **When** they open "My Queue", **Then** they see only queue tokens assigned to them, ordered by priority then check-in time.
2. **Given** the doctor has a patient in "called" status, **When** they press "Start Consultation", **Then** the token status transitions to "in_progress" and a started_at timestamp is recorded.
3. **Given** the doctor has a patient in "in_progress" status, **When** they press "Complete", **Then** the token status transitions to "completed" and a completed_at timestamp is recorded.
4. **Given** no patients are waiting for this doctor, **When** they view "My Queue", **Then** an empty state message is displayed.

---

### User Story 4 - Basic Triage on Check-In (Priority: P2)

During check-in, the receptionist or nurse can optionally record quick vitals: blood pressure (systolic/diastolic), heart rate, temperature, weight, SpO2, and a chief complaint text field. These vitals are stored linked to the queue token and displayed alongside the patient entry in the doctor's queue view.

**Why this priority**: Triage is valuable but optional — the queue system functions fully without it. It enhances the doctor's preparation by showing vitals before the consultation.

**Independent Test**: Can be fully tested by checking in a patient, entering vitals on the triage form, saving, and verifying the vitals appear next to the patient on the doctor's queue view.

**Acceptance Scenarios**:

1. **Given** a patient is being checked in, **When** the receptionist navigates to the triage form for that token, **Then** they see fields for blood pressure (systolic/diastolic), heart rate, temperature, weight, SpO2, and chief complaint.
2. **Given** vitals have been entered, **When** the receptionist saves the triage form, **Then** the triage assessment is stored and linked to the queue token.
3. **Given** a triage assessment exists for a queued patient, **When** the doctor views their queue, **Then** the patient's vitals summary (key values and chief complaint) is displayed alongside the queue entry.
4. **Given** no vitals were recorded during check-in, **When** the doctor views the queue, **Then** the patient entry shows no triage data without errors.

---

### User Story 5 - Status Workflow & Transitions (Priority: P2)

Queue tokens follow a defined status lifecycle: waiting → called → in_progress → completed, with alternative paths to no_show (from called) and skipped (from waiting or called). The system enforces valid transitions and prevents invalid state changes.

**Why this priority**: Status integrity ensures the queue operates predictably. While the basic transitions are exercised in US1-US3, this story covers enforcement of valid transitions and edge cases.

**Independent Test**: Can be fully tested by attempting various status transitions and verifying that valid transitions succeed and invalid transitions are rejected with appropriate feedback.

**Acceptance Scenarios**:

1. **Given** a token is in "waiting" status, **When** "Call Next" is triggered, **Then** it transitions to "called" and called_at is recorded.
2. **Given** a token is in "called" status, **When** "Start Consultation" is triggered, **Then** it transitions to "in_progress" and started_at is recorded.
3. **Given** a token is in "in_progress" status, **When** "Complete" is triggered, **Then** it transitions to "completed" and completed_at is recorded.
4. **Given** a token is in "completed" status, **When** any action is attempted, **Then** the system rejects the transition with a user-friendly message.
5. **Given** a token is in "called" status, **When** "No-Show" is triggered, **Then** it transitions to "no_show".
6. **Given** a token is in "waiting" status, **When** "Skip" is triggered, **Then** it transitions to "skipped" and the token is re-queued at the end with lower effective priority.

---

### User Story 6 - Waiting Room Display Placeholder (Priority: P3)

A placeholder route exists for a future waiting room display screen that would show called tokens on a large screen in the waiting area.

**Why this priority**: This is a future enhancement. The placeholder ensures the route is reserved and the architecture anticipates this view without requiring implementation now.

**Independent Test**: Can be tested by navigating to the waiting room display route and verifying a placeholder page loads successfully.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** a user navigates to the waiting room display route, **Then** a placeholder page is shown indicating this feature is coming soon.

---

### Edge Cases

- What happens when two receptionists try to call the next patient simultaneously for the same provider? The system should handle race conditions gracefully — only one token transitions to "called".
- What happens when a patient is checked in but the clinic has no available providers? The token is created with "waiting" status and no provider assignment; it waits until a provider calls.
- What happens if the receptionist tries to check in the same appointment twice? The system should prevent duplicate check-ins and show an appropriate message.
- What happens if the realtime connection drops? The UI should indicate connection status and allow manual refresh as a fallback.
- What happens if a skipped patient is called again? The skipped token can be re-called by selecting it specifically from the queue.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow receptionists to check in patients with scheduled appointments, transitioning appointment status to "checked_in" and creating a queue token with "waiting" status.
- **FR-002**: System MUST support walk-in patient check-in by creating an appointment on the fly and generating a queue token.
- **FR-003**: System MUST auto-increment queue token numbers daily per clinic, resetting to 1 at the start of each new day.
- **FR-004**: System MUST display a formatted token number (e.g., Q-001, Q-002) for each queue entry.
- **FR-005**: System MUST provide a receptionist queue view showing all tokens for the clinic with their current status, patient name, provider, priority, and check-in time.
- **FR-006**: System MUST provide a "Call Next" action that selects the highest-priority waiting token for a given provider and transitions it to "called" status.
- **FR-007**: System MUST provide a "Start Consultation" action that transitions a "called" token to "in_progress" status.
- **FR-008**: System MUST provide a "Complete" action that transitions an "in_progress" token to "completed" status.
- **FR-009**: System MUST provide a "Skip" action that transitions a token to "skipped" status and re-queues it at the end with lower effective priority.
- **FR-010**: System MUST provide a "No-Show" action that transitions a "called" token to "no_show" status.
- **FR-011**: System MUST enforce valid status transitions and reject invalid ones with user-friendly feedback.
- **FR-012**: System MUST provide a doctor-specific "My Queue" view showing only tokens assigned to the logged-in provider.
- **FR-013**: System MUST update queue views in real time using Supabase Realtime subscriptions without requiring manual refresh.
- **FR-014**: System MUST support recording optional triage vitals (blood pressure systolic/diastolic, heart rate, temperature, weight, SpO2, chief complaint) linked to a queue token.
- **FR-015**: System MUST display triage data alongside patient entries in the doctor's queue view when available.
- **FR-016**: System MUST support two priority levels for queue tokens: normal (default) and urgent.
- **FR-017**: System MUST provide a placeholder route for a future waiting room display screen.
- **FR-018**: System MUST enforce row-level security on queue tokens and triage assessments filtered by clinic.
- **FR-019**: System MUST prevent duplicate check-ins for the same appointment.
- **FR-020**: System MUST record timestamps for key state transitions: called_at, started_at, completed_at.

### Key Entities

- **Queue Token**: Represents a patient's position in the clinic queue. Key attributes: token number (daily auto-increment per clinic), patient reference, appointment reference (nullable for walk-ins), assigned provider, status (waiting/called/in_progress/completed/no_show/skipped), priority (normal/urgent), and transition timestamps (called_at, started_at, completed_at). Belongs to a clinic and optionally a location.
- **Triage Assessment**: Vitals and chief complaint recorded during check-in. Key attributes: blood pressure (systolic/diastolic), heart rate, temperature, weight, SpO2, chief complaint text, and who recorded it. Linked to a single queue token.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Receptionist can check in a scheduled patient and generate a queue token in under 30 seconds.
- **SC-002**: Walk-in patient check-in (including on-the-fly appointment creation) completes in under 60 seconds.
- **SC-003**: Queue updates propagate to all connected clients within 2 seconds of a status change.
- **SC-004**: "Call Next" correctly prioritizes urgent tokens over normal tokens 100% of the time.
- **SC-005**: Token numbers reset correctly at the start of each new day with no carryover from the previous day.
- **SC-006**: Doctors see only their own assigned tokens in "My Queue" with zero cross-provider leakage.
- **SC-007**: Triage form can be completed and saved in under 45 seconds.
- **SC-008**: All queue status transitions are validated — invalid transitions are rejected 100% of the time.
- **SC-009**: The system correctly handles concurrent operations (e.g., simultaneous "Call Next") without data corruption.
- **SC-010**: Queue data is isolated per clinic — no cross-clinic data visibility.

## Assumptions

- The existing appointment system (006-scheduling-appointments) is implemented and provides appointment entities, status management, and patient associations that this feature will integrate with.
- The existing clinic tenancy system (004-clinic-tenancy) provides clinic_id context and staff/provider role information.
- The existing patient feature (005-patients) provides patient search and selection capabilities for walk-in check-in.
- Supabase Realtime is available and enabled for the relevant tables in the project's Supabase instance.
- The "location_id" field on queue tokens is included for future multi-location support but is not actively used in the initial implementation.
- The "no-show" determination is manual (receptionist judgment) in the initial version — automatic time-based no-show detection is a future enhancement.
- The waiting room display is a placeholder only; full implementation is deferred to a future feature.
- Encounter/EHR creation upon "Start Consultation" is deferred to a future feature; the current implementation only records the status transition.
- The queue uses Bloc (not Cubit) specifically because Supabase Realtime delivers events as a stream, which maps naturally to Bloc's event-driven architecture.