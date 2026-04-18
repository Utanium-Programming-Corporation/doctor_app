# Feature Specification: Clinic & Multi-Tenant Setup

**Feature Branch**: `004-clinic-tenancy`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Implement clinic creation, clinic selection, and multi-tenant data isolation. After a doctor signs in for the first time and creates their profile, they must either create a new clinic or join an existing one via invite code."

## User Scenarios & Testing

### User Story 1 - Create a New Clinic (Priority: P1)

A newly signed-up doctor who has completed profile setup but has no clinic association is presented with a choice: "Create Clinic" or "Join Clinic." Choosing "Create Clinic" opens a form where the doctor enters the clinic name, phone number, address, and selects a clinic type (e.g., general practice, dental, dermatology). Upon submission, the system creates the clinic, assigns the doctor as the clinic administrator, generates a unique 8-character invite code, and automatically creates a default location for the clinic. The doctor is then taken to the main dashboard with that clinic selected.

**Why this priority**: Without at least one clinic existing, no other features (appointments, patients, billing) can function. Clinic creation is the gateway to the entire application.

**Independent Test**: Can be fully tested by signing in as a new doctor, completing profile setup, filling in the clinic creation form, and verifying the clinic appears in the system with the doctor as admin and an invite code generated.

**Acceptance Scenarios**:

1. **Given** a doctor has completed profile setup and has no clinic assignment, **When** they choose "Create Clinic" and fill in valid clinic details, **Then** the clinic is created, the doctor is assigned as clinic_admin, a unique 8-character invite code is generated, a default location is created, and the doctor is navigated to the dashboard.
2. **Given** a doctor is on the Create Clinic form, **When** they submit with a missing required field (clinic name), **Then** the form shows an inline validation error and does not submit.
3. **Given** a doctor is on the Create Clinic form, **When** they submit with a missing phone number, **Then** the form shows an inline validation error for the phone field.

---

### User Story 2 - Join an Existing Clinic via Invite Code (Priority: P1)

A newly signed-up doctor who has completed profile setup but has no clinic association chooses "Join Clinic." They are presented with an input field for an invite code. After entering the code, the system validates it and displays the matching clinic name for confirmation. Upon confirming, the doctor is added to the clinic's staff with a default role of "doctor" and is navigated to the dashboard.

**Why this priority**: Joining a clinic is equally critical to creating one — many doctors will join an existing clinic rather than creating their own. Both paths must be available from day one.

**Independent Test**: Can be tested by creating a clinic (Story 1), copying its invite code, signing in as a different doctor, entering the invite code, and verifying the second doctor is added to the clinic's staff list.

**Acceptance Scenarios**:

1. **Given** a doctor is on the Join Clinic screen, **When** they enter a valid invite code, **Then** the system displays the matching clinic name for confirmation.
2. **Given** the clinic name is displayed, **When** the doctor confirms, **Then** they are added to the clinic's staff as a "doctor" and navigated to the dashboard.
3. **Given** a doctor is on the Join Clinic screen, **When** they enter an invalid or expired invite code, **Then** the system shows an error message indicating the code is not valid.
4. **Given** a doctor is already a member of the clinic, **When** they enter that clinic's invite code, **Then** the system informs them they are already a member.

---

### User Story 3 - Select a Clinic After Login (Priority: P2)

A doctor who belongs to multiple clinics signs in. After authentication, instead of going directly to the dashboard, the system presents a clinic selector screen showing all clinics the doctor is assigned to. The doctor selects which clinic they want to work in, and the selected clinic ID is stored in the app state for the duration of the session. All subsequent data fetches operate within the context of the selected clinic.

**Why this priority**: Multi-clinic support is essential for doctors who work across practices, but the core creation/join flow must work first.

**Independent Test**: Can be tested by joining a doctor to two clinics, signing in, verifying the selector appears with both clinics listed, selecting one, and verifying the dashboard loads with data scoped to the selected clinic.

**Acceptance Scenarios**:

1. **Given** a doctor belongs to multiple clinics, **When** they sign in, **Then** a clinic selector screen is displayed showing all their active clinic assignments.
2. **Given** a doctor is on the clinic selector screen, **When** they select a clinic, **Then** the selected clinic ID is stored in app state and the doctor is navigated to the dashboard.
3. **Given** a doctor belongs to only one clinic, **When** they sign in, **Then** the clinic selector is skipped and they are navigated directly to the dashboard with that clinic selected.
4. **Given** a doctor is on the clinic selector, **When** a clinic they belong to has been deactivated, **Then** that clinic is not shown in the selector.

---

### User Story 4 - Manage Clinic Settings (Priority: P3)

A clinic administrator navigates to clinic settings where they can view and edit the clinic's name, phone, address, and type. They can also regenerate the invite code (invalidating the previous one) if it has been compromised or needs refreshing.

**Why this priority**: Settings management is important but secondary to the core creation, joining, and selection flows.

**Independent Test**: Can be tested by signing in as a clinic admin, navigating to clinic settings, changing the clinic name, saving, and verifying the change persists. Testing invite code regeneration by regenerating and verifying the old code no longer works.

**Acceptance Scenarios**:

1. **Given** a clinic admin is on the clinic settings screen, **When** they update the clinic name and save, **Then** the clinic name is updated and the change is reflected across the app.
2. **Given** a clinic admin is on the clinic settings screen, **When** they regenerate the invite code, **Then** a new unique 8-character code is generated and the old code becomes invalid.
3. **Given** a non-admin staff member, **When** they navigate to clinic settings, **Then** the edit and management options are not available (read-only view or no access).

---

### User Story 5 - Manage Clinic Staff (Priority: P3)

A clinic administrator views the list of all staff members assigned to their clinic. They can change a staff member's role (e.g., from "doctor" to "receptionist") and deactivate staff members who are no longer working at the clinic.

**Why this priority**: Staff management supports ongoing clinic operations but is not required for initial setup.

**Independent Test**: Can be tested by signing in as clinic admin, viewing the staff list, changing a staff member's role, verifying the role change persists, then deactivating a member and verifying they no longer appear as active.

**Acceptance Scenarios**:

1. **Given** a clinic admin is on the staff list screen, **When** the page loads, **Then** all active staff members for that clinic are displayed with their names and roles.
2. **Given** a clinic admin is viewing the staff list, **When** they change a staff member's role, **Then** the role is updated and the change is reflected immediately.
3. **Given** a clinic admin is viewing the staff list, **When** they deactivate a staff member, **Then** the member is marked inactive and no longer appears in the active staff list.
4. **Given** a clinic admin is viewing their own entry in the staff list, **When** they attempt to deactivate themselves, **Then** the system prevents it and shows an appropriate message.

---

### Edge Cases

- What happens when a doctor creates a clinic but the network fails mid-request? The system should show an error and allow retry without creating duplicate clinics.
- What happens when two doctors try to join the same clinic simultaneously? Both should be added correctly without conflict.
- What happens when a clinic admin regenerates the invite code while another user is in the process of entering the old code? The old code becomes invalid and the joining user sees an error.
- What happens if all admins of a clinic are deactivated? The system prevents deactivation of the last active admin.
- What happens when a doctor who belongs to multiple clinics has all their assignments deactivated? They are shown the "Create Clinic" or "Join Clinic" screen.
- What happens when the generated invite code collides with an existing one? The system retries generation until a unique code is produced.

## Requirements

### Functional Requirements

- **FR-001**: System MUST present a "Create Clinic" or "Join Clinic" choice to any authenticated user who has completed profile setup but has no active clinic assignment.
- **FR-002**: System MUST provide a clinic creation form with fields: clinic name (required), clinic phone (required), clinic address (required), and clinic type (required, selectable from: general_practice, dental, dermatology, pediatrics, orthopedics, ophthalmology, cardiology, multi_specialty, other).
- **FR-003**: System MUST assign the creating user as clinic_admin upon successful clinic creation.
- **FR-004**: System MUST generate a unique 8-character alphanumeric invite code for each newly created clinic.
- **FR-005**: System MUST automatically create one default location when a clinic is created, using the clinic's address and phone.
- **FR-006**: System MUST allow a user to enter an invite code to join an existing clinic.
- **FR-007**: System MUST validate the invite code and display the matching clinic name for user confirmation before adding them to the clinic.
- **FR-008**: System MUST add the joining user to the clinic's staff with a default role of "doctor" upon confirmation.
- **FR-009**: System MUST support a user belonging to multiple clinics simultaneously.
- **FR-010**: System MUST present a clinic selector screen after login when a user belongs to more than one active clinic.
- **FR-011**: System MUST skip the clinic selector and proceed directly to the dashboard when a user belongs to exactly one active clinic.
- **FR-012**: System MUST store the selected clinic ID in app state and include it in context for all subsequent data operations.
- **FR-013**: System MUST allow a clinic admin to view and edit clinic details (name, phone, address, type).
- **FR-014**: System MUST allow a clinic admin to view the staff list for their clinic, showing names and roles.
- **FR-015**: System MUST allow a clinic admin to change the role of a staff member within their clinic.
- **FR-016**: System MUST allow a clinic admin to deactivate staff members, removing them from active status.
- **FR-017**: System MUST prevent deactivation of the last active clinic_admin of a clinic.
- **FR-018**: System MUST allow a clinic admin to regenerate the invite code, invalidating the previous code.
- **FR-019**: System MUST enforce data isolation so that users can only see clinics and staff data for clinics they belong to.
- **FR-020**: System MUST filter all domain data by the currently selected clinic ID.
- **FR-021**: System MUST prevent a user from joining a clinic they are already an active member of and show a descriptive message.
- **FR-022**: System MUST prevent a clinic admin from deactivating their own account.

### Key Entities

- **Clinic**: Represents a medical practice. Key attributes: name, phone, address, type, invite code, active status. A clinic may have multiple staff members and multiple locations.
- **Staff Assignment**: Represents the relationship between a user and a clinic. Key attributes: reference to user, reference to clinic, role (clinic_admin, doctor, receptionist, nurse, other), active status, join date.
- **Location**: Represents a physical location of a clinic. Key attributes: reference to clinic, name, address, phone, active status. A clinic has at least one location (auto-created on clinic creation).
- **Clinic Type**: Enumeration of supported clinic specializations: general_practice, dental, dermatology, pediatrics, orthopedics, ophthalmology, cardiology, multi_specialty, other.
- **Staff Role**: Enumeration of supported staff roles: clinic_admin, doctor, receptionist, nurse, other.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A new doctor can create a clinic and reach the dashboard in under 2 minutes from the post-profile-setup screen.
- **SC-002**: A doctor can join an existing clinic using an invite code in under 1 minute.
- **SC-003**: The clinic selector correctly appears for multi-clinic users and is skipped for single-clinic users 100% of the time.
- **SC-004**: Clinic admin can update clinic details and see the change reflected within 3 seconds.
- **SC-005**: Clinic admin can manage staff (view list, change roles, deactivate) without errors.
- **SC-006**: Data isolation ensures that a user never sees clinics or staff from clinics they do not belong to.
- **SC-007**: Regenerated invite codes invalidate the previous code, and the old code is rejected immediately.
- **SC-008**: All clinic-scoped data queries include the selected clinic ID, ensuring correct tenant isolation.

## Assumptions

- Users have completed the authentication and profile setup flows (003-auth) before the clinic setup flow is triggered.
- The profile entity from 003-auth includes a mechanism to determine whether a user has an active clinic assignment (via staff_clinic_assignments).
- A "location" is a future-extensibility concept; for this feature, only a single default location is auto-created per clinic. Full location management UI is out of scope.
- Internet connectivity is available for all clinic creation, joining, and management operations (offline support is out of scope).
- The invite code is a simple 8-character alphanumeric string. No expiry is applied to invite codes for this version.
- Staff role assignment beyond the default "doctor" role is managed manually by the clinic admin after joining.
- The clinic type list (general_practice, dental, dermatology, pediatrics, orthopedics, ophthalmology, cardiology, multi_specialty, other) is fixed and not user-configurable for this version.
- Row-Level Security on Supabase enforces that users only access clinics and staff data for clinics they belong to.
