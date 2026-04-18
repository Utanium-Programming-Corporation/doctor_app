# Data Model: Queue & Check-In System

**Feature**: 007-queue-checkin
**Date**: 2026-04-12

## Entity Relationship Overview

```
┌──────────────┐     ┌──────────────────┐     ┌─────────────────────┐
│  Appointment │────▶│   QueueToken     │◀────│  TriageAssessment   │
│ (scheduling) │ 1:1 │                  │ 1:1 │                     │
└──────────────┘     └──────────────────┘     └─────────────────────┘
       ▲                     │
       │                     │
┌──────────────┐     ┌──────────────────┐
│   Patient    │◀────│    Provider      │
│  (patient)   │     │  (clinic staff)  │
└──────────────┘     └──────────────────┘
```

## Entities

### QueueToken

Represents a patient's position and status in the clinic waiting queue.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK | Unique identifier |
| clinicId | String (UUID) | NOT NULL, FK → clinics | Clinic this token belongs to |
| locationId | String (UUID)? | FK → locations | Optional location within clinic (future use) |
| tokenNumber | int | NOT NULL | Daily auto-incremented number per clinic |
| patientId | String (UUID) | NOT NULL, FK → patients | Patient being queued |
| appointmentId | String (UUID)? | FK → appointments | Linked appointment (nullable for walk-ins that failed appointment creation) |
| providerId | String (UUID) | NOT NULL, FK → profiles | Assigned provider/doctor |
| status | QueueTokenStatus | NOT NULL, default: waiting | Current queue status |
| priority | QueuePriority | NOT NULL, default: normal | Token priority level |
| skipCount | int | NOT NULL, default: 0 | Number of times skipped (affects ordering) |
| calledAt | DateTime? | | When provider called this token |
| startedAt | DateTime? | | When consultation started |
| completedAt | DateTime? | | When consultation completed |
| createdAt | DateTime | NOT NULL, default: now | Check-in timestamp |

**Validation Rules**:
- tokenNumber must be ≥ 1
- calledAt must be null when status is `waiting`
- startedAt must be null when status is `waiting` or `called`
- completedAt must be null unless status is `completed`

**State Transitions**:
```
waiting → called         (calledAt set)
waiting → skipped        (skipCount incremented)
called  → in_progress    (startedAt set)
called  → no_show        (terminal)
called  → skipped        (skipCount incremented, status → skipped)
in_progress → completed  (completedAt set)
skipped → waiting        (re-queued, skipCount preserved)
```

### QueueTokenStatus (Enum)

```
waiting | called | in_progress | completed | no_show | skipped
```

### QueuePriority (Enum)

```
normal | urgent
```

### TriageAssessment

Optional vitals recorded during patient check-in.

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String (UUID) | PK | Unique identifier |
| queueTokenId | String (UUID) | NOT NULL, UNIQUE, FK → queue_tokens | Linked queue token (1:1) |
| clinicId | String (UUID) | NOT NULL, FK → clinics | Clinic (for RLS) |
| bloodPressureSystolic | int? | | Systolic BP (mmHg) |
| bloodPressureDiastolic | int? | | Diastolic BP (mmHg) |
| heartRate | int? | | Heart rate (bpm) |
| temperature | double? | | Temperature (°C) |
| weight | double? | | Weight (kg) |
| spo2 | int? | | Oxygen saturation (%) |
| chiefComplaint | String? | | Patient's presenting complaint |
| recordedBy | String (UUID) | NOT NULL, FK → profiles | Staff who recorded vitals |
| createdAt | DateTime | NOT NULL, default: now | Recording timestamp |

**Validation Rules**:
- bloodPressureSystolic: 50–300 (if provided)
- bloodPressureDiastolic: 20–200 (if provided)
- heartRate: 20–300 (if provided)
- temperature: 30.0–45.0 (if provided)
- weight: 0.5–500.0 (if provided)
- spo2: 0–100 (if provided)
- chiefComplaint: max 500 characters (if provided)

## Database Tables

### queue_tokens

```sql
CREATE TABLE queue_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  location_id UUID REFERENCES locations(id),
  token_number INTEGER NOT NULL,
  patient_id UUID NOT NULL REFERENCES patients(id),
  appointment_id UUID REFERENCES appointments(id),
  provider_id UUID NOT NULL REFERENCES profiles(id),
  status TEXT NOT NULL DEFAULT 'waiting'
    CHECK (status IN ('waiting','called','in_progress','completed','no_show','skipped')),
  priority TEXT NOT NULL DEFAULT 'normal'
    CHECK (priority IN ('normal','urgent')),
  skip_count INTEGER NOT NULL DEFAULT 0,
  called_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Prevent duplicate check-ins for the same appointment
  UNIQUE (appointment_id) WHERE appointment_id IS NOT NULL
);

CREATE INDEX idx_queue_tokens_clinic_date ON queue_tokens (clinic_id, (created_at::date));
CREATE INDEX idx_queue_tokens_provider_status ON queue_tokens (provider_id, status);
CREATE INDEX idx_queue_tokens_clinic_status ON queue_tokens (clinic_id, status);
```

### triage_assessments

```sql
CREATE TABLE triage_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_token_id UUID NOT NULL UNIQUE REFERENCES queue_tokens(id) ON DELETE CASCADE,
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  blood_pressure_systolic INTEGER,
  blood_pressure_diastolic INTEGER,
  heart_rate INTEGER,
  temperature NUMERIC(4,1),
  weight NUMERIC(5,1),
  spo2 INTEGER,
  chief_complaint TEXT,
  recorded_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_triage_queue_token ON triage_assessments (queue_token_id);
```

### Postgres Function: Token Auto-Increment

```sql
CREATE OR REPLACE FUNCTION generate_queue_token_number(p_clinic_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  next_number INTEGER;
BEGIN
  -- Lock rows for this clinic today to prevent race conditions
  PERFORM 1 FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND created_at::date = CURRENT_DATE
  FOR UPDATE;

  SELECT COALESCE(MAX(token_number), 0) + 1
  INTO next_number
  FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND created_at::date = CURRENT_DATE;

  RETURN next_number;
END;
$$;
```

### Postgres Function: Check-In RPC

```sql
CREATE OR REPLACE FUNCTION check_in_patient(
  p_clinic_id UUID,
  p_patient_id UUID,
  p_appointment_id UUID,
  p_provider_id UUID,
  p_priority TEXT DEFAULT 'normal',
  p_location_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_token_number INTEGER;
  v_token_id UUID;
  v_result JSONB;
BEGIN
  -- Check for duplicate check-in
  IF p_appointment_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM queue_tokens
      WHERE appointment_id = p_appointment_id
    ) THEN
      RAISE EXCEPTION 'Appointment already checked in';
    END IF;
  END IF;

  -- Generate token number
  v_token_number := generate_queue_token_number(p_clinic_id);

  -- Insert queue token
  INSERT INTO queue_tokens (
    clinic_id, location_id, token_number, patient_id,
    appointment_id, provider_id, status, priority
  ) VALUES (
    p_clinic_id, p_location_id, v_token_number, p_patient_id,
    p_appointment_id, p_provider_id, 'waiting', p_priority
  )
  RETURNING id INTO v_token_id;

  -- Update appointment status to checked_in
  IF p_appointment_id IS NOT NULL THEN
    UPDATE appointments
    SET status = 'checked_in', updated_at = now()
    WHERE id = p_appointment_id;
  END IF;

  -- Return result
  SELECT jsonb_build_object(
    'token_id', v_token_id,
    'token_number', v_token_number
  ) INTO v_result;

  RETURN v_result;
END;
$$;
```

### RLS Policies

```sql
-- queue_tokens
ALTER TABLE queue_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view queue tokens for their clinic"
  ON queue_tokens FOR SELECT
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can insert queue tokens for their clinic"
  ON queue_tokens FOR INSERT
  WITH CHECK (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can update queue tokens for their clinic"
  ON queue_tokens FOR UPDATE
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

-- triage_assessments
ALTER TABLE triage_assessments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view triage for their clinic"
  ON triage_assessments FOR SELECT
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can insert triage for their clinic"
  ON triage_assessments FOR INSERT
  WITH CHECK (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));
```

### Supabase Realtime

Enable realtime on `queue_tokens`:
```sql
ALTER PUBLICATION supabase_realtime ADD TABLE queue_tokens;
```

## Data Layer Mapping

### QueueTokenModel (freezed)

```dart
@freezed
abstract class QueueTokenModel with _$QueueTokenModel {
  const factory QueueTokenModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'location_id') String? locationId,
    @JsonKey(name: 'token_number') required int tokenNumber,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'appointment_id') String? appointmentId,
    @JsonKey(name: 'provider_id') required String providerId,
    @_QueueTokenStatusConverter() @Default(QueueTokenStatus.waiting) QueueTokenStatus status,
    @_QueuePriorityConverter() @Default(QueuePriority.normal) QueuePriority priority,
    @JsonKey(name: 'skip_count') @Default(0) int skipCount,
    @JsonKey(name: 'called_at') DateTime? calledAt,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Denormalized join fields
    @JsonKey(includeToJson: false) String? patientName,
    @JsonKey(includeToJson: false) String? providerName,
  }) = _QueueTokenModel;

  factory QueueTokenModel.fromJson(Map<String, dynamic> json) =>
      _$QueueTokenModelFromJson(json);
}
```

### TriageAssessmentModel (freezed)

```dart
@freezed
abstract class TriageAssessmentModel with _$TriageAssessmentModel {
  const factory TriageAssessmentModel({
    required String id,
    @JsonKey(name: 'queue_token_id') required String queueTokenId,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'blood_pressure_systolic') int? bloodPressureSystolic,
    @JsonKey(name: 'blood_pressure_diastolic') int? bloodPressureDiastolic,
    @JsonKey(name: 'heart_rate') int? heartRate,
    double? temperature,
    double? weight,
    int? spo2,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'recorded_by') required String recordedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TriageAssessmentModel;

  factory TriageAssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$TriageAssessmentModelFromJson(json);
}
```

## Cross-Feature Dependencies

| Dependency | Source Feature | Injected As | Used For |
|------------|--------------|-------------|----------|
| UpdateAppointmentStatus | scheduling | Use case via GetIt | Transition appointment → checked_in |
| CreateAppointment | scheduling | Use case via GetIt | Walk-in appointment creation |
| SearchPatients | patient | Use case via GetIt | Patient lookup for walk-in check-in |
| ClinicCubit | clinic | BlocProvider (inherited) | Current clinic_id context |
| AuthCubit | auth | BlocProvider (inherited) | Current user_id for recorded_by |
