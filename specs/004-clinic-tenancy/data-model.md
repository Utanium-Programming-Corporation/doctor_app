# Data Model: Clinic & Multi-Tenant Setup (004-clinic-tenancy)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Entities

### ClinicType (Enum)

Domain-layer enum representing supported clinic specializations.

| Value | DB column value |
|-------|----------------|
| generalPractice | `'general_practice'` |
| dental | `'dental'` |
| dermatology | `'dermatology'` |
| pediatrics | `'pediatrics'` |
| orthopedics | `'orthopedics'` |
| ophthalmology | `'ophthalmology'` |
| cardiology | `'cardiology'` |
| multiSpecialty | `'multi_specialty'` |
| other | `'other'` |

### StaffRole (Enum)

Domain-layer enum representing a user's role within a specific clinic. Separate from `UserRole` in auth.

| Value | DB column value |
|-------|----------------|
| clinicAdmin | `'clinic_admin'` |
| doctor | `'doctor'` |
| receptionist | `'receptionist'` |
| nurse | `'nurse'` |
| other | `'other'` |

### Clinic

Pure Dart domain entity. No Flutter or Supabase imports.

| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID primary key |
| name | String | Required, clinic display name |
| phone | String | Required, clinic contact phone |
| address | String | Required, clinic physical address |
| type | ClinicType | Required, from enum |
| inviteCode | String | 8-char uppercase alphanumeric, unique |
| isActive | bool | Default: true |
| createdAt | DateTime | Set on insert |
| updatedAt | DateTime | Set on insert and update |

**Extends**: `Equatable`

### StaffAssignment

Pure Dart domain entity. Represents the relationship between a user and a clinic.

| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID primary key |
| userId | String | FK → profiles.id |
| clinicId | String | FK → clinics.id |
| role | StaffRole | From enum. Default for joiners: `doctor` |
| isActive | bool | Default: true |
| joinedAt | DateTime | When user was added to clinic |
| updatedAt | DateTime | Set on insert and update |
| userName | String? | Denormalized from profiles for display (nullable, populated by JOIN query) |

**Extends**: `Equatable`

### Location

Pure Dart domain entity. Represents a physical location of a clinic.

| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID primary key |
| clinicId | String | FK → clinics.id |
| name | String | Location name (default: "Main") |
| address | String | Location address |
| phone | String | Location phone |
| isActive | bool | Default: true |
| createdAt | DateTime | Set on insert |
| updatedAt | DateTime | Set on insert and update |

**Extends**: `Equatable`

## Data Models

### ClinicModel

Freezed data model in the data layer.

| JSON field | Dart field | Type | Notes |
|------------|-----------|------|-------|
| id | id | String | UUID |
| name | name | String | — |
| phone | phone | String | — |
| address | address | String | — |
| type | type | ClinicType | Custom converter for enum ↔ snake_case string |
| invite_code | inviteCode | String | — |
| is_active | isActive | bool | Default: true |
| created_at | createdAt | DateTime | ISO 8601 |
| updated_at | updatedAt | DateTime | ISO 8601 |

**Code generation**: `freezed` + `json_serializable` with `@JsonSerializable(fieldRename: FieldRename.snake)`.

**Conversion**: `ClinicModel` has a `toEntity()` method returning `Clinic` and a `ClinicModel.fromEntity(Clinic)` factory.

### StaffAssignmentModel

Freezed data model in the data layer.

| JSON field | Dart field | Type | Notes |
|------------|-----------|------|-------|
| id | id | String | UUID |
| user_id | userId | String | FK |
| clinic_id | clinicId | String | FK |
| role | role | StaffRole | Custom converter |
| is_active | isActive | bool | Default: true |
| joined_at | joinedAt | DateTime | ISO 8601 |
| updated_at | updatedAt | DateTime | ISO 8601 |
| user_name | userName | String? | From JOIN, nullable |

**Code generation**: Same as ClinicModel.

### LocationModel

Freezed data model in the data layer.

| JSON field | Dart field | Type | Notes |
|------------|-----------|------|-------|
| id | id | String | UUID |
| clinic_id | clinicId | String | FK |
| name | name | String | — |
| address | address | String | — |
| phone | phone | String | — |
| is_active | isActive | bool | Default: true |
| created_at | createdAt | DateTime | ISO 8601 |
| updated_at | updatedAt | DateTime | ISO 8601 |

**Code generation**: Same as ClinicModel.

## Use Case Parameter Objects

### CreateClinicParams

| Field | Type | Notes |
|-------|------|-------|
| name | String | Clinic name |
| phone | String | Clinic phone |
| address | String | Clinic address |
| type | ClinicType | Clinic type enum value |

**Extends**: `Equatable`

### JoinClinicByCodeParams

| Field | Type | Notes |
|-------|------|-------|
| inviteCode | String | 8-char code entered by user |

**Extends**: `Equatable`

### UpdateClinicParams

| Field | Type | Notes |
|-------|------|-------|
| clinicId | String | Target clinic ID |
| name | String | Updated name |
| phone | String | Updated phone |
| address | String | Updated address |
| type | ClinicType | Updated type |

**Extends**: `Equatable`

### UpdateStaffRoleParams

| Field | Type | Notes |
|-------|------|-------|
| assignmentId | String | staff_clinic_assignments.id |
| newRole | StaffRole | New role value |

**Extends**: `Equatable`

### DeactivateStaffParams

| Field | Type | Notes |
|-------|------|-------|
| assignmentId | String | staff_clinic_assignments.id |

**Extends**: `Equatable`

### RegenerateInviteCodeParams

| Field | Type | Notes |
|-------|------|-------|
| clinicId | String | Target clinic ID |

**Extends**: `Equatable`

### GetClinicStaffParams

| Field | Type | Notes |
|-------|------|-------|
| clinicId | String | Target clinic ID |

**Extends**: `Equatable`

## Repository Interface

```dart
abstract interface class ClinicRepository {
  FutureResult<Clinic> createClinic(CreateClinicParams params);
  FutureResult<StaffAssignment> joinClinicByCode(JoinClinicByCodeParams params);
  FutureResult<List<StaffAssignment>> getMyClinicAssignments();
  FutureResult<List<StaffAssignment>> getClinicStaff(GetClinicStaffParams params);
  FutureResult<Clinic> updateClinic(UpdateClinicParams params);
  FutureResult<StaffAssignment> updateStaffRole(UpdateStaffRoleParams params);
  FutureResult<void> deactivateStaff(DeactivateStaffParams params);
  FutureResult<Clinic> regenerateInviteCode(RegenerateInviteCodeParams params);
}
```

## Use Case Mapping

| Use Case | Interface | Input | Output |
|----------|-----------|-------|--------|
| CreateClinic | UseCaseWithParams<Clinic, CreateClinicParams> | CreateClinicParams | Clinic |
| JoinClinicByCode | UseCaseWithParams<StaffAssignment, JoinClinicByCodeParams> | JoinClinicByCodeParams | StaffAssignment |
| GetMyClinicAssignments | UseCaseWithoutParams<List<StaffAssignment>> | — | List<StaffAssignment> |
| GetClinicStaff | UseCaseWithParams<List<StaffAssignment>, GetClinicStaffParams> | GetClinicStaffParams | List<StaffAssignment> |
| UpdateClinic | UseCaseWithParams<Clinic, UpdateClinicParams> | UpdateClinicParams | Clinic |
| UpdateStaffRole | UseCaseWithParams<StaffAssignment, UpdateStaffRoleParams> | UpdateStaffRoleParams | StaffAssignment |
| DeactivateStaff | UseCaseWithParams<void, DeactivateStaffParams> | DeactivateStaffParams | void |
| RegenerateInviteCode | UseCaseWithParams<Clinic, RegenerateInviteCodeParams> | RegenerateInviteCodeParams | Clinic |

## Relationships

```
profiles (from 003-auth)
    │
    └── staff_clinic_assignments (M:N bridge)
            │
            ├── clinics
            │      │
            │      └── locations (1:N)
            │
            └── role (staff_role_type enum)
```

- A **profile** can have many **staff_clinic_assignments** (multi-clinic support).
- A **clinic** can have many **staff_clinic_assignments** (multiple staff).
- A **clinic** can have many **locations** (one default auto-created).
- The `staff_clinic_assignments.role` is independent of `profiles.role`.
