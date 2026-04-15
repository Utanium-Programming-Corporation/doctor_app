# Clinic Management App — Full Implementation Roadmap

> **Stack**: Flutter + Supabase | **Architecture**: Clean (Domain / Data / Presentation)  
> **Auth**: Google & Apple Sign-In only | **State**: Cubit (default) / Bloc (realtime only)  
> **Focus**: Functionality first — UI polish deferred to a later pass  

---

## How to Use This Document

Each phase follows the speckit workflow:

1. **`speckit.specify`** — generate the feature spec from a prompt  
2. **`speckit.plan`** — generate the implementation plan from the spec  
3. **`speckit.tasks`** — generate ordered tasks from the plan  
4. **`speckit.implement`** — execute all tasks  

Phase 0 (Constitution) runs once. Phases 1–12 repeat the specify → plan → tasks → implement cycle.

---

## Conventions to Enforce in Every Prompt

Include these in **every** `speckit.specify` prompt so they propagate into plans and tasks:

```
CONVENTIONS (include in every feature):
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement one of the base interfaces (UseCaseWithParams, UseCaseWithoutParams, StreamUseCaseWithParams, StreamUseCaseWithoutParams) from core/usecase/usecase.dart.
- All use cases return FutureResult<T> (typedef for Future<Either<Failure, T>>) or StreamResult<T>.
- Repositories: abstract interface in domain, implementation in data.
- Data models use freezed + json_serializable; entities use Equatable.
- DI: GetIt with per-feature initX() function registered in injection_container.dart.
- Cubit by default; Bloc only for realtime streams (justify in plan).
- All text input fields MUST use the unified AppFormField widget via buildTextField / buildTextFieldClearable helpers.
- All form validation MUST use AppValidators composable validator pattern.
- Every presentation-layer UI file MUST be ≤ 100 lines. If a page exceeds 100 lines, split into private widget files in a widgets/ subfolder. Exception: cubit/bloc/state files have no line limit.
- Supabase RLS on every table. Every domain table includes clinic_id.
- No PHI in logs. Signed URLs for patient documents.
- Focus on functionality — minimal clean UI, no polish. We will update UI in a later pass.
- Auth is Google/Apple Sign-In only (no email/password, no phone OTP).
```

---

## Phase 0 — Constitution Update

> **Goal**: Update the existing constitution to reflect Google/Apple-only auth, the improved UseCase interfaces, the 100-line UI file rule, and the unified AppFormField convention.

### Command

```
speckit.constitution
```

### Prompt

```
Update the existing constitution with these changes:

1. AUTH CHANGE: Replace "email/password + phone OTP" with "Google Sign-In and Apple Sign-In only" via Supabase Auth. Remove all references to email/password and phone OTP auth. Native sign-in SDKs on mobile, Supabase OAuth on web fallback.

2. USE CASE INTERFACES: The base UseCase class must be replaced with four abstract interface classes:
   - UseCaseWithParams<T, Params> → FutureResult<T> call(Params params)
   - UseCaseWithoutParams<T> → FutureResult<T> call()
   - StreamUseCaseWithParams<T, Params> → StreamResult<T> call(Params params)
   - StreamUseCaseWithoutParams<T> → StreamResult<T> call()
   Where FutureResult<T> = Future<Either<Failure, T>> and StreamResult<T> = Stream<Either<Failure, T>>.
   Every use case MUST implement exactly one of these interfaces. NoParams sentinel class is eliminated.

3. UI FILE SIZE RULE (NON-NEGOTIABLE): Every presentation-layer UI file (pages, widgets) MUST NOT exceed 100 lines of code. If a page or widget exceeds 100 lines, it MUST be decomposed into smaller private widgets in a local widgets/ subfolder. The only exceptions are cubit/bloc files and state files which have no line limit.

4. UNIFIED TEXT INPUT: All text input fields across the entire app MUST use the AppFormField widget through the buildTextField() and buildTextFieldClearable() static helpers. Direct use of TextField or TextFormField outside of AppFormField is prohibited. All validation MUST use composable validators from AppValidators.

5. DATA MODELS: All data models MUST use freezed + json_serializable for immutable, boilerplate-free serialization. Add freezed and json_serializable to the technology stack.

6. Keep all other existing principles unchanged.
```

---

## Phase 1 — Core Foundation (COMPLETED)

> **Branch**: `001-core-foundation` — Already implemented.  
> **What exists**: GoRouter with auth guards, GetIt DI, global error handling, Failure/Exception classes, base UseCase, Supabase client init, NetworkInfo, app theme (Figma tokens), app_logger.

### Post-Phase 1 Cleanup Task

Before proceeding to Phase 2, we need to update the existing UseCase base to the new interface pattern. Run:

```
speckit.specify
```

**Prompt**:

```
Feature: Core UseCase Interface Upgrade (002-usecase-upgrade)

Refactor the existing core/usecase/usecase.dart to replace the single abstract UseCase<T, Params> class with four abstract interface classes following Dart 3 best practices:

1. Create type aliases:
   - typedef FutureResult<T> = Future<Either<Failure, T>>
   - typedef StreamResult<T> = Stream<Either<Failure, T>>

2. Create four abstract interface classes:
   - UseCaseWithParams<T, Params> with FutureResult<T> call(Params params)
   - UseCaseWithoutParams<T> with FutureResult<T> call()
   - StreamUseCaseWithParams<T, Params> with StreamResult<T> call(Params params)
   - StreamUseCaseWithoutParams<T> with StreamResult<T> call()

3. Remove the NoParams class — use cases without parameters implement UseCaseWithoutParams instead.

4. Add freezed and json_serializable to pubspec.yaml dependencies and build_runner to dev_dependencies.

5. Update any existing code that references the old UseCase class or NoParams.

This is a core-only change. No feature code exists yet to update.

CONVENTIONS (include in every feature):
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- Focus on functionality — minimal clean UI, no polish.
```

Then run: `speckit.plan` → `speckit.tasks` → `speckit.implement`

---

## Phase 2 — Authentication & Onboarding

> **Branch**: `003-auth`  
> **Dependencies**: Phase 1 (core), Phase 0 (constitution update)  
> **Module**: Auth & Tenancy (Module A)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Authentication & User Onboarding (003-auth)

Implement Google Sign-In and Apple Sign-In authentication using Supabase Auth. This is the ONLY authentication method — no email/password, no phone OTP.

REQUIREMENTS:

1. SIGN IN FLOW:
   - Landing/welcome screen with "Sign in with Google" and "Sign in with Apple" buttons.
   - On successful sign-in, check if user has a profile in the `profiles` table.
   - If profile exists → navigate to home dashboard.
   - If no profile → navigate to profile setup screen (onboarding).
   - On sign-in failure → show error message on the same screen.

2. PROFILE SETUP (onboarding for first-time users):
   - Screen collects: full_name, phone_number (optional), preferred_language (English/Arabic).
   - Creates a row in `profiles` table linked to auth.users.id.
   - Default role is 'doctor' (since this is the doctors app).
   - After profile creation → navigate to home dashboard.

3. SIGN OUT:
   - Available from settings or profile menu.
   - Clears Supabase session.
   - Redirects to landing/welcome screen.

4. AUTH STATE MANAGEMENT:
   - AuthCubit listens to Supabase auth state changes (onAuthStateChange stream).
   - AuthCubit exposes: AuthInitial, AuthLoading, Authenticated(user, profile), Unauthenticated, AuthError(message).
   - GoRouter's refreshListenable should react to AuthCubit state (replace the current AuthStateNotifier with AuthCubit or adapt it).
   - On app launch, check existing session → auto-login if valid.

5. SUPABASE SETUP:
   - profiles table: id (uuid, FK to auth.users), full_name (text), phone_number (text nullable), role (enum: super_admin, clinic_admin, doctor, nurse, receptionist, pharmacist), preferred_language (text, default 'en'), avatar_url (text nullable), created_at, updated_at.
   - RLS: users can only read/update their own profile. Admins can read all profiles in their clinic.
   - Include SQL migration script for the profiles table and RLS policies.

6. PACKAGES TO ADD:
   - google_sign_in
   - sign_in_with_apple

DOMAIN LAYER:
- Entities: UserProfile (Equatable)
- Repository interface: AuthRepository (signInWithGoogle, signInWithApple, signOut, getCurrentUser, getProfile, createProfile, onAuthStateChange stream)
- Use cases: SignInWithGoogle (UseCaseWithoutParams), SignInWithApple (UseCaseWithoutParams), SignOut (UseCaseWithoutParams), GetCurrentUser (UseCaseWithoutParams), GetUserProfile (UseCaseWithParams<UserProfile, String>), CreateUserProfile (UseCaseWithParams<UserProfile, CreateProfileParams>), WatchAuthState (StreamUseCaseWithoutParams)

DATA LAYER:
- AuthRemoteDataSource: wraps Supabase auth + profiles table calls
- AuthRepositoryImpl: catches exceptions, maps to Failure, returns Either
- UserProfileModel: freezed model extending UserProfile entity with fromJson/toJson

PRESENTATION LAYER:
- AuthCubit + AuthState
- WelcomePage (sign-in buttons only — keep it under 100 lines)
- ProfileSetupPage (onboarding form using AppFormField via buildTextField helpers)
- All form validation uses AppValidators

FILE STRUCTURE:
lib/features/auth/
  domain/
    entities/user_profile.dart
    repositories/auth_repository.dart
    usecases/
      sign_in_with_google.dart
      sign_in_with_apple.dart
      sign_out.dart
      get_current_user.dart
      get_user_profile.dart
      create_user_profile.dart
      watch_auth_state.dart
  data/
    datasources/auth_remote_data_source.dart
    models/user_profile_model.dart
    repositories/auth_repository_impl.dart
  presentation/
    cubit/auth_cubit.dart
    cubit/auth_state.dart
    pages/welcome_page.dart
    pages/profile_setup_page.dart
    widgets/ (if any page exceeds 100 lines)

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement one of the base interfaces from core/usecase/usecase.dart.
- Repositories: abstract interface in domain, implementation in data.
- Data models use freezed + json_serializable.
- DI: GetIt with initAuth() function.
- Cubit for auth state.
- All text fields use AppFormField via buildTextField/buildTextFieldClearable.
- All validation uses AppValidators.
- Every UI file ≤ 100 lines. Split into widgets/ subfolder if needed.
- RLS on profiles table. No PHI in logs.
- Focus on functionality — minimal clean UI, no polish.
```

### Step 2: Plan

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 003-auth based on the spec. Include:
- Supabase SQL migration for profiles table with RLS policies
- Data model diagram
- Dependency registration order in initAuth()
- Integration point with existing GoRouter auth redirect
- How AuthCubit replaces or wraps the existing AuthStateNotifier
Focus on functionality, minimal UI.
```

### Step 3: Tasks

```
speckit.tasks
```

(No additional prompt needed — it reads the spec and plan automatically.)

### Step 4: Implement

```
speckit.implement
```

(No additional prompt needed — it executes the generated tasks.)

---

## Phase 3 — Clinic & Tenant Setup

> **Branch**: `004-clinic-tenancy`  
> **Dependencies**: Phase 2 (auth — user must be logged in)  
> **Module**: Auth & Tenancy (Module A continued)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Clinic & Multi-Tenant Setup (004-clinic-tenancy)

Implement clinic creation, clinic selection, and multi-tenant data isolation. After a doctor signs in for the first time and creates their profile, they must either create a new clinic or join an existing one via invite code.

REQUIREMENTS:

1. CLINIC CREATION FLOW:
   - After profile setup, if user has no clinic_id → show "Create Clinic" or "Join Clinic" screen.
   - Create Clinic form: clinic_name, clinic_phone, clinic_address, clinic_type (general_practice, dental, dermatology, pediatrics, orthopedics, ophthalmology, cardiology, multi_specialty, other).
   - On creation, user becomes clinic_admin of that clinic.
   - Generate a unique 8-character invite code for the clinic.

2. JOIN CLINIC FLOW:
   - User enters an invite code.
   - System validates the code and shows the clinic name for confirmation.
   - On confirmation, user is added to staff_clinic_assignments with role assigned by the clinic admin (default: doctor).

3. MULTI-CLINIC SUPPORT:
   - A user can belong to multiple clinics (via staff_clinic_assignments).
   - If user has multiple clinics → after login, show clinic selector screen.
   - If user has one clinic → skip selector, go to dashboard.
   - Current clinic_id is stored in app state and included in all subsequent API calls.

4. CLINIC SETTINGS:
   - Clinic admin can view/edit clinic details.
   - Clinic admin can view staff list and change roles.
   - Clinic admin can regenerate invite code.
   - Clinic admin can deactivate staff members.

5. SUPABASE TABLES:
   - clinics: id (uuid), name (text), phone (text), address (text), type (enum), invite_code (text unique), is_active (bool), created_at, updated_at.
   - staff_clinic_assignments: id (uuid), user_id (FK profiles), clinic_id (FK clinics), role (enum), is_active (bool), joined_at, updated_at.
   - RLS: users see only clinics they belong to. Staff data filtered by clinic_id. Clinic admin can manage staff in their clinic.

6. LOCATIONS (future-ready):
   - locations table: id, clinic_id, name, address, phone, is_active. A clinic can have multiple locations.
   - For now, auto-create one default location when a clinic is created.

DOMAIN LAYER:
- Entities: Clinic, StaffAssignment, Location
- Repository: ClinicRepository (createClinic, joinClinic, getMyClinicAssignments, getClinicStaff, updateClinic, updateStaffRole, deactivateStaff, regenerateInviteCode, getClinicById)
- Use cases: CreateClinic, JoinClinicByCode, GetMyClinicAssignments, GetClinicStaff, UpdateClinic, UpdateStaffRole, DeactivateStaff, RegenerateInviteCode

DATA LAYER:
- ClinicRemoteDataSource
- Models: ClinicModel, StaffAssignmentModel, LocationModel (all freezed)
- ClinicRepositoryImpl

PRESENTATION LAYER:
- ClinicCubit (manages current clinic selection + clinic CRUD)
- CreateClinicPage (form using AppFormField)
- JoinClinicPage (invite code input using AppFormField)
- ClinicSelectorPage (shows list of user's clinics)
- ClinicSettingsPage
- StaffListPage
- widgets/ subfolder for any components if pages exceed 100 lines

APP STATE:
- Store selected clinic_id in a ClinicCubit that is accessible app-wide via BlocProvider at the root.
- All subsequent data fetches include clinic_id from this cubit.

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initClinic() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- RLS on all tables with clinic_id filtering.
- Focus on functionality — minimal clean UI.
```

### Step 2: Plan

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 004-clinic-tenancy. Include:
- SQL migrations for clinics, staff_clinic_assignments, locations tables with RLS
- How clinic_id flows through the app (ClinicCubit → repositories → Supabase queries)
- Integration with existing auth flow (post-login routing logic)
- Invite code generation and validation approach
```

### Step 3: Tasks → Step 4: Implement

```
speckit.tasks
speckit.implement
```

---

## Phase 4 — Patient Management

> **Branch**: `005-patients`  
> **Dependencies**: Phase 3 (clinic_id required for all patient data)  
> **Module**: Core data — feeds into Scheduling, Queue, EHR, Messaging, Billing

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Patient Management (005-patients)

Implement patient registration, search, and profile management. Patients are the core entity referenced by scheduling, queue, EHR, billing, and messaging modules.

REQUIREMENTS:

1. PATIENT REGISTRATION:
   - Form fields: first_name (required), last_name (required), date_of_birth (required, date picker), gender (male/female/other), phone_number (required, validated with AppValidators.phoneValid), email (optional, validated with AppValidators.emailValid), national_id (optional), blood_type (optional dropdown: A+, A-, B+, B-, AB+, AB-, O+, O-), address (optional multiline), emergency_contact_name (optional), emergency_contact_phone (optional), notes (optional multiline).
   - On save → creates patient record scoped to current clinic_id.
   - Auto-generates a patient_number (sequential per clinic, e.g., P-0001).

2. PATIENT LIST:
   - Searchable list of patients for the current clinic.
   - Search by name, phone, national_id, or patient_number.
   - Paginated (20 per page, load more on scroll).
   - Each list item shows: patient_number, full name, phone, age (computed from DOB).

3. PATIENT DETAIL SCREEN:
   - Shows all patient info.
   - Edit button → opens edit form (same as registration form, pre-filled).
   - Tabs or sections for: Info, Appointments (future), Medical History (future), Billing (future). For now, only Info tab is functional — others show "Coming Soon" placeholder.

4. PATIENT SEARCH (global):
   - Accessible from a top-level search icon in the nav bar.
   - Real-time search as user types (debounced 300ms).
   - Results show patient_number, name, phone.
   - Tapping a result navigates to Patient Detail.

5. SUPABASE TABLE:
   - patients: id (uuid), clinic_id (FK), patient_number (text, unique per clinic), first_name, last_name, date_of_birth (date), gender (enum), phone_number, email, national_id, blood_type, address, emergency_contact_name, emergency_contact_phone, notes, is_active (bool), created_at, updated_at.
   - RLS: only users in the same clinic can read/write patients for that clinic.
   - Index on (clinic_id, last_name, first_name) and (clinic_id, phone_number) for search performance.
   - Postgres function to auto-generate patient_number on insert.

DOMAIN LAYER:
- Entities: Patient (Equatable)
- Repository: PatientRepository (createPatient, updatePatient, getPatientById, searchPatients, getPatientsList with pagination, deactivatePatient)
- Use cases: CreatePatient, UpdatePatient, GetPatientById, SearchPatients, GetPatientsList, DeactivatePatient

DATA LAYER:
- PatientRemoteDataSource
- PatientModel (freezed + json_serializable)
- PatientRepositoryImpl

PRESENTATION LAYER:
- PatientListCubit (handles list + pagination + search)
- PatientDetailCubit (handles single patient CRUD)
- PatientListPage
- PatientDetailPage
- PatientFormPage (used for both create and edit)
- PatientSearchDelegate or SearchPage
- widgets/ subfolder as needed to keep files ≤ 100 lines

ROUTES:
- /patients → PatientListPage
- /patients/new → PatientFormPage (create mode)
- /patients/:id → PatientDetailPage
- /patients/:id/edit → PatientFormPage (edit mode)

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initPatient() function.
- All text fields use AppFormField via buildTextField/buildTextFieldClearable.
- All validation uses AppValidators (add new validators as needed: requiredDate, nationalIdFormat, etc.).
- Every UI file ≤ 100 lines.
- RLS with clinic_id filtering.
- Focus on functionality — minimal clean UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 005-patients. Include:
- SQL migration with RLS, indexes, and patient_number auto-generation function
- Pagination strategy (cursor-based vs offset)
- Search implementation (Supabase text search or ilike)
- Route registration in GoRouter
- Integration with ClinicCubit for clinic_id
```

```
speckit.tasks
speckit.implement
```

---

## Phase 5 — Scheduling & Appointments

> **Branch**: `006-scheduling`  
> **Dependencies**: Phase 4 (patients), Phase 3 (clinic, staff)  
> **Module**: Scheduling & Calendar (Module B)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Scheduling & Appointments (006-scheduling)

Implement appointment booking, calendar views, and provider availability management. This is the core scheduling module.

REQUIREMENTS:

1. APPOINTMENT TYPES:
   - Clinic admin can create appointment types: name, duration_minutes (15/30/45/60/90/120), color_hex, description, is_active.
   - Examples: "General Consultation" (30 min), "Follow-Up" (15 min), "Procedure" (60 min).

2. PROVIDER AVAILABILITY:
   - Each doctor/provider sets their weekly availability: day_of_week, start_time, end_time, location_id.
   - Example: Dr. Ahmed is available Mon-Wed 9:00-17:00, Thu 9:00-13:00.
   - Availability can have break slots (e.g., 13:00-14:00 lunch).
   - Admin or provider can set time-off / blocked dates.

3. APPOINTMENT BOOKING:
   - Receptionist or doctor selects: patient (search/select), provider, appointment_type, date, time_slot.
   - System shows available time slots based on provider availability minus existing appointments.
   - Double-booking prevention: Postgres EXCLUDE constraint using tstzrange on (provider_id, time_range) with gist index.
   - Appointment fields: id, clinic_id, patient_id, provider_id (FK staff), appointment_type_id, location_id, start_time (timestamptz), end_time (timestamptz), status (scheduled/confirmed/checked_in/in_progress/completed/cancelled/no_show), notes, created_by, created_at, updated_at.

4. APPOINTMENT VIEWS:
   - Daily view: list of appointments for a selected provider and date, ordered by time.
   - Doctor's "My Day" view: today's appointments for the logged-in doctor.
   - Simple list view (not full calendar widget yet — calendar UI will come in a later UI pass).

5. APPOINTMENT ACTIONS:
   - Cancel appointment (with optional reason). Status → cancelled.
   - Reschedule appointment → pick new date/time (validates availability).
   - Mark as no-show. Status → no_show.
   - Check-in (transition to checked_in — ties into queue module later).
   - Complete (transition to completed).

6. STATUS WORKFLOW:
   scheduled → confirmed → checked_in → in_progress → completed
   scheduled → cancelled
   scheduled → no_show
   Any status can go to cancelled except completed.

7. SUPABASE TABLES:
   - appointment_types: id, clinic_id, name, duration_minutes, color_hex, description, is_active, created_at.
   - provider_availability: id, clinic_id, provider_id (FK staff), day_of_week (0-6), start_time (time), end_time (time), location_id, is_active.
   - appointments: id, clinic_id, patient_id, provider_id, appointment_type_id, location_id, start_time, end_time, status, cancel_reason, notes, created_by, created_at, updated_at.
   - RLS: scoped to clinic_id. Doctors see only their own appointments. Admins/receptionists see all for the clinic.
   - EXCLUDE constraint on appointments (provider_id, tstzrange(start_time, end_time)) to prevent double-booking.
   - Indexes on (clinic_id, provider_id, start_time) for fast queries.

DOMAIN LAYER:
- Entities: Appointment, AppointmentType, ProviderAvailability, TimeSlot
- Repositories: AppointmentRepository, AvailabilityRepository
- Use cases: CreateAppointment, CancelAppointment, RescheduleAppointment, GetAppointmentsForDate, GetMyAppointmentsToday, GetAvailableSlots, UpdateAppointmentStatus, CreateAppointmentType, GetAppointmentTypes, SetProviderAvailability, GetProviderAvailability

DATA LAYER:
- AppointmentRemoteDataSource, AvailabilityRemoteDataSource
- Models (freezed): AppointmentModel, AppointmentTypeModel, ProviderAvailabilityModel
- AppointmentRepositoryImpl, AvailabilityRepositoryImpl

PRESENTATION LAYER:
- AppointmentListCubit (daily view, filters by provider/date)
- MyDayCubit (today's appointments for logged-in doctor)
- BookAppointmentCubit (booking flow state)
- AvailabilityCubit (manage provider schedule)
- Pages: AppointmentListPage, MyDayPage, BookAppointmentPage (multi-step: select patient → select type → select slot → confirm), ManageAvailabilityPage, AppointmentDetailPage
- widgets/ subfolder as needed

ROUTES:
- /appointments → AppointmentListPage (with date/provider filter)
- /appointments/book → BookAppointmentPage
- /appointments/:id → AppointmentDetailPage
- /my-day → MyDayPage (doctor's today view)
- /availability → ManageAvailabilityPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initScheduling() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- RLS with clinic_id filtering.
- Focus on functionality — minimal UI. No drag-and-drop calendar yet.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 006-scheduling. Include:
- Full SQL migration: tables, EXCLUDE constraint for double-booking prevention, indexes, RLS policies
- Available slot computation algorithm (provider availability minus booked appointments for a given date)
- Appointment status state machine and validation rules
- Multi-step booking flow architecture
- Route registration
- How this integrates with patient search from 005-patients
```

```
speckit.tasks
speckit.implement
```

---

## Phase 6 — Queue & Check-In

> **Branch**: `007-queue`  
> **Dependencies**: Phase 5 (appointments), Phase 4 (patients)  
> **Module**: Waiting Room, Queue & Triage (Module C)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Queue & Check-In System (007-queue)

Implement a digital queue system for the clinic waiting room. Patients check in, get a queue token, and providers call the next patient.

REQUIREMENTS:

1. CHECK-IN:
   - When a patient with a scheduled appointment arrives, receptionist checks them in.
   - This creates a queue_token with auto-incremented daily number (e.g., Q-001, Q-002...).
   - Appointment status transitions: scheduled/confirmed → checked_in.
   - Walk-in patients can also be added to the queue without a prior appointment (creates appointment on the fly).

2. QUEUE TOKEN:
   - Fields: id, clinic_id, location_id, token_number (auto per clinic per day), patient_id, appointment_id (nullable for walk-ins), provider_id, status (waiting/called/in_progress/completed/no_show/skipped), priority (normal/urgent — default normal), called_at, started_at, completed_at, created_at.
   - Token number resets daily per clinic.

3. QUEUE VIEWS:
   - Receptionist view: full queue list with actions (call next, skip, mark no-show).
   - Doctor view: "My Queue" — only tokens assigned to them, with "Call Next" and "Start Consultation" buttons.
   - Waiting room display (future): show called tokens on a large screen — placeholder route for now.

4. QUEUE ACTIONS:
   - Call next: picks highest-priority waiting token for the provider, sets status → called.
   - Start consultation: status → in_progress. (Ties into EHR encounter creation later.)
   - Complete: status → completed.
   - Skip: status → skipped (goes back to end of queue with lower priority).
   - No-show: status → no_show (3 minutes after called with no response — manual for now).

5. TRIAGE (basic):
   - Optional quick vitals entry on check-in: blood_pressure, heart_rate, temperature, weight, spo2, chief_complaint (text).
   - Stored in triage_assessments table linked to queue_token_id.
   - Displayed on the doctor's queue view next to each patient.

6. REALTIME:
   - Use Supabase Realtime to subscribe to queue_tokens changes for the current clinic.
   - Queue list updates live without manual refresh.
   - Use Bloc (not Cubit) for the queue feature because of the realtime event stream. Document the justification.

7. SUPABASE TABLES:
   - queue_tokens: (fields as described above). RLS by clinic_id.
   - triage_assessments: id, queue_token_id, clinic_id, blood_pressure_systolic, blood_pressure_diastolic, heart_rate, temperature, weight, spo2, chief_complaint, recorded_by, created_at.
   - Postgres function to auto-increment token_number per clinic per day.
   - RLS on both tables.

DOMAIN LAYER:
- Entities: QueueToken, TriageAssessment
- Repositories: QueueRepository, TriageRepository
- Use cases: CheckInPatient, CallNextPatient, StartConsultation, CompleteQueueToken, SkipQueueToken, MarkNoShow, GetQueueForClinic (stream), GetMyQueue (stream), RecordTriage, GetTriageForToken

DATA LAYER:
- QueueRemoteDataSource, TriageRemoteDataSource
- Models (freezed): QueueTokenModel, TriageAssessmentModel
- QueueRepositoryImpl, TriageRepositoryImpl

PRESENTATION LAYER:
- QueueBloc + QueueEvent + QueueState (Bloc justified: Supabase Realtime stream + user actions)
- MyQueueBloc (doctor's personal queue, also realtime)
- TriageCubit (simple form submission)
- Pages: QueueListPage (receptionist), MyQueuePage (doctor), CheckInPage, TriageFormPage
- widgets/ as needed

ROUTES:
- /queue → QueueListPage
- /queue/check-in → CheckInPage (select patient or walk-in)
- /queue/check-in/:appointmentId → CheckInPage (pre-filled from appointment)
- /my-queue → MyQueuePage
- /queue/:tokenId/triage → TriageFormPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Stream use cases for realtime (StreamUseCaseWithParams/WithoutParams).
- Data models use freezed + json_serializable.
- DI: GetIt with initQueue() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- Bloc for realtime queue management (justified: Supabase Realtime stream).
- RLS with clinic_id filtering. No PHI in logs.
- Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 007-queue. Include:
- SQL migrations with token auto-increment function, RLS
- Supabase Realtime subscription setup and Bloc integration pattern
- Queue priority algorithm (call next logic)
- Check-in flow: from appointment vs walk-in
- Triage data flow
- Justification for Bloc over Cubit (realtime requirement)
```

```
speckit.tasks
speckit.implement
```

---

## Phase 7 — In-App Messaging & Notifications

> **Branch**: `008-messaging`  
> **Dependencies**: Phase 4 (patients), Phase 3 (clinic)  
> **Module**: Messaging & Notifications (Module D)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: In-App Messaging & Notification Foundation (008-messaging)

Implement internal clinic messaging (staff-to-staff) and a notification system foundation. Patient-facing messaging (SMS/WhatsApp) is deferred to a later phase.

REQUIREMENTS:

1. INTERNAL MESSAGING:
   - Staff members within the same clinic can send messages to each other.
   - Conversations are 1-to-1 (group chat deferred).
   - Each conversation shows message history with timestamps.
   - Text messages only for now (attachments deferred).

2. CONVERSATIONS LIST:
   - Shows all conversations for the logged-in user.
   - Each item shows: other person's name, last message preview, timestamp, unread count.
   - Sorted by most recent message.

3. CHAT SCREEN:
   - Message input using AppFormField.
   - Messages displayed in chronological order (newest at bottom).
   - Auto-scroll to bottom on new message.
   - Basic read receipt: mark messages as read when conversation is opened.

4. REALTIME:
   - Supabase Realtime subscription on messages table for live updates.
   - Use Bloc for chat (justified: realtime stream + send actions).

5. IN-APP NOTIFICATIONS (foundation):
   - notifications table: id, clinic_id, user_id, type (enum: message, appointment_reminder, queue_call, system), title, body, data (jsonb), is_read, created_at.
   - NotificationCubit that fetches unread count and notification list.
   - Bell icon in app bar showing unread count badge.
   - Notification list page.
   - Push notifications (FCM) deferred — just in-app for now.

6. MESSAGE TEMPLATES (admin):
   - Admin can create reusable message templates with variables.
   - Templates stored in message_templates table: id, clinic_id, name, body_template, category, created_by, created_at.
   - Staff can select a template when composing a message and fill in variables.
   - This is the foundation for future automated patient messaging.

7. SUPABASE TABLES:
   - conversations: id, clinic_id, created_at, updated_at.
   - conversation_participants: id, conversation_id, user_id, joined_at.
   - messages: id, conversation_id, sender_id, content (text), is_read (bool), created_at.
   - notifications: id, clinic_id, user_id, type, title, body, data (jsonb), is_read, created_at.
   - message_templates: id, clinic_id, name, body_template, category, created_by, is_active, created_at.
   - RLS: users see only conversations they participate in. Notifications filtered by user_id. Message templates filtered by clinic_id.
   - Trigger: on message insert, update conversations.updated_at for sort order.
   - Trigger: on message insert, create notification for the recipient.

DOMAIN LAYER:
- Entities: Conversation, Message, Notification, MessageTemplate
- Repositories: MessagingRepository, NotificationRepository, MessageTemplateRepository
- Use cases: GetConversations, GetMessages (stream), SendMessage, MarkMessagesAsRead, CreateConversation, GetNotifications, GetUnreadNotificationCount, MarkNotificationRead, CreateMessageTemplate, GetMessageTemplates

DATA LAYER:
- Datasources, models (freezed), repository implementations

PRESENTATION LAYER:
- ConversationListCubit
- ChatBloc (realtime stream + send events)
- NotificationCubit (unread count + list)
- MessageTemplateCubit
- Pages: ConversationListPage, ChatPage, NotificationListPage, MessageTemplateListPage, CreateTemplatePage
- widgets/ as needed

ROUTES:
- /messages → ConversationListPage
- /messages/:conversationId → ChatPage
- /notifications → NotificationListPage
- /settings/message-templates → MessageTemplateListPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Stream use cases for realtime (GetMessages).
- Bloc for ChatBloc (justified: realtime + send events). Cubit for everything else.
- Data models use freezed + json_serializable.
- DI: GetIt with initMessaging() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- RLS. No PHI in logs.
- Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 008-messaging. Include:
- SQL migrations with all tables, triggers (conversation updated_at, auto-notification on message), RLS
- Supabase Realtime subscription pattern for chat
- Unread count computation strategy
- Template variable parsing approach
- Bloc justification for ChatBloc
```

```
speckit.tasks
speckit.implement
```

---

## Phase 8 — Staff Management

> **Branch**: `009-staff`  
> **Dependencies**: Phase 3 (clinic, staff assignments)  
> **Module**: Staff Management (Module E)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Staff Management (009-staff)

Implement staff scheduling (shifts), time-off requests, and staff directory for clinic management.

REQUIREMENTS:

1. STAFF DIRECTORY:
   - List all active staff for the current clinic with role, name, phone, email.
   - Filter by role.
   - Tap to see staff detail profile.

2. SHIFT MANAGEMENT:
   - Admin creates shifts: staff_id, date, start_time, end_time, location_id, notes.
   - Shift templates: recurring weekly patterns that can be applied to generate shifts for a date range.
   - shift_templates: id, clinic_id, name, entries (jsonb array: [{day_of_week, start_time, end_time, role}]).
   - Apply template: select template + date range → bulk-create shift records.

3. TIME-OFF REQUESTS:
   - Staff submits: start_date, end_date, reason, type (vacation/sick/personal/other).
   - time_off_requests: id, clinic_id, user_id, start_date, end_date, type, reason, status (pending/approved/denied), reviewed_by, reviewed_at, created_at.
   - Admin approves/denies with optional notes.
   - Approved time-off blocks those dates from provider_availability (scheduling integration).

4. STAFF CALENDAR VIEW:
   - Simple list view per staff member showing: shifts + time-off for a selected week/month.
   - Admin view: all staff rows for a selected week (grid layout — basic, no drag-and-drop yet).

5. SUPABASE TABLES:
   - shifts: id, clinic_id, staff_id, location_id, date, start_time, end_time, notes, created_by, created_at.
   - shift_templates: id, clinic_id, name, entries (jsonb), is_active, created_at.
   - time_off_requests: id, clinic_id, user_id, start_date, end_date, type, reason, status, reviewed_by, reviewed_at, created_at.
   - RLS: staff see their own shifts/requests. Admins see all for the clinic.

DOMAIN LAYER:
- Entities: Shift, ShiftTemplate, TimeOffRequest
- Repositories: StaffManagementRepository
- Use cases: GetStaffList, CreateShift, GetShiftsForDateRange, ApplyShiftTemplate, CreateShiftTemplate, SubmitTimeOffRequest, GetTimeOffRequests, ApproveTimeOff, DenyTimeOff, GetStaffCalendar

DATA LAYER:
- StaffRemoteDataSource, models (freezed), repository impl

PRESENTATION LAYER:
- StaffListCubit, ShiftCubit, TimeOffCubit, StaffCalendarCubit
- Pages: StaffDirectoryPage, ShiftManagementPage, TimeOffListPage, TimeOffRequestPage, StaffCalendarPage
- widgets/ as needed

ROUTES:
- /staff → StaffDirectoryPage
- /staff/shifts → ShiftManagementPage
- /staff/time-off → TimeOffListPage
- /staff/time-off/request → TimeOffRequestPage
- /staff/calendar → StaffCalendarPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initStaff() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- Cubit for all (no realtime needed here).
- RLS with clinic_id. Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 009-staff. Include:
- SQL migrations for shifts, shift_templates, time_off_requests with RLS
- Shift template application algorithm (template + date range → shift records)
- Integration with provider_availability from scheduling module (approved time-off blocks availability)
- Staff calendar data aggregation approach
```

```
speckit.tasks
speckit.implement
```

---

## Phase 9 — Inventory Management

> **Branch**: `010-inventory`  
> **Dependencies**: Phase 3 (clinic)  
> **Module**: Inventory (Module F)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Inventory Management (010-inventory)

Implement product catalog, stock tracking, lot management, and reorder alerts for clinic supplies and medications.

REQUIREMENTS:

1. PRODUCT CATALOG:
   - Admin adds products: name, sku, category (medication/supply/equipment), unit (tablet/vial/box/piece/ml/mg), description, reorder_point, is_active.
   - Product categories are predefined enum, not user-configurable for now.
   - Product list with search and filter by category.

2. STOCK MANAGEMENT:
   - Stock is tracked via stock_movements (event-sourced pattern). Never store current_stock as a mutable column.
   - Current stock = SUM(stock_movements.quantity) per product per location.
   - Movement types: purchase_in, adjustment, transfer_in, transfer_out, dispensed, expired, returned.
   - Each movement: id, clinic_id, product_id, product_lot_id (nullable), location_id, type, quantity (positive for in, negative for out), reference_id (nullable — e.g., invoice_id), notes, created_by, created_at.
   - Supabase view: product_stock_levels — computes current stock per product per location.

3. LOT MANAGEMENT:
   - product_lots: id, product_id, clinic_id, lot_number, expiry_date, supplier_id (nullable), purchase_price, created_at.
   - When receiving stock, create a lot and a purchase_in movement.
   - Expiry tracking: query lots expiring within 30/60/90 days.

4. RECEIVE STOCK FLOW:
   - Select product → enter lot_number, quantity, expiry_date, purchase_price, supplier (optional).
   - Creates product_lot + stock_movement (purchase_in).

5. DISPENSE / ADJUST STOCK:
   - Manual stock adjustment: select product, enter quantity adjustment (+/-), reason.
   - Dispense: select product, quantity, patient (optional) — creates stock_movement (dispensed).
   - FIFO by expiry: when dispensing, auto-select the lot with earliest expiry date.

6. REORDER ALERTS:
   - When computed stock < product.reorder_point → show in "Low Stock" list.
   - Simple alert list for now (no auto-purchase-order yet).

7. SUPPLIERS:
   - suppliers: id, clinic_id, name, phone, email, address, notes, is_active, created_at.
   - Basic CRUD — used when receiving stock.

8. SUPABASE TABLES:
   - products, product_lots, stock_movements, suppliers (all with clinic_id, RLS).
   - View: product_stock_levels (product_id, location_id, current_stock).
   - Indexes on stock_movements(product_id, location_id) for fast aggregation.

DOMAIN LAYER:
- Entities: Product, ProductLot, StockMovement, Supplier, StockLevel
- Repositories: ProductRepository, StockRepository, SupplierRepository
- Use cases: CreateProduct, GetProducts, GetProductById, ReceiveStock, DispenseStock, AdjustStock, GetStockLevels, GetLowStockProducts, GetExpiringLots, CreateSupplier, GetSuppliers

DATA LAYER:
- Datasources, models (freezed), repository implementations

PRESENTATION LAYER:
- ProductListCubit, StockCubit, SupplierCubit
- Pages: ProductListPage, ProductDetailPage, ProductFormPage, ReceiveStockPage, DispenseStockPage, StockAdjustmentPage, LowStockPage, ExpiringLotsPage, SupplierListPage, SupplierFormPage
- widgets/ as needed

ROUTES:
- /inventory → ProductListPage
- /inventory/products/new → ProductFormPage
- /inventory/products/:id → ProductDetailPage
- /inventory/receive → ReceiveStockPage
- /inventory/dispense → DispenseStockPage
- /inventory/low-stock → LowStockPage
- /inventory/expiring → ExpiringLotsPage
- /inventory/suppliers → SupplierListPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initInventory() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- Cubit for all (no realtime needed here yet).
- RLS with clinic_id. Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 010-inventory. Include:
- SQL migrations: tables, stock_levels view (computed from movements), RLS, indexes
- Event-sourced stock pattern: how stock_movements aggregate to current levels
- FIFO lot selection algorithm for dispensing
- Reorder alert query
- Expiry tracking query
```

```
speckit.tasks
speckit.implement
```

---

## Phase 10 — Electronic Health Records (EHR)

> **Branch**: `011-ehr`  
> **Dependencies**: Phase 5 (appointments), Phase 4 (patients), Phase 9 (inventory — for prescriptions)  
> **Module**: EHR/EMR (Module G)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Electronic Health Records (011-ehr)

Implement patient chart, encounters, SOAP notes, prescriptions, and basic medical history. This is the clinical documentation backbone.

REQUIREMENTS:

1. PATIENT CHART:
   - Accessed from Patient Detail screen (/patients/:id/chart).
   - Tabbed view: Overview | Encounters | Medications | Lab Results | Documents.
   - For this phase, implement: Overview, Encounters, Medications. Lab Results and Documents show "Coming Soon" placeholders.
   - Each tab has its own cubit to keep state isolated.

2. OVERVIEW TAB:
   - Shows: patient demographics summary, allergies list, active problems list, current medications, recent vitals (from triage data), upcoming appointments.
   - Allergies: simple list (name, severity: mild/moderate/severe, reaction notes). CRUD.
   - Problems: active problem list (name, icd_code optional, onset_date, status: active/resolved, notes). CRUD.

3. ENCOUNTERS:
   - An encounter is created when a doctor starts a consultation (from queue "Start Consultation" action or manually).
   - encounter: id, clinic_id, patient_id, provider_id, appointment_id (nullable), start_time, end_time (nullable), status (in_progress/completed/signed), created_at.
   - Each encounter has one SOAP note.

4. SOAP NOTES:
   - soap_notes: id, encounter_id, subjective (text), objective (text), assessment (text), plan (text), created_at, updated_at.
   - Doctor fills in each SOAP section using multiline AppFormField.
   - Auto-save draft as doctor types (debounced 2s).
   - "Sign & Complete" action: locks the note (status → signed), sets encounter end_time.
   - Signed notes are read-only.

5. PRESCRIPTIONS:
   - prescriptions: id, encounter_id, clinic_id, patient_id, product_id (FK to inventory products, nullable), medication_name (text — for non-inventory meds), dosage, frequency, duration, route (oral/topical/injection/inhaled/other), quantity, notes, is_dispensed (bool), dispensed_at, created_at.
   - Doctor adds prescriptions during an encounter.
   - If product_id links to inventory → "Dispense" button triggers stock_movement (dispensed) from inventory module.
   - Prescription list per encounter and per patient (across encounters).

6. VITALS HISTORY:
   - Pull triage_assessments for the patient (across all visits) and display as a simple table/list.
   - Shows trends over time.

7. SUPABASE TABLES:
   - encounters, soap_notes, prescriptions, allergies, problems — all with clinic_id, RLS.
   - allergies: id, clinic_id, patient_id, name, severity, reaction_notes, is_active, created_at.
   - problems: id, clinic_id, patient_id, name, icd_code, onset_date, status, notes, is_active, created_at.
   - RLS: providers in the clinic can read/write. Patients cannot access directly (no patient app yet).

DOMAIN LAYER:
- Entities: Encounter, SoapNote, Prescription, Allergy, Problem
- Repositories: EncounterRepository, PrescriptionRepository, PatientChartRepository (for allergies, problems, vitals)
- Use cases: CreateEncounter, GetEncountersByPatient, GetEncounterById, SaveSoapNote, SignEncounter, CreatePrescription, GetPrescriptionsByPatient, DispensePrescription, GetAllergies, AddAllergy, RemoveAllergy, GetProblems, AddProblem, UpdateProblem, GetPatientVitalsHistory

DATA LAYER:
- Datasources, models (freezed), repository implementations

PRESENTATION LAYER:
- PatientChartCubit (manages tab state)
- OverviewCubit (loads summary data)
- EncounterListCubit, EncounterDetailCubit
- SoapNoteCubit (auto-save + sign)
- PrescriptionCubit
- AllergyCubit, ProblemCubit
- Pages: PatientChartPage (tab shell), OverviewTab, EncountersTab, MedicationsTab, EncounterDetailPage, SoapNoteFormPage, AddPrescriptionPage, AllergyFormPage, ProblemFormPage
- widgets/ for each tab's components

ROUTES:
- /patients/:id/chart → PatientChartPage
- /patients/:id/chart/encounters/:encounterId → EncounterDetailPage
- /patients/:id/chart/encounters/:encounterId/soap → SoapNoteFormPage
- /patients/:id/chart/encounters/:encounterId/prescribe → AddPrescriptionPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initEhr() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines. The patient chart has many tabs — each tab is its own widget file.
- Cubit for all (no realtime needed for EHR in V1).
- RLS with clinic_id. No PHI in logs. Signed URLs for any future attachments.
- Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 011-ehr. Include:
- SQL migrations for encounters, soap_notes, prescriptions, allergies, problems with RLS
- SOAP note auto-save strategy (debounce, partial save, conflict resolution)
- Encounter lifecycle: creation from queue vs manual, sign-and-lock workflow
- Prescription → inventory dispensing integration
- Patient chart tab architecture (isolated cubits per tab)
- How vitals are pulled from triage_assessments (cross-module read)
```

```
speckit.tasks
speckit.implement
```

---

## Phase 11 — Billing & Invoicing

> **Branch**: `012-billing`  
> **Dependencies**: Phase 10 (encounters, prescriptions), Phase 9 (inventory — stock deduction), Phase 5 (appointments)  
> **Module**: Cross-cutting (EHR + Inventory)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Billing & Invoicing (012-billing)

Implement invoice generation, payment tracking, and billing history for clinic encounters and services.

REQUIREMENTS:

1. INVOICE CREATION:
   - Created manually or auto-generated when an encounter is completed/signed.
   - invoices: id, clinic_id, patient_id, encounter_id (nullable), invoice_number (auto per clinic, e.g., INV-0001), status (draft/issued/paid/partially_paid/cancelled/refunded), subtotal, discount_amount, tax_amount, total, payment_method (cash/card/insurance/other), paid_amount, notes, issued_at, paid_at, created_by, created_at, updated_at.

2. INVOICE LINE ITEMS:
   - invoice_items: id, invoice_id, description, quantity, unit_price, total_price, product_id (nullable — links to inventory for stock deduction), prescription_id (nullable), item_type (consultation/procedure/medication/lab/supply/other).
   - When a line item has product_id → on invoice issue, auto-create stock_movement (dispensed) via Postgres trigger.

3. BILLING FLOW:
   - After encounter → create draft invoice pre-filled with: consultation fee (from appointment_type), dispensed medications (from prescriptions), any procedures.
   - Receptionist reviews, adds/removes items, applies discounts.
   - Issue invoice → print/share receipt.
   - Record payment (full or partial).

4. BILLING HISTORY:
   - Per patient: list of all invoices with status and totals.
   - Per clinic: daily/weekly revenue summary.
   - Outstanding invoices list (issued but not fully paid).

5. RECEIPT:
   - Simple receipt view showing: clinic name, patient name, invoice items, totals, payment info, date.
   - Shareable as PDF or screenshot (basic implementation, no fancy formatting).

6. SUPABASE TABLES:
   - invoices, invoice_items (as described). RLS by clinic_id.
   - Trigger: on invoice status → 'issued', for each invoice_item with product_id, create stock_movement (dispensed, negative quantity).
   - Postgres function for invoice_number auto-generation per clinic.
   - View: daily_revenue (clinic_id, date, total_revenue, total_invoices).

DOMAIN LAYER:
- Entities: Invoice, InvoiceItem
- Repositories: BillingRepository
- Use cases: CreateInvoice, AddInvoiceItem, RemoveInvoiceItem, IssueInvoice, RecordPayment, GetInvoiceById, GetPatientInvoices, GetClinicInvoices, GetOutstandingInvoices, GetDailyRevenue

DATA LAYER:
- BillingRemoteDataSource, models (freezed), BillingRepositoryImpl

PRESENTATION LAYER:
- InvoiceCubit, BillingListCubit
- Pages: InvoiceListPage, CreateInvoicePage, InvoiceDetailPage, ReceiptPage, OutstandingInvoicesPage
- widgets/ as needed

ROUTES:
- /billing → InvoiceListPage
- /billing/new → CreateInvoicePage
- /billing/new?encounterId=X → CreateInvoicePage (pre-filled)
- /billing/:id → InvoiceDetailPage
- /billing/:id/receipt → ReceiptPage
- /billing/outstanding → OutstandingInvoicesPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initBilling() function.
- All text fields use AppFormField. All validation uses AppValidators.
- Every UI file ≤ 100 lines.
- Cubit for all.
- RLS with clinic_id. No PHI in logs.
- Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 012-billing. Include:
- SQL migrations: invoices, invoice_items, triggers for stock deduction on issue, invoice_number auto-gen, daily_revenue view, RLS
- Auto-invoice-from-encounter flow (pre-filling items from consultation fee + prescriptions)
- Payment recording and partial payment handling
- Integration with inventory stock_movements
- Receipt generation approach
```

```
speckit.tasks
speckit.implement
```

---

## Phase 12 — Analytics & Dashboard

> **Branch**: `013-analytics`  
> **Dependencies**: All previous phases (reads from all modules)  
> **Module**: Analytics & Admin (Module H)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Analytics Dashboard (013-analytics)

Implement a clinic analytics dashboard showing key performance indicators (KPIs) and basic reports.

REQUIREMENTS:

1. DASHBOARD HOME (replaces placeholder home):
   - Today's summary cards: total appointments, patients seen, revenue, pending queue.
   - Quick access: "My Day" (doctor), "Queue" (receptionist), "Recent Patients".

2. KPI REPORTS (accessed from dashboard or settings):
   - Revenue report: daily/weekly/monthly revenue with totals. Simple list view (charts in UI pass later).
   - Appointment statistics: appointments by status (completed/cancelled/no-show) for a date range.
   - Patient statistics: new patients this week/month, total active patients.
   - Provider performance: appointments completed per provider for a date range.
   - Inventory alerts: low stock count, expiring lots count.

3. DATA SOURCE:
   - All reports computed via Supabase RPC (Postgres functions) — NOT client-side aggregation.
   - Functions: get_dashboard_summary(clinic_id, date), get_revenue_report(clinic_id, start_date, end_date), get_appointment_stats(clinic_id, start_date, end_date), get_patient_stats(clinic_id), get_provider_performance(clinic_id, start_date, end_date), get_inventory_alerts(clinic_id).

4. ROLE-BASED VISIBILITY:
   - Doctors see: their own stats + general clinic summary.
   - Admins/Managers see: all provider stats + full revenue + full clinic overview.
   - Receptionists see: appointment stats + queue stats.

5. SUPABASE:
   - Create Postgres functions for each report (not tables — they aggregate existing data).
   - RLS enforcement via auth.uid() inside the functions.

DOMAIN LAYER:
- Entities: DashboardSummary, RevenueReport, AppointmentStats, PatientStats, ProviderPerformance, InventoryAlert
- Repository: AnalyticsRepository
- Use cases: GetDashboardSummary, GetRevenueReport, GetAppointmentStats, GetPatientStats, GetProviderPerformance, GetInventoryAlerts

DATA LAYER:
- AnalyticsRemoteDataSource (calls Supabase RPC), models, repository impl

PRESENTATION LAYER:
- DashboardCubit, ReportCubit
- Pages: DashboardPage (replaces HomePlaceholderPage), RevenueReportPage, AppointmentStatsPage, PatientStatsPage, ProviderPerformancePage, InventoryAlertsPage
- widgets/ for dashboard cards, summary widgets

ROUTES:
- /home → DashboardPage (replace existing placeholder)
- /reports/revenue → RevenueReportPage
- /reports/appointments → AppointmentStatsPage
- /reports/patients → PatientStatsPage
- /reports/providers → ProviderPerformancePage
- /reports/inventory → InventoryAlertsPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initAnalytics() function.
- Every UI file ≤ 100 lines.
- Cubit for all.
- Focus on functionality — data in simple lists/cards. Charts deferred to UI pass.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 013-analytics. Include:
- Postgres functions for all report calculations (SQL)
- How functions enforce RLS / role-based data access
- Dashboard page layout and data loading strategy
- Role-based widget visibility approach
- How to replace the existing HomePlaceholderPage with the new DashboardPage
```

```
speckit.tasks
speckit.implement
```

---

## Phase 13 — Compliance & Security Hardening

> **Branch**: `014-compliance`  
> **Dependencies**: All previous phases  
> **Module**: Analytics & Admin (Module H continued)

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: Compliance & Security Hardening (014-compliance)

Harden the application for production readiness with audit logging, session management, and security controls.

REQUIREMENTS:

1. AUDIT LOG:
   - audit_log table: id, clinic_id, user_id, action (text), table_name (text), record_id (uuid), old_values (jsonb), new_values (jsonb), ip_address (text nullable), created_at.
   - Append-only — no UPDATE or DELETE allowed on this table (RLS + revoke).
   - Postgres triggers on sensitive tables: patients, encounters, soap_notes, prescriptions, invoices, profiles, appointments.
   - Trigger logs: INSERT, UPDATE, DELETE with old/new values.
   - Admin can view audit log filtered by date range, user, table, action.

2. SESSION MANAGEMENT:
   - Auto-logout after 30 minutes of inactivity.
   - On app resume from background > 30 min → re-authenticate.
   - Biometric lock option (face/fingerprint) using local_auth package.
   - Settings toggle: "Require biometric on app open".

3. PHI SAFETY REVIEW:
   - Verify no PHI appears in app logs (AppLogger review).
   - Verify no PHI in error messages shown to users.
   - Verify all patient document URLs are signed with expiration.

4. ROLE-BASED UI GUARDS:
   - PermissionGuard widget: wraps any widget tree and shows/hides based on user role.
   - Usage: PermissionGuard(allowedRoles: [UserRole.clinicAdmin, UserRole.doctor], child: ...)
   - Navigation guard: routes that require specific roles redirect to access-denied.
   - Route-level role definitions in a central permissions map.

5. DATA EXPORT (admin):
   - Admin can export patient list as CSV.
   - Admin can export invoice list as CSV for a date range.
   - Basic export only — no complex report formatting.

6. PACKAGES TO ADD:
   - local_auth (biometric)
   - csv (export)

7. SUPABASE:
   - audit_log table + triggers (SQL migration)
   - Review and tighten all existing RLS policies
   - Ensure service_role key is NEVER used in client code

DOMAIN LAYER:
- Entities: AuditLogEntry
- Repositories: AuditRepository, SecurityRepository
- Use cases: GetAuditLog, ExportPatientsCsv, ExportInvoicesCsv
- Session management logic can live in a core SessionManager utility

PRESENTATION LAYER:
- AuditLogCubit
- SessionCubit (manages timeout, biometric)
- Pages: AuditLogPage, SecuritySettingsPage
- PermissionGuard widget in core/

ROUTES:
- /admin/audit-log → AuditLogPage
- /settings/security → SecuritySettingsPage

CONVENTIONS:
- Three-layer Clean Architecture: domain / data / presentation.
- Domain layer is pure Dart — zero Flutter or Supabase imports.
- All use cases implement base interfaces from core/usecase/usecase.dart.
- Data models use freezed + json_serializable.
- DI: GetIt with initCompliance() function.
- Every UI file ≤ 100 lines.
- Cubit for all.
- This phase is about security — be thorough with RLS review.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
```

**Prompt**:

```
Generate the implementation plan for 014-compliance. Include:
- Full audit_log SQL: table, append-only enforcement (revoke UPDATE/DELETE), triggers for all sensitive tables
- Session timeout implementation approach (app lifecycle listener)
- Biometric integration with local_auth
- PermissionGuard widget architecture
- CSV export implementation
- RLS policy review checklist for all existing tables
```

```
speckit.tasks
speckit.implement
```

---

## Phase 14 — Navigation & App Shell Update

> **Branch**: `015-app-shell`  
> **Dependencies**: All feature modules (routing all established)  
> **Goal**: Wire all feature modules into the main navigation shell

### Step 1: Specify

```
speckit.specify
```

**Prompt**:

```
Feature: App Shell & Navigation Update (015-app-shell)

Update the main app shell (ScaffoldWithNavBar) and GoRouter configuration to include all implemented feature modules in a coherent navigation structure.

REQUIREMENTS:

1. BOTTOM NAVIGATION (for doctors):
   - Home (Dashboard)
   - My Day (today's appointments + queue)
   - Patients
   - Messages
   - More (settings, staff, inventory, billing, reports — as a list page)

2. BOTTOM NAVIGATION (for admins/receptionists):
   - Home (Dashboard)
   - Appointments
   - Queue
   - Patients
   - More (settings, staff, inventory, billing, reports, message templates)

3. ROLE-BASED NAV:
   - Navigation items shown based on user role using the PermissionGuard concept.
   - GoRouter branches adjusted per role.

4. ROUTE CONSOLIDATION:
   - Register all feature routes from phases 2-13.
   - Ensure deep linking works (each route has a unique path).
   - All route names in RouteNames constants class.

5. DI CONSOLIDATION:
   - injection_container.dart calls all feature initX() functions in dependency order.

This is a wiring/integration feature — no new business logic.

CONVENTIONS:
- Every UI file ≤ 100 lines.
- Focus on functionality — minimal UI.
```

### Step 2–4: Plan → Tasks → Implement

```
speckit.plan
speckit.tasks
speckit.implement
```

---

## Summary: Phase Execution Order

| # | Phase | Branch | Speckit Commands | Key Outputs |
|---|-------|--------|-----------------|-------------|
| 0 | Constitution Update | — | `constitute` | Updated constitution |
| 1 | Core Foundation | `001-core-foundation` | ✅ DONE | Core infra |
| 1.5 | UseCase Upgrade | `002-usecase-upgrade` | specify → plan → tasks → implement | New UseCase interfaces + freezed |
| 2 | Authentication | `003-auth` | specify → plan → tasks → implement | Google/Apple login, profiles |
| 3 | Clinic & Tenancy | `004-clinic-tenancy` | specify → plan → tasks → implement | Multi-clinic, invite codes |
| 4 | Patient Management | `005-patients` | specify → plan → tasks → implement | Patient CRUD, search |
| 5 | Scheduling | `006-scheduling` | specify → plan → tasks → implement | Appointments, availability |
| 6 | Queue & Check-In | `007-queue` | specify → plan → tasks → implement | Digital queue, triage |
| 7 | Messaging | `008-messaging` | specify → plan → tasks → implement | Internal chat, notifications |
| 8 | Staff Management | `009-staff` | specify → plan → tasks → implement | Shifts, time-off |
| 9 | Inventory | `010-inventory` | specify → plan → tasks → implement | Stock, lots, reorder |
| 10 | EHR | `011-ehr` | specify → plan → tasks → implement | Encounters, SOAP, prescriptions |
| 11 | Billing | `012-billing` | specify → plan → tasks → implement | Invoices, payments |
| 12 | Analytics | `013-analytics` | specify → plan → tasks → implement | Dashboard, KPI reports |
| 13 | Compliance | `014-compliance` | specify → plan → tasks → implement | Audit log, session, biometric |
| 14 | App Shell | `015-app-shell` | specify → plan → tasks → implement | Navigation wiring |

---

## Post-Implementation: UI Polish Pass

After all functionality phases are complete, run a dedicated UI polish cycle:

1. **Design system audit** — review all screens against Figma tokens
2. **Animation & transitions** — page transitions, loading states, micro-interactions
3. **Responsive layout** — tablet support, landscape orientation
4. **Accessibility** — semantic labels, contrast ratios, screen reader support
5. **Localization** — Arabic/English with RTL support
6. **Charts & visualization** — replace list-based reports with fl_chart/syncfusion
7. **Calendar widget** — replace list-based appointment views with a proper calendar
8. **Drag-and-drop** — appointment rescheduling via drag on calendar
9. **Onboarding polish** — first-run experience, empty states, tooltips

Each UI polish item can follow the same speckit.specify → plan → tasks → implement cycle targeting the specific presentation layer of each module.

---

## Notes on Best Practices

### UseCase Interfaces (Recommended Pattern)

```dart
// core/usecase/usecase.dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;
typedef StreamResult<T> = Stream<Either<Failure, T>>;

abstract interface class UseCaseWithParams<T, Params> {
  FutureResult<T> call(Params params);
}

abstract interface class UseCaseWithoutParams<T> {
  FutureResult<T> call();
}

abstract interface class StreamUseCaseWithParams<T, Params> {
  StreamResult<T> call(Params params);
}

abstract interface class StreamUseCaseWithoutParams<T> {
  StreamResult<T> call();
}
```

**Why this is better than the single `UseCase<T, Params>` + `NoParams`:**
- `abstract interface class` (Dart 3) — cannot be extended, only implemented. Enforces contracts.
- No `NoParams` sentinel — use cases without parameters have a cleaner `call()` signature.
- Stream variants for Supabase Realtime subscriptions (queue, chat).
- Type aliases (`FutureResult`, `StreamResult`) reduce boilerplate in every use case.

### Repository Pattern

```dart
// Domain: abstract interface (pure Dart)
abstract interface class AuthRepository {
  FutureResult<UserProfile> signInWithGoogle();
  FutureResult<void> signOut();
}

// Data: implementation (can import Supabase, handle exceptions)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(this._remote, this._networkInfo);

  @override
  FutureResult<UserProfile> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remote.signInWithGoogle();
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### File Size Enforcement

Every presentation-layer file (pages, widgets) must stay ≤ 100 lines. When a page grows beyond this:

```
features/scheduling/presentation/
  pages/
    book_appointment_page.dart        # ≤ 100 lines — orchestrates layout
  widgets/
    patient_selector_widget.dart      # ≤ 100 lines
    time_slot_grid_widget.dart        # ≤ 100 lines
    appointment_type_picker.dart      # ≤ 100 lines
    booking_confirmation_card.dart    # ≤ 100 lines
```
