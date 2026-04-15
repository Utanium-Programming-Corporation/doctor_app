# Feature Specification: Scheduling & Appointments

**Feature Branch**: `006-scheduling-appointments`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Implement appointment booking, calendar views, and provider availability management. This is the core scheduling module."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Book an Appointment (Priority: P1)

A receptionist or doctor selects a patient, chooses a provider and appointment type, picks an available date and time slot, and confirms the booking. The system calculates available slots based on the provider's weekly availability minus existing appointments. On confirmation, the appointment is created with status "scheduled" and appears in the provider's daily list.

**Why this priority**: Appointment booking is the core action of the scheduling module. Without it, no other scheduling functionality (views, status transitions, rescheduling) has meaning.

**Independent Test**: Can be fully tested by navigating to the booking page, selecting an existing patient, choosing a provider and appointment type, picking an available slot, and confirming. The appointment appears in the provider's daily appointment list.

**Acceptance Scenarios**:

1. **Given** a logged-in staff member on the booking page, **When** they search for and select a patient, **Then** the patient's name and details are displayed in the booking form.
2. **Given** a patient is selected, **When** the staff member selects a provider and appointment type, **Then** the system shows the appointment duration and only available time slots for the selected date.
3. **Given** available slots are displayed, **When** the staff member picks a slot and taps "Confirm," **Then** an appointment is created with status "scheduled," correct start/end times, and the user sees a confirmation.
4. **Given** a provider has no remaining availability on a date, **When** the staff member selects that date, **Then** the system shows no available slots and a message indicating the provider is fully booked.
5. **Given** two staff members attempt to book the same slot simultaneously, **When** both confirm, **Then** only one booking succeeds and the other receives an error message about the slot no longer being available.
6. **Given** a provider has a break from 13:00–14:00, **When** available slots are calculated, **Then** no slots overlap with the break period.

---

### User Story 2 - View Daily Appointments (Priority: P1)

A staff member (admin or receptionist) opens the appointment list page, selects a date and optionally a provider, and sees all appointments for that day ordered by time. Each item shows the patient name, appointment type, time, duration, and current status. The list updates when a different date or provider is selected.

**Why this priority**: Viewing the day's schedule is the most frequent read operation in any clinic. All staff need this to coordinate patient flow.

**Independent Test**: Can be tested by creating several appointments for a provider on a specific date, then navigating to the appointment list page, selecting that date and provider, and verifying all appointments appear in chronological order with correct details.

**Acceptance Scenarios**:

1. **Given** appointments exist for a provider on a date, **When** a staff member opens the appointment list and selects that provider and date, **Then** all appointments for that provider/date appear ordered by start time.
2. **Given** no appointments exist for the selected provider/date, **When** the staff member views the list, **Then** an empty state message is displayed.
3. **Given** the appointment list is visible, **When** the staff member taps an appointment, **Then** the appointment detail screen opens.
4. **Given** the appointment list defaults to today's date, **When** the page loads, **Then** today's appointments for the selected provider are shown.

---

### User Story 3 - Doctor's "My Day" View (Priority: P1)

A logged-in doctor opens the "My Day" page and sees their own appointments for today, ordered by time. Each entry shows the patient name, appointment type, time, and status. The doctor can tap an appointment to view its details or perform status transitions (check-in, start, complete).

**Why this priority**: Doctors need a quick, dedicated view of their own schedule. This is distinct from the admin view because it automatically filters to the logged-in provider and today's date.

**Independent Test**: Can be tested by logging in as a doctor who has appointments today, navigating to "My Day," and verifying only that doctor's appointments for today appear.

**Acceptance Scenarios**:

1. **Given** a doctor is logged in and has appointments today, **When** they open the "My Day" page, **Then** only their own appointments for today appear, ordered by start time.
2. **Given** a doctor has no appointments today, **When** they open "My Day," **Then** an empty state message is shown.
3. **Given** the "My Day" list is visible, **When** the doctor taps an appointment, **Then** the appointment detail screen opens.

---

### User Story 4 - Manage Appointment Status (Priority: P2)

A staff member opens an appointment's detail screen and transitions its status through the workflow: scheduled → confirmed → checked_in → in_progress → completed. They can also cancel an appointment (with an optional reason) or mark it as a no-show. The system enforces valid transitions — completed appointments cannot be cancelled.

**Why this priority**: Status tracking is essential for patient flow management. It depends on appointments existing (US1) but is critical for day-to-day operations.

**Independent Test**: Can be tested by creating an appointment, opening its detail screen, and stepping through each valid status transition, verifying the status updates correctly. Then test invalid transitions (e.g., cancelling a completed appointment) and verify they are rejected.

**Acceptance Scenarios**:

1. **Given** an appointment with status "scheduled," **When** a staff member taps "Confirm," **Then** the status changes to "confirmed."
2. **Given** an appointment with status "confirmed," **When** a staff member taps "Check In," **Then** the status changes to "checked_in."
3. **Given** an appointment with status "checked_in," **When** a staff member taps "Start," **Then** the status changes to "in_progress."
4. **Given** an appointment with status "in_progress," **When** a staff member taps "Complete," **Then** the status changes to "completed."
5. **Given** an appointment with status "scheduled," **When** a staff member taps "Cancel" and optionally enters a reason, **Then** the status changes to "cancelled" and the reason is stored.
6. **Given** an appointment with status "scheduled," **When** a staff member taps "No-Show," **Then** the status changes to "no_show."
7. **Given** an appointment with status "completed," **When** a staff member attempts to cancel it, **Then** the action is not available and the system does not allow the transition.
8. **Given** an appointment with any status except "completed," **When** a staff member cancels it, **Then** the cancellation succeeds.

---

### User Story 5 - Cancel and Reschedule Appointments (Priority: P2)

A staff member opens an existing appointment and chooses to reschedule it. They select a new date and time slot (validated against provider availability). The original appointment is cancelled and a new one is created at the chosen slot. Alternatively, they can simply cancel without rebooking.

**Why this priority**: Rescheduling is a frequent operation in clinics but depends on the booking flow (US1) and status management (US4) already working.

**Independent Test**: Can be tested by creating an appointment, opening its detail, tapping "Reschedule," selecting a new available slot, confirming, and verifying the old appointment is cancelled and a new one exists at the new time.

**Acceptance Scenarios**:

1. **Given** an appointment with status "scheduled" or "confirmed," **When** a staff member taps "Reschedule," **Then** the booking flow opens with the patient and provider pre-selected, showing available slots.
2. **Given** the reschedule flow is open, **When** the staff member picks a new slot and confirms, **Then** the original appointment status changes to "cancelled" (with reason "Rescheduled") and a new appointment is created at the selected slot.
3. **Given** an appointment with status "completed," **When** a staff member views the detail, **Then** the "Reschedule" option is not available.

---

### User Story 6 - Manage Appointment Types (Priority: P2)

A clinic admin creates and manages appointment types (e.g., "General Consultation — 30 min," "Follow-Up — 15 min," "Procedure — 60 min"). Each type has a name, duration, color, description, and active/inactive status. Only active types appear in the booking flow.

**Why this priority**: Appointment types must exist before booking can work (they drive duration calculation and slot generation). However, they can be seeded or hardcoded initially, making this a setup task rather than a P1.

**Independent Test**: Can be tested by navigating to appointment type management, creating a new type with all fields, verifying it appears in the list, then deactivating it and verifying it no longer appears in the booking flow's type selector.

**Acceptance Scenarios**:

1. **Given** an admin is logged in, **When** they navigate to appointment type management and tap "Add," **Then** a form appears with fields for name, duration (selectable: 15/30/45/60/90/120 minutes), color, description, and active toggle.
2. **Given** the form is filled, **When** the admin saves, **Then** the appointment type is created and appears in the list.
3. **Given** an appointment type exists, **When** the admin deactivates it, **Then** it no longer appears as an option in the booking flow.
4. **Given** an appointment type exists, **When** the admin edits its name or duration, **Then** the changes are saved. Existing appointments using that type are not affected.

---

### User Story 7 - Set Provider Weekly Availability (Priority: P2)

A provider or admin sets the provider's weekly schedule — which days they work, start and end times for each day, and their location. They can also define break periods (e.g., lunch breaks). The availability is used by the booking system to calculate open time slots.

**Why this priority**: Provider availability must be configured before appointment booking can calculate available slots. Like appointment types, this is a setup prerequisite.

**Independent Test**: Can be tested by navigating to manage availability for a provider, adding availability for Monday 9:00–17:00 with a 13:00–14:00 break, saving, and then verifying the booking flow only shows slots within 9:00–13:00 and 14:00–17:00 for that Monday.

**Acceptance Scenarios**:

1. **Given** an admin or provider is on the manage availability page, **When** they add an availability entry for a day of the week with start time, end time, and location, **Then** the entry is saved and displayed in the weekly schedule view.
2. **Given** an availability entry exists, **When** the user defines a break slot within that entry's hours, **Then** the break is reflected when calculating available appointment slots.
3. **Given** multiple availability entries exist for a provider, **When** the user views the weekly schedule, **Then** all entries are organized by day of week.
4. **Given** an availability entry is deactivated, **When** the booking system calculates slots, **Then** that entry's time range is excluded.

---

### User Story 8 - Set Time-Off / Blocked Dates (Priority: P3)

An admin or provider blocks specific dates (e.g., vacation, conference) so no appointments can be booked on those dates. The system excludes blocked dates when generating available slots.

**Why this priority**: Time-off management is important but less frequent than daily scheduling operations. The system functions without it initially — providers can manage their availability manually.

**Independent Test**: Can be tested by blocking a specific date for a provider, then attempting to book on that date and verifying no slots are available.

**Acceptance Scenarios**:

1. **Given** a provider's availability page, **When** an admin adds a blocked date, **Then** the date appears as blocked in the provider's schedule.
2. **Given** a date is blocked for a provider, **When** the booking system generates slots for that date, **Then** no slots are returned.
3. **Given** a blocked date exists, **When** the admin removes the block, **Then** slots become available again for that date based on the provider's weekly availability.

### Edge Cases

- What happens when a provider's availability changes after appointments are already booked? Existing appointments remain valid; only future slot calculations are affected.
- What happens when an appointment type's duration changes? Existing appointments retain their original start/end times. Only new bookings use the updated duration.
- What happens when two users book the last available slot simultaneously? The database EXCLUDE constraint on (provider_id, time_range) prevents double-booking; only the first transaction succeeds, the second receives an error.
- What happens when a patient is deactivated but has future appointments? Future appointments remain but the patient cannot be selected for new bookings.
- What happens when the selected appointment type duration exceeds the remaining time in a provider's availability window? That slot is not offered as available.
- What happens when a provider has overlapping availability entries for the same day? The system treats them as a union of available time; booking logic merges overlapping ranges.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow staff to book appointments by selecting a patient, provider, appointment type, date, and available time slot.
- **FR-002**: System MUST calculate available time slots based on provider weekly availability minus existing appointments and break periods.
- **FR-003**: System MUST prevent double-booking of providers using a database-level exclusion constraint on provider and time range.
- **FR-004**: System MUST support appointment statuses: scheduled, confirmed, checked_in, in_progress, completed, cancelled, and no_show.
- **FR-005**: System MUST enforce valid status transitions: scheduled → confirmed → checked_in → in_progress → completed; scheduled/confirmed → cancelled; scheduled → no_show. Completed appointments cannot be cancelled.
- **FR-006**: System MUST display a daily appointment list filtered by provider and date, ordered by start time.
- **FR-007**: System MUST provide a "My Day" view that automatically shows the logged-in doctor's appointments for today.
- **FR-008**: System MUST allow staff to cancel an appointment with an optional cancellation reason.
- **FR-009**: System MUST allow staff to reschedule an appointment by cancelling the original and booking a new slot.
- **FR-010**: System MUST support appointment type management: create, edit, and activate/deactivate types with name, duration (15/30/45/60/90/120 minutes), color, and description.
- **FR-011**: System MUST allow providers or admins to set weekly availability per day of week with start time, end time, and location.
- **FR-012**: System MUST support break periods within availability entries that are excluded from slot generation.
- **FR-013**: System MUST allow blocking specific dates for a provider, preventing all bookings on those dates.
- **FR-014**: System MUST scope all scheduling data (appointments, types, availability) to the current clinic. Doctors see only their own appointments; admins and receptionists see all clinic appointments.
- **FR-015**: System MUST store cancellation reasons when an appointment is cancelled.
- **FR-016**: Only active appointment types MUST appear as options during booking.
- **FR-017**: System MUST support the multi-step booking flow: select patient → select appointment type → select provider → select date/slot → confirm.
- **FR-018**: System MUST record which staff member created each appointment.

### Key Entities

- **Appointment**: A scheduled encounter between a patient and provider at a specific date/time within a clinic. Key attributes: patient, provider, appointment type, location, start time, end time, status, cancellation reason, notes, created by.
- **Appointment Type**: A clinic-defined category of appointment with a name, standard duration, display color, and description. Can be activated or deactivated.
- **Provider Availability**: A recurring weekly time window when a provider is available for appointments. Key attributes: day of week, start time, end time, location, active status.
- **Time Slot**: A computed, available booking window derived from provider availability minus existing appointments and breaks. Not persisted — calculated on demand.
- **Blocked Date**: A specific date when a provider is unavailable, overriding their weekly availability.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Staff can complete an appointment booking (patient selection through confirmation) in under 60 seconds.
- **SC-002**: Double-booking of a provider is impossible — concurrent booking attempts for the same slot result in exactly one successful booking.
- **SC-003**: Available time slots are displayed within 2 seconds of selecting a provider and date.
- **SC-004**: A doctor can view their full day's schedule in a single screen within 1 second of opening "My Day."
- **SC-005**: Appointment status transitions are reflected immediately and follow the defined workflow without allowing invalid transitions.
- **SC-006**: All scheduling data is correctly scoped to clinics — no cross-clinic data leakage.
- **SC-007**: Providers can set up their complete weekly availability in under 3 minutes.
- **SC-008**: 100% of appointment bookings respect provider availability windows, break periods, and blocked dates.

## Assumptions

- Patients already exist in the system (from the 005-patients feature) and can be searched/selected during booking.
- Provider/staff records exist in the system (from the 004-clinic-tenancy feature) with role information (doctor, admin, receptionist).
- The logged-in user's provider ID is available from the authentication/clinic context for the "My Day" view.
- Appointment duration is determined solely by the appointment type — there is no per-appointment custom duration in this version.
- Time zone handling follows the clinic's configured timezone. All times are stored as timestamptz in the database.
- No recurring appointment support in this version — each appointment is individually booked.
- No patient-facing self-booking in this version — all bookings are made by clinic staff.
- No SMS/email notifications for appointment reminders in this version.
- The "location" field references an existing location within the clinic (from clinic tenancy) but is optional.
- Break periods are modeled as gaps in availability rather than separate entities — the availability schedule defines contiguous work windows, and breaks are gaps between consecutive entries for the same day.
- Blocked dates override weekly availability completely for the entire day — partial day blocks are not supported in this version.
# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## Assumptions

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right assumptions based on reasonable defaults
  chosen when the feature description did not specify certain details.
-->

- [Assumption about target users, e.g., "Users have stable internet connectivity"]
- [Assumption about scope boundaries, e.g., "Mobile support is out of scope for v1"]
- [Assumption about data/environment, e.g., "Existing authentication system will be reused"]
- [Dependency on existing system/service, e.g., "Requires access to the existing user profile API"]
