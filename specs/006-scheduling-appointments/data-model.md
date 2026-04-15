# Data Model: Scheduling & Appointments

**Feature**: 006-scheduling-appointments
**Date**: 2026-04-12

## Entities

### AppointmentStatus (Enum)

| Value | DB Value | Display Name | Terminal? |
|-------|----------|-------------|-----------|
| scheduled | `scheduled` | Scheduled | No |
| confirmed | `confirmed` | Confirmed | No |
| checkedIn | `checked_in` | Checked In | No |
| inProgress | `in_progress` | In Progress | No |
| completed | `completed` | Completed | Yes |
| cancelled | `cancelled` | Cancelled | Yes |
| noShow | `no_show` | No-Show | Yes |

**Valid Transitions**:
- scheduled → {confirmed, cancelled, noShow}
- confirmed → {checkedIn, cancelled}
- checkedIn → {inProgress, cancelled}
- inProgress → {completed, cancelled}
- completed → {} (terminal)
- cancelled → {} (terminal)
- noShow → {} (terminal)

**Methods**:
- `canTransitionTo(AppointmentStatus target) → bool`
- `static fromDbValue(String) → AppointmentStatus`
- `toDbValue() → String`
- `displayName → String` (getter)
- `isTerminal → bool` (getter)

---

### AppointmentType (Entity — Equatable)

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | UUID from Supabase |
| clinicId | String | Yes | Clinic scope |
| name | String | Yes | e.g., "General Consultation" |
| durationMinutes | int | Yes | One of: 15, 30, 45, 60, 90, 120 |
| colorHex | String | Yes | e.g., "#FF5722" |
| description | String? | No | Optional description |
| isActive | bool | Yes | Default true |
| createdAt | DateTime | Yes | Auto-generated |

**Validation Rules**:
- name: required, minLength(2), maxLength(100)
- durationMinutes: must be one of [15, 30, 45, 60, 90, 120]
- colorHex: must match `#[0-9A-Fa-f]{6}` pattern

---

### ProviderAvailability (Entity — Equatable)

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | UUID from Supabase |
| clinicId | String | Yes | Clinic scope |
| providerId | String | Yes | FK to staff_assignments.user_id |
| dayOfWeek | int | Yes | 0 = Sunday, 1 = Monday, ..., 6 = Saturday |
| startTime | String | Yes | Time as "HH:mm" (e.g., "09:00") |
| endTime | String | Yes | Time as "HH:mm" (e.g., "17:00") |
| locationId | String? | No | Optional FK to clinic location |
| isActive | bool | Yes | Default true |

**Validation Rules**:
- dayOfWeek: 0–6 inclusive
- startTime must be before endTime
- No overlapping entries for the same provider + day (enforced at application level)

---

### BlockedDate (Entity — Equatable)

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | UUID from Supabase |
| clinicId | String | Yes | Clinic scope |
| providerId | String | Yes | FK to staff_assignments.user_id |
| blockedDate | DateTime | Yes | The blocked date (date only) |
| reason | String? | No | Optional reason |
| createdAt | DateTime | Yes | Auto-generated |

---

### Appointment (Entity — Equatable)

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | UUID from Supabase |
| clinicId | String | Yes | Clinic scope |
| patientId | String | Yes | FK to patients.id |
| providerId | String | Yes | FK to staff_assignments.user_id |
| appointmentTypeId | String | Yes | FK to appointment_types.id |
| locationId | String? | No | Optional FK to clinic location |
| startTime | DateTime | Yes | timestamptz |
| endTime | DateTime | Yes | timestamptz |
| status | AppointmentStatus | Yes | Default: scheduled |
| cancelReason | String? | No | Populated when cancelled |
| notes | String? | No | Free-text notes |
| createdBy | String | Yes | User ID of who created it |
| createdAt | DateTime | Yes | Auto-generated |
| updatedAt | DateTime | Yes | Auto-updated |
| patientName | String? | No | Denormalized from join (read-only, not stored) |
| appointmentTypeName | String? | No | Denormalized from join (read-only, not stored) |
| appointmentTypeColor | String? | No | Denormalized from join (read-only, not stored) |
| providerName | String? | No | Denormalized from join (read-only, not stored) |

**Computed properties**:
- `durationMinutes → int` (endTime - startTime in minutes)
- `isEditable → bool` (!status.isTerminal)
- `canCancel → bool` (status != completed && !status.isTerminal)

**Note on denormalized fields**: The `patientName`, `appointmentTypeName`, `appointmentTypeColor`, and `providerName` fields are populated from Supabase joins in the data layer queries (using `.select('*, patients(first_name, last_name), appointment_types(name, color_hex), ...')`). They are not stored in the appointments table. The entity carries them for display purposes.

---

### TimeSlot (Value Object — Equatable)

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| startTime | DateTime | Yes | Slot start |
| endTime | DateTime | Yes | Slot end |

**Computed properties**:
- `durationMinutes → int`
- `formattedTimeRange → String` (e.g., "09:00 – 09:30")

**Note**: TimeSlot is computed at runtime, never persisted. It represents an available booking window.

---

## Relationships

```
clinic (1) ──── (N) appointment_types
clinic (1) ──── (N) provider_availability
clinic (1) ──── (N) appointments
clinic (1) ──── (N) provider_blocked_dates

staff_assignment/user (1) ──── (N) provider_availability
staff_assignment/user (1) ──── (N) appointments (as provider)
staff_assignment/user (1) ──── (N) provider_blocked_dates

patient (1) ──── (N) appointments

appointment_type (1) ──── (N) appointments
```

## Data Models (freezed)

### AppointmentTypeModel

Maps to `appointment_types` table. JsonKey mappings:
- `id` → `id`
- `clinicId` → `clinic_id`
- `name` → `name`
- `durationMinutes` → `duration_minutes`
- `colorHex` → `color_hex`
- `description` → `description`
- `isActive` → `is_active`
- `createdAt` → `created_at`

Extension: `toEntity() → AppointmentType`

### ProviderAvailabilityModel

Maps to `provider_availability` table. JsonKey mappings:
- `id` → `id`
- `clinicId` → `clinic_id`
- `providerId` → `provider_id`
- `dayOfWeek` → `day_of_week`
- `startTime` → `start_time` (stored as PostgreSQL `time`, serialized as "HH:mm:ss")
- `endTime` → `end_time`
- `locationId` → `location_id`
- `isActive` → `is_active`

Extension: `toEntity() → ProviderAvailability`

### BlockedDateModel

Maps to `provider_blocked_dates` table. JsonKey mappings:
- `id` → `id`
- `clinicId` → `clinic_id`
- `providerId` → `provider_id`
- `blockedDate` → `blocked_date`
- `reason` → `reason`
- `createdAt` → `created_at`

Extension: `toEntity() → BlockedDate`

### AppointmentModel

Maps to `appointments` table. JsonKey mappings:
- `id` → `id`
- `clinicId` → `clinic_id`
- `patientId` → `patient_id`
- `providerId` → `provider_id`
- `appointmentTypeId` → `appointment_type_id`
- `locationId` → `location_id`
- `startTime` → `start_time`
- `endTime` → `end_time`
- `status` → `status` (uses AppointmentStatusConverter)
- `cancelReason` → `cancel_reason`
- `notes` → `notes`
- `createdBy` → `created_by`
- `createdAt` → `created_at`
- `updatedAt` → `updated_at`

The model also extracts joined data from nested JSON for denormalized display fields:
- `patients.first_name` + `patients.last_name` → `patientName`
- `appointment_types.name` → `appointmentTypeName`
- `appointment_types.color_hex` → `appointmentTypeColor`

Extension: `toEntity() → Appointment`

## Repository Interfaces

### AppointmentRepository

```
abstract interface class AppointmentRepository {
  FutureResult<Appointment> createAppointment(CreateAppointmentParams params);
  FutureResult<Appointment> getAppointmentById(String id);
  FutureResult<List<Appointment>> getAppointmentsForDate(GetAppointmentsForDateParams params);
  FutureResult<List<Appointment>> getMyAppointmentsToday(GetMyAppointmentsTodayParams params);
  FutureResult<Appointment> updateAppointmentStatus(UpdateAppointmentStatusParams params);
  FutureResult<void> cancelAppointment(CancelAppointmentParams params);
  FutureResult<Appointment> rescheduleAppointment(RescheduleAppointmentParams params);
}
```

### AvailabilityRepository

```
abstract interface class AvailabilityRepository {
  FutureResult<List<AppointmentType>> getAppointmentTypes(String clinicId);
  FutureResult<AppointmentType> createAppointmentType(CreateAppointmentTypeParams params);
  FutureResult<AppointmentType> updateAppointmentType(UpdateAppointmentTypeParams params);
  FutureResult<List<ProviderAvailability>> getProviderAvailability(GetProviderAvailabilityParams params);
  FutureResult<List<ProviderAvailability>> setProviderAvailability(SetProviderAvailabilityParams params);
  FutureResult<List<BlockedDate>> getBlockedDates(GetProviderAvailabilityParams params);
  FutureResult<BlockedDate> addBlockedDate(AddBlockedDateParams params);
  FutureResult<void> removeBlockedDate(String id);
  FutureResult<List<TimeSlot>> getAvailableSlots(GetAvailableSlotsParams params);
}
```

## Param Classes (all Equatable)

| Param Class | Fields |
|-------------|--------|
| CreateAppointmentParams | clinicId, patientId, providerId, appointmentTypeId, locationId?, startTime, endTime, notes?, createdBy |
| CancelAppointmentParams | appointmentId, reason? |
| RescheduleAppointmentParams | appointmentId, newStartTime, newEndTime, reason? |
| UpdateAppointmentStatusParams | appointmentId, newStatus |
| GetAppointmentsForDateParams | clinicId, date, providerId? |
| GetMyAppointmentsTodayParams | clinicId, providerId |
| CreateAppointmentTypeParams | clinicId, name, durationMinutes, colorHex, description?, isActive |
| UpdateAppointmentTypeParams | id, name?, durationMinutes?, colorHex?, description?, isActive? |
| GetProviderAvailabilityParams | clinicId, providerId |
| SetProviderAvailabilityParams | clinicId, providerId, entries (List of {dayOfWeek, startTime, endTime, locationId?, isActive}) |
| AddBlockedDateParams | clinicId, providerId, blockedDate, reason? |
| GetAvailableSlotsParams | clinicId, providerId, date, appointmentTypeId |
