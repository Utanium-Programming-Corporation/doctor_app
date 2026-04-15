# Implementation Plan: Authentication & User Onboarding

**Branch**: `003-auth` | **Date**: 2026-04-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/003-auth/spec.md`

## Summary

Implement Google Sign-In and Apple Sign-In as the sole authentication methods using Supabase Auth with native mobile SDKs. On first sign-in, users complete a profile setup form (full name, optional phone, language preference). AuthCubit replaces the existing `AuthStateNotifier` as the single source of auth truth, driving GoRouter redirects. A `profiles` Supabase table with RLS stores user profile data.

## Technical Context

**Language/Version**: Dart 3.11.4+ / Flutter (latest stable)  
**Primary Dependencies**: supabase_flutter, google_sign_in, sign_in_with_apple, flutter_bloc, go_router, get_it, dartz, freezed, equatable  
**Storage**: Supabase (PostgreSQL) — `profiles` table with RLS  
**Testing**: flutter_test, mocktail, bloc_test  
**Target Platform**: iOS, Android (web deferred)  
**Project Type**: Mobile app (Flutter)  
**Performance Goals**: Sign-in flow < 10s, 60fps UI  
**Constraints**: No PHI in logs, RLS on all tables, offline sign-in not supported  
**Scale/Scope**: Single feature (auth), ~20 files, 7 use cases, 1 cubit, 2 pages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | ✅ PASS | Three layers: domain (pure Dart), data (Supabase), presentation (Cubit). Use cases implement the four abstract interfaces. |
| II. Type-Safe Functional Error Handling | ✅ PASS | All use cases return `Either<Failure, T>`. Entities use Equatable. UserProfileModel uses freezed. |
| III. Security & HIPAA Compliance | ✅ PASS | RLS on profiles table. No PHI in logs. Auth tokens not logged. |
| IV. Feature-Modular Organization | ✅ PASS | Self-contained under `lib/features/auth/` with `initAuth()` in DI. |
| V. Cubit-Default State Management | ✅ PASS | AuthCubit for all auth state. WatchAuthState stream is consumed by Cubit (no Bloc needed — Cubit subscribes to stream internally). |
| VI. Supabase-First Backend | ✅ PASS | Google/Apple Sign-In only. Native SDKs on mobile. |
| VII. UI File Size Discipline | ✅ PASS | WelcomePage and ProfileSetupPage each ≤ 100 lines. Overflow splits to widgets/ subfolder. |
| VIII. Unified Text Input | ✅ PASS | ProfileSetupPage uses AppFormField via buildTextField helpers. AppFormField and AppValidators must be created in core/ as prerequisites. |

**Pre-check result**: ALL GATES PASS. No violations to justify.

## Project Structure

### Documentation (this feature)

```text
specs/003-auth/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── supabase-migration.sql
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/
│   │   └── components/
│   │       └── app_form_field.dart          # NEW — prerequisite shared widget
│   ├── utils/
│   │   └── app_validators.dart              # NEW — prerequisite composable validators
│   ├── router/
│   │   ├── app_router.dart                  # MODIFY — replace AuthStateNotifier with AuthCubit
│   │   ├── auth_state.dart                  # MODIFY — keep AuthStatus enum, remove AuthStateNotifier class
│   │   ├── route_names.dart                 # MODIFY — add profileSetup, welcome route names
│   │   └── placeholder_pages.dart           # MODIFY — remove LoginPlaceholderPage (replaced by WelcomePage)
│   └── di/
│       └── injection_container.dart         # MODIFY — call initAuth(), remove AuthStateNotifier registration
│
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_profile.dart        # UserProfile (Equatable)
│       │   ├── repositories/
│       │   │   └── auth_repository.dart     # Abstract interface
│       │   └── usecases/
│       │       ├── sign_in_with_google.dart
│       │       ├── sign_in_with_apple.dart
│       │       ├── sign_out.dart
│       │       ├── get_current_user.dart
│       │       ├── get_user_profile.dart
│       │       ├── create_user_profile.dart
│       │       └── watch_auth_state.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── auth_remote_data_source.dart
│       │   ├── models/
│       │   │   └── user_profile_model.dart  # freezed, extends UserProfile
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── auth_cubit.dart
│           │   └── auth_state.dart
│           ├── pages/
│           │   ├── welcome_page.dart
│           │   └── profile_setup_page.dart
│           └── widgets/                     # Only if pages exceed 100 lines
│               └── .gitkeep
```

**Structure Decision**: Standard Flutter Clean Architecture under `lib/features/auth/` with three layers. Core prerequisites (`AppFormField`, `AppValidators`) go in `lib/core/` since they are shared across all features per Constitution VIII. Router and DI modifications are in-place edits to existing core files.

## Complexity Tracking

No violations to justify. All constitution gates pass.
