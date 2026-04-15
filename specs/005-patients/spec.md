# Feature Specification: Patient Management

**Feature Branch**: `005-patients`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Patient registration, search, and profile management. Patients are the core entity referenced by scheduling, queue, EHR, billing, and messaging modules."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Register a New Patient (Priority: P1)

A clinic staff member (doctor, nurse, or receptionist) opens the patient list screen and taps "Add Patient." They fill out the registration form with the patient's personal details — name, date of birth, gender, phone number, and any optional fields (email, national ID, blood type, address, emergency contact, notes). On save, the system creates a patient record scoped to the current clinic and auto-generates a sequential patient number (e.g., P-0001). The staff member sees a confirmation and can view the newly created patient's detail screen.

**Why this priority**: Without patient registration, no downstream module (scheduling, queue, EHR, billing) can function. This is the foundational action for the entire clinic workflow.

**Independent Test**: Can be fully tested by opening the app, navigating to the patient list, tapping "Add Patient," filling the form, and saving. The new patient appears in the list with a generated patient number.

**Acceptance Scenarios**:

1. **Given** a logged-in staff member on the patient list screen, **When** they tap "Add Patient," **Then** the registration form opens with all required and optional fields.
2. **Given** the registration form is open, **When** the staff member fills in first name, last name, date of birth, and phone number and taps "Save," **Then** a new patient record is created with an auto-generated patient number (format P-NNNN), and the user is navigated to the patient detail screen.
3. **Given** the registration form is open, **When** the staff member leaves a required field empty and taps "Save," **Then** the form shows inline validation errors for the missing fields.
4. **Given** the registration form is open, **When** the staff member enters an invalid phone number or email, **Then** inline validation errors are displayed for those fields.
5. **Given** a patient is created in Clinic A, **When** a staff member of Clinic B views their patient list, **Then** the patient from Clinic A is not visible.

---

### User Story 2 - View and Edit Patient Profile (Priority: P1)

A staff member selects a patient from the list to view their full profile. The detail screen shows all patient information organized clearly. The staff member can tap "Edit" to modify any field — the same form used for registration opens, pre-filled with existing data. On save, the patient record is updated.

**Why this priority**: Viewing and editing patient information is a core daily workflow. Staff must be able to correct data entry errors and update patient details (e.g., new phone number, address change).

**Independent Test**: Can be tested by creating a patient, navigating to their detail screen, verifying all fields display correctly, tapping "Edit," changing a field, saving, and confirming the update persists.

**Acceptance Scenarios**:

1. **Given** a patient exists in the system, **When** a staff member taps the patient in the list, **Then** the patient detail screen displays all stored information (patient number, name, DOB, gender, phone, email, national ID, blood type, address, emergency contact, notes).
2. **Given** the patient detail screen is open, **When** the staff member taps "Edit," **Then** the edit form opens pre-filled with the patient's current data.
3. **Given** the edit form is open with modified data, **When** the staff member taps "Save," **Then** the patient record is updated and the detail screen reflects the changes.
4. **Given** the patient detail screen is open, **When** the staff member views the tabs/sections, **Then** the "Info" tab is functional and "Appointments," "Medical History," and "Billing" tabs show "Coming Soon" placeholders.

---

### User Story 3 - Browse Patient List with Pagination (Priority: P1)

A staff member opens the patient list screen and sees a paginated list of patients for their current clinic. Each list item shows the patient number, full name, phone number, and age (computed from date of birth). As the staff member scrolls to the bottom, more patients load automatically.

**Why this priority**: Staff members need to quickly browse and find patients. Pagination ensures performance with large patient volumes.

**Independent Test**: Can be tested by creating multiple patients, opening the patient list, verifying patient info is displayed correctly, and scrolling to trigger additional page loads.

**Acceptance Scenarios**:

1. **Given** a clinic with patients, **When** a staff member opens the patient list, **Then** the first 20 patients are displayed, each showing patient number, full name, phone, and age.
2. **Given** the first page of patients is loaded, **When** the staff member scrolls to the bottom, **Then** the next 20 patients load automatically.
3. **Given** fewer than 20 patients exist, **When** the staff member opens the patient list, **Then** all patients are displayed without a loading indicator for more.
4. **Given** the patient list is open, **When** the staff member types in the search bar, **Then** results are filtered by matching name, phone, national ID, or patient number.

---

### User Story 4 - Search Patients Globally (Priority: P2)

A staff member taps the search icon in the navigation bar to perform a global patient search. As they type, results appear in real time (debounced at 300ms). Each result shows the patient number, name, and phone. Tapping a result navigates directly to the patient's detail screen.

**Why this priority**: Quick patient lookup from anywhere in the app improves workflow efficiency. However, the in-list search from US3 covers the most common search scenario, making this a secondary priority.

**Independent Test**: Can be tested by tapping the search icon from any screen, typing a patient's name or phone, verifying results appear with debounced timing, and tapping a result to navigate to the detail screen.

**Acceptance Scenarios**:

1. **Given** the search interface is open, **When** the staff member types at least 2 characters, **Then** matching patients appear within 300ms of the last keystroke.
2. **Given** search results are displayed, **When** the staff member taps a result, **Then** the app navigates to that patient's detail screen.
3. **Given** the search interface is open, **When** the staff member types a query with no matches, **Then** a "No patients found" message is displayed.
4. **Given** the search interface is open, **When** the staff member searches, **Then** only patients from their current clinic appear in results.

---

### User Story 5 - Deactivate a Patient (Priority: P3)

A staff member opens a patient's detail screen and chooses to deactivate the patient record. The system marks the patient as inactive. Inactive patients no longer appear in the default patient list or search results. This is a soft delete — the record is preserved for historical reference.

**Why this priority**: Deactivation is an administrative housekeeping function. It prevents clutter in the active patient list but is not part of the core daily workflow.

**Independent Test**: Can be tested by creating a patient, navigating to their detail screen, deactivating them, and confirming they no longer appear in the patient list or search results.

**Acceptance Scenarios**:

1. **Given** a patient detail screen is open, **When** the staff member taps "Deactivate" and confirms the action, **Then** the patient record is marked as inactive.
2. **Given** a patient has been deactivated, **When** a staff member views the patient list, **Then** the deactivated patient does not appear.
3. **Given** a patient has been deactivated, **When** a staff member searches for the patient by name, **Then** the deactivated patient does not appear in results.

---

### Edge Cases

- What happens when a staff member tries to register a patient with a phone number that already exists in the same clinic? The system allows it — duplicate phone numbers are permitted since family members may share a phone.
- What happens when the patient list is empty (new clinic, no patients yet)? An empty state message is displayed: "No patients yet. Tap + to register your first patient."
- What happens when the network connection is lost during patient creation? The system shows an error message and preserves the form data so the staff member can retry without re-entering information.
- What happens when a staff member searches with special characters? The search handles special characters gracefully without errors.
- What happens when the date of birth is in the future? The form validation rejects future dates.
- What happens when the patient_number sequence has gaps (e.g., from previously deleted records)? The auto-generation continues from the highest existing number, not from the count of active records.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow clinic staff to register a new patient by providing first name, last name, date of birth, and phone number as required fields.
- **FR-002**: System MUST auto-generate a unique, sequential patient number per clinic on patient creation (format: P-NNNN, e.g., P-0001, P-0002).
- **FR-003**: System MUST scope all patient records to the current clinic. Staff from one clinic MUST NOT see or modify patients belonging to another clinic.
- **FR-004**: System MUST allow staff to view a patient's complete profile, including all registered fields.
- **FR-005**: System MUST allow staff to edit any field of an existing patient record.
- **FR-006**: System MUST validate phone numbers and email addresses using established validation rules before saving.
- **FR-007**: System MUST validate that date of birth is not in the future.
- **FR-008**: System MUST display a paginated list of patients (20 per page) for the current clinic, with automatic loading of additional pages on scroll.
- **FR-009**: System MUST support searching patients by name, phone number, national ID, or patient number within the current clinic.
- **FR-010**: System MUST provide a global search accessible from the navigation bar with real-time results (debounced at 300ms).
- **FR-011**: System MUST allow staff to deactivate a patient record (soft delete). Deactivated patients MUST NOT appear in the default patient list or search results.
- **FR-012**: System MUST display computed age (from date of birth) in the patient list items.
- **FR-013**: System MUST display placeholder tabs ("Coming Soon") for Appointments, Medical History, and Billing sections on the patient detail screen.
- **FR-014**: System MUST preserve form data when a network error occurs during save, allowing the user to retry without re-entering information.
- **FR-015**: The patient registration and edit forms MUST support the following optional fields: email, national ID, blood type (selectable from A+, A−, B+, B−, AB+, AB−, O+, O−), address, emergency contact name, emergency contact phone, and notes.
- **FR-016**: System MUST enforce row-level security so that only staff members assigned to a clinic can access that clinic's patient records.

### Key Entities

- **Patient**: The central entity representing an individual receiving care at a clinic. Key attributes: unique identifier, clinic association, auto-generated patient number, personal information (name, date of birth, gender, phone, email), identification (national ID), medical context (blood type), contact details (address, emergency contact), administrative notes, and active/inactive status.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Staff can register a new patient in under 2 minutes, including filling all required fields and saving.
- **SC-002**: Patient search returns matching results within 1 second of the user stopping typing.
- **SC-003**: The patient list loads the first page of 20 patients within 2 seconds.
- **SC-004**: 100% of patient records are scoped to their clinic — no cross-clinic data leakage.
- **SC-005**: Staff can update any patient field and see the change reflected immediately after saving.
- **SC-006**: Deactivated patients are completely hidden from the default patient list and search results.
- **SC-007**: The system supports clinics with up to 50,000 patient records without degradation in list or search performance.

## Assumptions

- Users have an active internet connection when performing patient operations (offline mode is out of scope for this feature).
- The clinic tenancy system (004-clinic-tenancy) is already implemented and provides the current clinic context (selected clinic ID).
- Authentication (003-auth) is already implemented and provides the current user context.
- Only staff members assigned to the current clinic can access the patient management screens — the clinic tenancy module enforces this at the routing level.
- The patient_number sequence (P-NNNN) is sufficient for clinics with up to 9,999 patients. If a clinic approaches this limit, the format can be extended in a future iteration.
- Duplicate phone numbers within a clinic are allowed, as family members may share a phone number.
- Patient data is not encrypted at the field level in this version; row-level security is the primary access control mechanism.
- The "Coming Soon" placeholder tabs (Appointments, Medical History, Billing) are non-functional stubs that will be implemented in future features.
