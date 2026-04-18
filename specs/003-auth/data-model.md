# Data Model: Authentication & User Onboarding (003-auth)

**Date**: 2026-04-12  
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Entities

### UserProfile

Pure Dart domain entity. No Flutter or Supabase imports.

| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID, references auth.users.id |
| fullName | String | Required |
| phoneNumber | String? | Optional |
| role | UserRole | Enum. Default: `doctor` |
| preferredLanguage | String | `'en'` or `'ar'`. Default: `'en'` |
| avatarUrl | String? | Optional. Out of scope for this feature. |
| createdAt | DateTime | Set on insert |
| updatedAt | DateTime | Set on insert and update |

**Extends**: `Equatable`

### UserRole (Enum)

Shared enum between domain and database. Already partially defined in `core/router/auth_state.dart` — will be moved to a shared location or kept in the entity file.

| Value | DB column value |
|-------|----------------|
| superAdmin | `'super_admin'` |
| clinicAdmin | `'clinic_admin'` |
| doctor | `'doctor'` |
| nurse | `'nurse'` |
| receptionist | `'receptionist'` |
| pharmacist | `'pharmacist'` |

**Note**: The existing `UserRole` enum in `auth_state.dart` includes `patient`. The profiles table enum constraint does NOT include `patient` (patients are end-users, not clinic staff). The domain entity enum should match the database. The `patient` value in the existing enum should be removed. If a patient-facing app is built later, it will have its own role system.

## Data Models

### UserProfileModel

Freezed data model in the data layer. Extends `UserProfile` entity.

| JSON field | Dart field | Type | Notes |
|------------|-----------|------|-------|
| id | id | String | UUID string |
| full_name | fullName | String | snake_case in JSON |
| phone_number | phoneNumber | String? | nullable |
| role | role | UserRole | Stored as text in DB, serialized via custom converter |
| preferred_language | preferredLanguage | String | Default `'en'` |
| avatar_url | avatarUrl | String? | nullable |
| created_at | createdAt | DateTime | ISO 8601 from Supabase |
| updated_at | updatedAt | DateTime | ISO 8601 from Supabase |

**Code generation**: `freezed` + `json_serializable` with `@JsonSerializable(fieldRename: FieldRename.snake)`.

### CreateProfileParams

Simple class holding parameters for the `CreateUserProfile` use case.

| Field | Type | Notes |
|-------|------|-------|
| fullName | String | Required |
| phoneNumber | String? | Optional |
| preferredLanguage | String | Default `'en'` |

**Extends**: `Equatable`

## Relationships

```
auth.users (Supabase managed)
    │
    │  1:1
    ▼
profiles
    id ──FK──► auth.users.id
```

- One auth user has exactly zero or one profile.
- Zero profiles = first-time user (needs onboarding).
- One profile = returning user (go to dashboard).

## State Diagram: Auth Flow

```
                    ┌──────────────┐
       App Launch ──►  AuthInitial  │
                    └──────┬───────┘
                           │ check session
                    ┌──────▼───────┐
              ┌─────┤  AuthLoading  ├─────┐
              │     └──────────────┘      │
              │                           │
       no session                   valid session
              │                           │
    ┌─────────▼──────────┐    ┌──────────▼──────────┐
    │  Unauthenticated   │    │    fetch profile     │
    │  (show /welcome)   │    └──────────┬───────────┘
    └─────────┬──────────┘        ┌──────┴──────┐
              │                   │             │
        sign in tap          profile null   profile exists
              │                   │             │
    ┌─────────▼──────────┐  ┌────▼─────┐  ┌───▼──────────┐
    │  AuthLoading        │  │Authed    │  │ Authenticated │
    │  (sign-in flow)     │  │(no prof) │  │ (with prof)   │
    └─────────┬──────────┘  │→/profile- │  │ → /home       │
              │             │  setup    │  └───────────────┘
         success/fail       └────┬─────┘        ▲
              │                  │               │
         on success:        create profile ──────┘
         → fetch profile
         on fail:
         → AuthError → Unauthenticated
```

## Database Schema

### profiles table

See [contracts/supabase-migration.sql](contracts/supabase-migration.sql) for the complete DDL.

| Column | Type | Constraint |
|--------|------|-----------|
| id | uuid | PK, FK → auth.users.id ON DELETE CASCADE |
| full_name | text | NOT NULL |
| phone_number | text | nullable |
| role | user_role (enum) | NOT NULL, DEFAULT 'doctor' |
| preferred_language | text | NOT NULL, DEFAULT 'en', CHECK IN ('en', 'ar') |
| avatar_url | text | nullable |
| created_at | timestamptz | NOT NULL, DEFAULT now() |
| updated_at | timestamptz | NOT NULL, DEFAULT now() |

### RLS Policies

| Policy | Operation | Using / With Check |
|--------|-----------|-------------------|
| Users can read own profile | SELECT | `auth.uid() = id` |
| Users can insert own profile | INSERT | `auth.uid() = id` |
| Users can update own profile | UPDATE | `auth.uid() = id` |
| No delete (profiles are permanent) | — | No DELETE policy |
