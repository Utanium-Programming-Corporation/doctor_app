# Tasks: Authentication & User Onboarding

**Input**: Design documents from `/specs/003-auth/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/supabase-migration.sql ✅, quickstart.md ✅

**Tests**: Not explicitly requested in feature specification — test tasks omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add packages, create directory structure, run SQL migration

- [X] T001 Add google_sign_in and sign_in_with_apple to dependencies in pubspec.yaml and run flutter pub get
- [X] T002 Run Supabase SQL migration from specs/003-auth/contracts/supabase-migration.sql in the Supabase SQL Editor
- [X] T003 Create feature directory structure under lib/features/auth/ with domain/, data/, presentation/ subdirectories and .gitkeep files

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can begin. Includes shared entities, repository interface, data layer, and core UI prerequisites.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### Core UI Prerequisites

- [X] T004 [P] Create composable validators in lib/core/utils/app_validators.dart with required(), minLength(n), maxLength(n), phone(), and compose() methods
- [X] T005 [P] Create AppFormField widget with buildTextField() and buildTextFieldClearable() static helpers in lib/core/theme/components/app_form_field.dart

### Domain Layer (Shared)

- [X] T006 [P] Create UserProfile entity with UserRole enum and CreateProfileParams in lib/features/auth/domain/entities/user_profile.dart
- [X] T007 Create AuthRepository abstract interface in lib/features/auth/domain/repositories/auth_repository.dart with signInWithGoogle, signInWithApple, signOut, getCurrentUser, getProfile, createProfile, and onAuthStateChange methods

### Data Layer (Shared)

- [X] T008 Create UserProfileModel freezed data model in lib/features/auth/data/models/user_profile_model.dart extending UserProfile entity
- [X] T009 Run dart run build_runner build --delete-conflicting-outputs to generate .freezed.dart and .g.dart files
- [X] T010 Create AuthRemoteDataSource abstract interface and AuthRemoteDataSourceImpl in lib/features/auth/data/datasources/auth_remote_data_source.dart wrapping Supabase auth and profiles table calls
- [X] T011 Create AuthRepositoryImpl in lib/features/auth/data/repositories/auth_repository_impl.dart catching exceptions and mapping to Failure types

### Presentation Layer (Shared State)

- [X] T012 Create AuthState classes (AuthInitial, AuthLoading, Authenticated, Unauthenticated, AuthError) in lib/features/auth/presentation/cubit/auth_state.dart

**Checkpoint**: Foundation ready — domain, data, and state infrastructure complete. User story implementation can now begin.

---

## Phase 3: User Story 1 — Sign In with Google or Apple (Priority: P1) 🎯 MVP

**Goal**: Users can sign in via Google or Apple and be routed to dashboard (existing profile) or profile setup (no profile).

**Independent Test**: Tap either sign-in button, complete OAuth flow, verify correct routing to dashboard or profile setup screen.

### Use Cases

- [X] T013 [P] [US1] Create SignInWithGoogle use case (UseCaseWithoutParams) in lib/features/auth/domain/usecases/sign_in_with_google.dart
- [X] T014 [P] [US1] Create SignInWithApple use case (UseCaseWithoutParams) in lib/features/auth/domain/usecases/sign_in_with_apple.dart
- [X] T015 [P] [US1] Create GetCurrentUser use case (UseCaseWithoutParams) in lib/features/auth/domain/usecases/get_current_user.dart
- [X] T016 [P] [US1] Create GetUserProfile use case (UseCaseWithParams<UserProfile, String>) in lib/features/auth/domain/usecases/get_user_profile.dart

### Cubit

- [X] T017 [US1] Implement AuthCubit with signInWithGoogle(), signInWithApple(), and checkSession() methods in lib/features/auth/presentation/cubit/auth_cubit.dart

### Presentation

- [X] T018 [US1] Create WelcomePage with Google and Apple sign-in buttons in lib/features/auth/presentation/pages/welcome_page.dart (≤100 lines)

### Integration

- [X] T019 [US1] Update RouteNames to add welcome and profileSetup constants in lib/core/router/route_names.dart
- [X] T020 [US1] Remove AuthStateNotifier class from lib/core/router/auth_state.dart (keep AuthStatus enum)
- [X] T021 [US1] Create AuthCubitRefreshListenable bridge and update AppRouter to use AuthCubit for redirect logic and add /welcome route replacing /login in lib/core/router/app_router.dart
- [X] T022 [US1] Remove LoginPlaceholderPage from lib/core/router/placeholder_pages.dart
- [X] T023 [US1] Create initAuth() DI function in lib/features/auth/di/auth_injection.dart registering all data sources, repositories, use cases, and cubit
- [X] T024 [US1] Update injection_container.dart to call initAuth(), remove AuthStateNotifier registration, and update AppRouter dependency in lib/core/di/injection_container.dart

**Checkpoint**: Sign-in flow works end-to-end. Users reach dashboard (existing profile) or blank profile-setup route (no profile). MVP delivered.

---

## Phase 4: User Story 2 — Profile Setup for First-Time Users (Priority: P1)

**Goal**: First-time users fill out an onboarding form and create their profile, then proceed to dashboard.

**Independent Test**: Sign in as new user, verify profile setup form appears, fill form, submit, verify profile created and user navigated to dashboard.

### Use Case

- [X] T025 [P] [US2] Create CreateUserProfile use case (UseCaseWithParams<UserProfile, CreateProfileParams>) in lib/features/auth/domain/usecases/create_user_profile.dart

### Cubit

- [X] T026 [US2] Add createProfile() method to AuthCubit that calls CreateUserProfile and re-fetches profile in lib/features/auth/presentation/cubit/auth_cubit.dart

### Presentation

- [X] T027 [US2] Create ProfileSetupPage with full_name, phone_number, and preferred_language fields using AppFormField and AppValidators in lib/features/auth/presentation/pages/profile_setup_page.dart (≤100 lines)

### Integration

- [X] T028 [US2] Add /profile-setup route to AppRouter pointing to ProfileSetupPage in lib/core/router/app_router.dart

**Checkpoint**: Full onboarding funnel works. New users sign in → setup profile → reach dashboard.

---

## Phase 5: User Story 3 — Auto-Login on App Restart (Priority: P2)

**Goal**: Users with a valid session skip the welcome screen and go directly to dashboard on app restart.

**Independent Test**: Sign in, force-close app, reopen, verify direct navigation to dashboard.

- [X] T029 [US3] Ensure AuthCubit.checkSession() is called on cubit construction and checks Supabase.instance.client.auth.currentUser in lib/features/auth/presentation/cubit/auth_cubit.dart

**Checkpoint**: Returning users bypass sign-in screen automatically.

---

## Phase 6: User Story 4 — Sign Out (Priority: P2)

**Goal**: Users can sign out from settings, clearing session and returning to welcome screen.

**Independent Test**: Sign in, navigate to settings, tap sign out, verify redirect to welcome screen.

### Use Case

- [X] T030 [P] [US4] Create SignOut use case (UseCaseWithoutParams) in lib/features/auth/domain/usecases/sign_out.dart

### Cubit

- [X] T031 [US4] Add signOut() method to AuthCubit in lib/features/auth/presentation/cubit/auth_cubit.dart

### Presentation

- [X] T032 [US4] Add sign-out button to SettingsPlaceholderPage that calls AuthCubit.signOut() in lib/core/router/placeholder_pages.dart

**Checkpoint**: Sign-out flow works. Session cleared, user redirected to welcome screen.

---

## Phase 7: User Story 5 — Reactive Auth State Management (Priority: P2)

**Goal**: App reactively listens to auth state changes and enforces route guards for all auth states.

**Independent Test**: Revoke session in Supabase dashboard, verify app redirects user to welcome screen.

### Use Case

- [X] T033 [P] [US5] Create WatchAuthState use case (StreamUseCaseWithoutParams) in lib/features/auth/domain/usecases/watch_auth_state.dart

### Cubit

- [X] T034 [US5] Add stream subscription to AuthCubit that listens to WatchAuthState and updates state on auth events in lib/features/auth/presentation/cubit/auth_cubit.dart

### Integration

- [X] T035 [US5] Verify AppRouter redirect handles all AuthState variants including Authenticated(profile: null) → /profile-setup in lib/core/router/app_router.dart

**Checkpoint**: All auth states are reactive. Session revocation, expiry, and token refresh are handled automatically.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup across all user stories

- [X] T036 [P] Remove UserRole.patient from the existing UserRole enum in lib/core/router/auth_state.dart (if still present after T020)
- [X] T037 Run flutter analyze and fix any warnings or errors
- [X] T038 Verify all presentation files are ≤100 lines (Constitution VII compliance)
- [X] T039 Run quickstart.md verification steps: flutter analyze and flutter test

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (packages installed) — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 2 — MVP delivery target
- **US2 (Phase 4)**: Depends on Phase 2; integrates with Phase 3 (AuthCubit exists)
- **US3 (Phase 5)**: Depends on Phase 3 (cubit + session check)
- **US4 (Phase 6)**: Depends on Phase 2; can run parallel with US2/US3
- **US5 (Phase 7)**: Depends on Phase 3 (cubit + router integration)
- **Polish (Phase 8)**: Depends on all desired user stories being complete

### User Story Dependencies

- **US1 (P1)**: Standalone after Phase 2 — delivers sign-in
- **US2 (P1)**: Standalone after Phase 2 — delivers profile setup. Integrates with AuthCubit from US1 (adding createProfile method)
- **US3 (P2)**: Extends US1's AuthCubit.checkSession() — minimal new code
- **US4 (P2)**: Standalone after Phase 2 — adds sign-out method to cubit
- **US5 (P2)**: Extends US1's stream infrastructure — adds WatchAuthState subscription

### Within Each User Story

- Use cases before cubit methods
- Cubit methods before pages
- Pages before router integration
- Core implementation before cross-cutting

### Parallel Opportunities

- T004, T005 (core prereqs) can run in parallel
- T006, T007 (domain entities + interface) — T006 is parallel; T007 depends on T006
- T013, T014, T015, T016 (use cases) can all run in parallel
- T025 (CreateUserProfile) can run parallel with US1 use cases
- T030 (SignOut) can run parallel with US2 tasks
- T033 (WatchAuthState) can run parallel with US4 tasks
- US4 and US5 can run in parallel after US1 completes

---

## Parallel Example: User Story 1

```
# Phase 2 parallel batch 1 (core prereqs — different files):
T004: lib/core/utils/app_validators.dart
T005: lib/core/theme/components/app_form_field.dart
T006: lib/features/auth/domain/entities/user_profile.dart

# Phase 2 sequential (depends on T006):
T007: lib/features/auth/domain/repositories/auth_repository.dart
T008: lib/features/auth/data/models/user_profile_model.dart
T009: build_runner
T010: lib/features/auth/data/datasources/auth_remote_data_source.dart
T011: lib/features/auth/data/repositories/auth_repository_impl.dart
T012: lib/features/auth/presentation/cubit/auth_state.dart

# US1 parallel batch (use cases — different files):
T013: sign_in_with_google.dart
T014: sign_in_with_apple.dart
T015: get_current_user.dart
T016: get_user_profile.dart

# US1 sequential:
T017: auth_cubit.dart (depends on T013-T016)
T018: welcome_page.dart (depends on T017)
T019-T024: integration (sequential, modifying shared files)
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2)

1. Complete Phase 1: Setup (packages + SQL migration)
2. Complete Phase 2: Foundational (entities, models, data layer, state classes)
3. Complete Phase 3: US1 — Sign In (cubit, welcome page, router integration)
4. **STOP and VALIDATE**: Sign-in works, routing correct
5. Complete Phase 4: US2 — Profile Setup (create profile use case, form page)
6. **STOP and VALIDATE**: Full onboarding funnel works end-to-end

### Incremental Delivery

1. Setup + Foundational → Infrastructure ready
2. US1 → Sign-in works → Demo (MVP core)
3. US2 → Profile setup works → Demo (complete onboarding)
4. US3 → Auto-login works → Demo (returning user UX)
5. US4 → Sign-out works → Demo (session management)
6. US5 → Reactive auth → Demo (security hardening)
7. Polish → Production-ready

---

## Notes

- [P] tasks operate on different files with no dependencies
- [US*] labels map tasks to spec.md user stories for traceability
- AuthCubit is built incrementally: US1 adds sign-in + session check, US2 adds createProfile, US4 adds signOut, US5 adds stream subscription
- AppRouter is modified in US1 (major rewrite) and US2 (add profile-setup route)
- No test tasks generated (not requested in spec). Add tests via a follow-up if needed.
- All presentation files must stay ≤100 lines per Constitution VII
