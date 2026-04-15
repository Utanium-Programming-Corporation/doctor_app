# Feature Specification: Authentication & User Onboarding

**Feature Branch**: `003-auth`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Implement Google Sign-In and Apple Sign-In authentication using Supabase Auth with profile onboarding for first-time users."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Sign In with Google or Apple (Priority: P1)

A doctor opens the app for the first time (or after signing out) and sees a welcoming landing screen with two sign-in options: "Sign in with Google" and "Sign in with Apple." They tap one option, complete the native authentication flow, and are either taken to their home dashboard (if they already have a profile) or to the profile setup screen (if they are new).

**Why this priority**: Authentication is the gateway to the entire app. No other feature can function without it. This is the minimum viable entry point.

**Independent Test**: Can be fully tested by tapping either sign-in button, completing the OAuth flow, and verifying the user lands on the correct next screen (dashboard or profile setup). Delivers the ability to enter the app.

**Acceptance Scenarios**:

1. **Given** the user is not signed in, **When** they open the app, **Then** they see the welcome screen with "Sign in with Google" and "Sign in with Apple" buttons and no other sign-in methods.
2. **Given** the user is on the welcome screen, **When** they tap "Sign in with Google" and successfully authenticate, **Then** the system checks for an existing profile and navigates accordingly.
3. **Given** the user is on the welcome screen, **When** they tap "Sign in with Apple" and successfully authenticate, **Then** the system checks for an existing profile and navigates accordingly.
4. **Given** the user has a valid existing profile, **When** they complete sign-in, **Then** they are navigated directly to the home dashboard.
5. **Given** the user does not have an existing profile, **When** they complete sign-in, **Then** they are navigated to the profile setup screen.
6. **Given** the authentication attempt fails (network error, user cancels, provider error), **When** the flow completes, **Then** an informative error message is shown on the welcome screen and the user can retry.

---

### User Story 2 - Profile Setup for First-Time Users (Priority: P1)

A newly authenticated doctor who has no profile is presented with a simple onboarding form. They enter their full name, optionally their phone number, and select their preferred language (English or Arabic). On submission, a profile is created and they proceed to the home dashboard.

**Why this priority**: Without profile creation, first-time users are stuck in a dead-end state. This is co-equal with sign-in as it completes the onboarding funnel.

**Independent Test**: Can be tested by signing in as a new user (no profile row) and verifying the form appears, accepts input, creates the profile, and navigates to the dashboard.

**Acceptance Scenarios**:

1. **Given** a newly authenticated user with no profile, **When** the profile setup screen loads, **Then** it shows fields for full name, phone number (optional), and preferred language (English/Arabic selector).
2. **Given** the user is on the profile setup screen, **When** they submit the form with a valid full name, **Then** a profile is created with role 'doctor' and default language 'en', and the user navigates to the home dashboard.
3. **Given** the user is on the profile setup screen, **When** they submit the form without entering a full name, **Then** a validation error is shown requiring the full name.
4. **Given** the user is on the profile setup screen, **When** they enter an optional phone number, **Then** it is stored in the profile.
5. **Given** the user is on the profile setup screen, **When** they select Arabic as their preferred language, **Then** the profile stores 'ar' as the preferred language.
6. **Given** profile creation fails (network error, server error), **When** submission completes, **Then** an error message is displayed and the user can retry without losing their input.

---

### User Story 3 - Auto-Login on App Restart (Priority: P2)

A doctor who previously signed in closes and reopens the app. The app detects their existing valid session and takes them directly to the home dashboard without showing the sign-in screen.

**Why this priority**: This is critical for daily usability — doctors should not re-authenticate every time they open the app. However, it depends on sign-in working first.

**Independent Test**: Can be tested by signing in, force-closing the app, reopening it, and verifying the user reaches the dashboard without a sign-in prompt.

**Acceptance Scenarios**:

1. **Given** a user previously signed in with a valid session, **When** they reopen the app, **Then** they are taken directly to the home dashboard.
2. **Given** a user's session has expired or been invalidated, **When** they reopen the app, **Then** they see the welcome screen.

---

### User Story 4 - Sign Out (Priority: P2)

A doctor who is signed in navigates to settings or their profile menu and taps "Sign Out." The session is cleared and they are returned to the welcome screen.

**Why this priority**: Sign out is essential for device sharing and security, but it's secondary to the core sign-in flow.

**Independent Test**: Can be tested by signing in, navigating to sign-out, tapping it, and verifying redirection to the welcome screen and inability to access protected screens.

**Acceptance Scenarios**:

1. **Given** a signed-in user, **When** they tap "Sign Out" from the settings or profile menu, **Then** the session is cleared and they are redirected to the welcome screen.
2. **Given** a user has signed out, **When** they attempt to navigate to a protected screen (e.g., via deep link or back button), **Then** they are redirected to the welcome screen.

---

### User Story 5 - Reactive Auth State Management (Priority: P2)

The app continuously listens to authentication state changes. If the user's session is revoked server-side, or the token expires, the app automatically redirects to the welcome screen. Router guards enforce that unauthenticated users cannot access protected screens and authenticated users cannot linger on the welcome screen.

**Why this priority**: Reactive state management ensures security and smooth navigation. It underpins stories 1-4 but is listed separately as it involves infrastructure rather than direct user action.

**Independent Test**: Can be tested by revoking a session in the Supabase dashboard and verifying the app redirects the user to the welcome screen.

**Acceptance Scenarios**:

1. **Given** a signed-in user, **When** their session is revoked server-side, **Then** the app detects the change and redirects to the welcome screen.
2. **Given** an unauthenticated user, **When** they attempt to navigate to a protected route, **Then** they are redirected to the welcome screen.
3. **Given** an authenticated user with a profile, **When** they attempt to navigate to the welcome screen, **Then** they are redirected to the home dashboard.
4. **Given** an authenticated user without a profile, **When** they attempt to navigate to the home dashboard, **Then** they are redirected to the profile setup screen.

---

### Edge Cases

- What happens when the user revokes Google/Apple permissions from their device settings after signing in? The next API call fails and the auth state listener redirects to the welcome screen.
- What happens when the user has no internet connection during sign-in? An appropriate error message is shown on the welcome screen.
- What happens when profile creation partially fails (auth row exists but profile insert fails)? The user is shown the profile setup screen on next login attempt since no profile row exists.
- What happens when two devices sign in with the same account? Both sessions are valid; concurrent sessions are supported.
- What happens when the backend service is unreachable? Error messages are shown; the app does not crash or expose technical details.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support sign-in exclusively via Google Sign-In and Apple Sign-In. No email/password or phone OTP methods are permitted.
- **FR-002**: System MUST use native sign-in SDKs on mobile platforms and OAuth redirect flow on web.
- **FR-003**: On successful authentication, the system MUST check whether a user profile exists in the `profiles` table linked to the authenticated user's ID.
- **FR-004**: If a profile exists, the system MUST navigate the user to the home dashboard.
- **FR-005**: If no profile exists, the system MUST navigate the user to the profile setup screen.
- **FR-006**: The profile setup form MUST collect: full name (required), phone number (optional), and preferred language (English or Arabic, defaulting to English).
- **FR-007**: On profile creation, the system MUST assign the default role 'doctor'.
- **FR-008**: On profile creation, the system MUST create a row in the `profiles` table linked to the authenticated user's ID.
- **FR-009**: After successful profile creation, the system MUST navigate the user to the home dashboard.
- **FR-010**: System MUST provide a sign-out action accessible from settings or profile menu that clears the session and redirects to the welcome screen.
- **FR-011**: System MUST listen to authentication state changes in real time and react to session creation, expiration, and revocation.
- **FR-012**: On app launch, the system MUST check for an existing valid session and auto-login if one exists.
- **FR-013**: Router guards MUST prevent unauthenticated users from accessing protected screens.
- **FR-014**: Router guards MUST prevent authenticated users from accessing the welcome/sign-in screen.
- **FR-015**: All authentication errors MUST be displayed as user-friendly messages without exposing technical details or PHI.
- **FR-016**: All text input fields on the profile setup screen MUST use the unified text input component via standard helper functions.
- **FR-017**: All form validation MUST use the composable validator pattern.
- **FR-018**: The `profiles` table MUST have Row Level Security policies ensuring users can only read and update their own profile.

### Key Entities

- **UserProfile**: Represents a doctor's profile in the system. Key attributes: unique identifier (linked to auth user), full name, phone number (optional), role (doctor by default), preferred language (English or Arabic), avatar URL (optional), creation and update timestamps.
- **Profiles Table**: Database table storing user profiles. Columns: id (references auth user), full_name, phone_number (nullable), role (enum: super_admin, clinic_admin, doctor, nurse, receptionist, pharmacist), preferred_language (default 'en'), avatar_url (nullable), created_at, updated_at.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the full sign-in flow (tap button → reach dashboard or profile setup) in under 10 seconds on a standard mobile connection.
- **SC-002**: First-time users can complete profile setup (fill form → reach dashboard) in under 60 seconds.
- **SC-003**: 100% of sign-in attempts that fail display a clear, non-technical error message to the user.
- **SC-004**: Auto-login on app restart completes without requiring any user interaction when a valid session exists.
- **SC-005**: Sign-out fully clears the session; the user cannot access protected content without re-authenticating.
- **SC-006**: Auth state changes (session expiry, revocation) are detected and acted upon within 5 seconds.
- **SC-007**: No Protected Health Information or authentication tokens appear in application logs.
- **SC-008**: The profiles table enforces row-level security: users can only read and update their own profile row.

## Assumptions

- Users have a stable internet connection during sign-in and profile creation (offline sign-in is not supported).
- Google and Apple developer accounts are configured with the correct OAuth credentials and redirect URIs for the authentication provider.
- The authentication backend is provisioned and configured for Google and Apple providers.
- The home dashboard screen exists (or a placeholder exists) to navigate to after successful authentication.
- This feature does not handle clinic assignment — doctors are associated with clinics in a separate feature.
- The `profiles` table does not include `clinic_id` at this stage; clinic association is a separate feature. RLS policies for this feature scope to the user's own profile only.
- Avatar upload functionality is out of scope; the `avatar_url` field is nullable and unused in this feature.
- Web platform support for sign-in uses OAuth redirect as a fallback; native SDK behavior is the primary target.
- The SQL migration script for the profiles table and RLS policies will be provided as part of this feature's implementation artifacts.
