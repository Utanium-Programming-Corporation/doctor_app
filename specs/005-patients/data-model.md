# Data Model: Patient Management (005-patients)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Enums

### Gender

Domain-layer enum representing patient gender.

| Value | DB column value | Display |
|-------|----------------|---------|
| male | `'male'` | Male |
| female | `'female'` | Female |
| other | `'other'` | Other |

### BloodType

Domain-layer enum representing blood type.

| Value | DB column value | Display |
|-------|----------------|---------|
| aPositive | `'A+'` | A+ |
| aNegative | `'A-'` | A− |
| bPositive | `'B+'` | B+ |
| bNegative | `'B-'` | B− |
| abPositive | `'AB+'` | AB+ |
| abNegative | `'AB-'` | AB− |
| oPositive | `'O+'` | O+ |
| oNegative | `'O-'` | O− |

## Entities

### Patient

Pure Dart domain entity. No Flutter or Supabase imports.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | UUID primary key |
| clinicId | String | Yes | FK → clinics.id |
| patientNumber | String | Yes | Auto-generated, format P-NNNN, unique per clinic |
| firstName | String | Yes | Patient first name |
| lastName | String | Yes | Patient last name |
| dateOfBirth | DateTime | Yes | Date only (no time component) |
| gender | Gender? | No | From Gender enum |
| phoneNumber | String | Yes | Required, validated |
| email | String? | No | Optional, validated if present |
| nationalId | String? | No | Optional identification number |
| bloodType | BloodType? | No | Optional, from BloodType enum |
| address | String? | No | Optional, multiline |
| emergencyContactName | String? | No | Optional |
| emergencyContactPhone | String? | No | Optional |
| notes | String? | No | Optional, multiline, staff-facing |
| isActive | bool | Yes | Default: true. False = soft-deleted |
| createdAt | DateTime | Yes | Set on insert |
| updatedAt | DateTime | Yes | Set on insert and update |

**Extends**: `Equatable`

**Computed properties**:
- `fullName` → `'$firstName $lastName'`
- `age` → computed from `dateOfBirth` relative to current date (int, in years)

**Relationships**:
- Belongs to one `Clinic` (via `clinicId`)
- Future: Has many Appointments, Medical Records, Invoices (not implemented in this feature)

## Data Models

### PatientModel

Freezed data model in the data layer.

| JSON field | Dart field | Type | Notes |
|------------|-----------|------|-------|
| id | id | String | UUID |
| clinic_id | clinicId | String | FK → clinics.id |
| patient_number | patientNumber | String | Auto-generated |
| first_name | firstName | String | — |
| last_name | lastName | String | — |
| date_of_birth | dateOfBirth | DateTime | Date only |
| gender | gender | Gender? | Custom converter for enum ↔ string |
| phone_number | phoneNumber | String | — |
| email | email | String? | — |
| national_id | nationalId | String? | — |
| blood_type | bloodType | BloodType? | Custom converter for enum ↔ string (e.g., `'A+'`) |
| address | address | String? | — |
| emergency_contact_name | emergencyContactName | String? | — |
| emergency_contact_phone | emergencyContactPhone | String? | — |
| notes | notes | String? | — |
| is_active | isActive | bool | — |
| created_at | createdAt | DateTime | — |
| updated_at | updatedAt | DateTime | — |

**Extension method**: `toEntity()` → converts `PatientModel` to `Patient` entity.

## Repository Interface

### PatientRepository (Abstract)

| Method | Params | Return | Notes |
|--------|--------|--------|-------|
| createPatient | CreatePatientParams | FutureResult\<Patient\> | Inserts patient, returns record with auto-generated patient_number |
| updatePatient | UpdatePatientParams | FutureResult\<Patient\> | Updates by id, returns updated record |
| getPatientById | String id | FutureResult\<Patient\> | Single patient lookup |
| searchPatients | SearchPatientsParams | FutureResult\<List\<Patient\>\> | Multi-field ilike search, limited to 20 results |
| getPatientsList | GetPatientsListParams | FutureResult\<List\<Patient\>\> | Paginated list (offset-based, 20 per page) |
| deactivatePatient | String id | FutureResult\<void\> | Soft-delete (set is_active = false) |

### Parameter Classes

**CreatePatientParams**:
```
clinicId, firstName, lastName, dateOfBirth, phoneNumber,
gender?, email?, nationalId?, bloodType?, address?,
emergencyContactName?, emergencyContactPhone?, notes?
```

**UpdatePatientParams**:
```
id, firstName, lastName, dateOfBirth, phoneNumber,
gender?, email?, nationalId?, bloodType?, address?,
emergencyContactName?, emergencyContactPhone?, notes?
```

**SearchPatientsParams**:
```
clinicId, query (String)
```

**GetPatientsListParams**:
```
clinicId, page (int, default 0)
```

## Use Cases

| Use Case | Interface | Params → Return |
|----------|-----------|-----------------|
| CreatePatient | UseCaseWithParams\<Patient, CreatePatientParams\> | CreatePatientParams → FutureResult\<Patient\> |
| UpdatePatient | UseCaseWithParams\<Patient, UpdatePatientParams\> | UpdatePatientParams → FutureResult\<Patient\> |
| GetPatientById | UseCaseWithParams\<Patient, String\> | id → FutureResult\<Patient\> |
| SearchPatients | UseCaseWithParams\<List\<Patient\>, SearchPatientsParams\> | SearchPatientsParams → FutureResult\<List\<Patient\>\> |
| GetPatientsList | UseCaseWithParams\<List\<Patient\>, GetPatientsListParams\> | GetPatientsListParams → FutureResult\<List\<Patient\>\> |
| DeactivatePatient | UseCaseWithParams\<void, String\> | id → FutureResult\<void\> |

## State Definitions

### PatientListState (Sealed)

| State | Fields | Notes |
|-------|--------|-------|
| PatientListInitial | — | Before first load |
| PatientListLoading | — | Initial load in progress |
| PatientListLoaded | patients, page, hasMore, searchQuery? | Loaded with pagination metadata |
| PatientListError | message | Error during load/search |

### PatientDetailState (Sealed)

| State | Fields | Notes |
|-------|--------|-------|
| PatientDetailInitial | — | Before load |
| PatientDetailLoading | — | Loading/saving in progress |
| PatientDetailLoaded | patient | Single patient loaded |
| PatientDetailSaved | patient | After successful create/update |
| PatientDetailError | message | Error during operation |

## Validation Rules

| Field | Validators |
|-------|-----------|
| firstName | `AppValidators.required()` |
| lastName | `AppValidators.required()` |
| dateOfBirth | `AppValidators.required()`, `AppValidators.dateNotFuture()` (new) |
| phoneNumber | `AppValidators.compose([AppValidators.required(), AppValidators.phone()])` |
| email | `AppValidators.email()` (optional — only validates if non-empty) |
| emergencyContactPhone | `AppValidators.phone()` (optional) |
