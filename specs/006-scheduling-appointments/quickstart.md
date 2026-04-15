# Quickstart: Scheduling & Appointments

**Feature**: 006-scheduling-appointments
**Date**: 2026-04-12

## Prerequisites

1. Features 001–005 implemented (core, usecase-upgrade, auth, clinic-tenancy, patients)
2. Supabase project with `clinics`, `staff_assignments`, and `patients` tables
3. `build_runner` working for freezed code generation
4. `btree_gist` extension available in Supabase (standard — no action needed for hosted Supabase)

## Database Setup

Run the migration SQL from `contracts/supabase-migration.sql` in Supabase SQL Editor. This creates:
- `appointment_types` table with RLS
- `provider_availability` table with RLS
- `provider_blocked_dates` table with RLS + unique constraint
- `appointments` table with EXCLUDE constraint, triggers, and RLS

## Seed Data (Optional)

```sql
-- Insert sample appointment types for a clinic
INSERT INTO appointment_types (clinic_id, name, duration_minutes, color_hex, description)
VALUES
    ('<clinic_id>', 'General Consultation', 30, '#4A90D9', 'Standard doctor visit'),
    ('<clinic_id>', 'Follow-Up', 15, '#7ED321', 'Brief follow-up appointment'),
    ('<clinic_id>', 'Procedure', 60, '#FF5722', 'Medical procedure'),
    ('<clinic_id>', 'Extended Consultation', 45, '#9B59B6', 'Longer consultation');

-- Insert sample provider availability (Mon-Fri 9-13, 14-17)
INSERT INTO provider_availability (clinic_id, provider_id, day_of_week, start_time, end_time)
VALUES
    ('<clinic_id>', '<provider_user_id>', 1, '09:00', '13:00'),  -- Mon morning
    ('<clinic_id>', '<provider_user_id>', 1, '14:00', '17:00'),  -- Mon afternoon
    ('<clinic_id>', '<provider_user_id>', 2, '09:00', '13:00'),  -- Tue morning
    ('<clinic_id>', '<provider_user_id>', 2, '14:00', '17:00'),  -- Tue afternoon
    ('<clinic_id>', '<provider_user_id>', 3, '09:00', '13:00'),  -- Wed morning
    ('<clinic_id>', '<provider_user_id>', 3, '14:00', '17:00'),  -- Wed afternoon
    ('<clinic_id>', '<provider_user_id>', 4, '09:00', '13:00'),  -- Thu morning (half day)
    ('<clinic_id>', '<provider_user_id>', 5, '09:00', '13:00'),  -- Fri morning
    ('<clinic_id>', '<provider_user_id>', 5, '14:00', '17:00');  -- Fri afternoon
```

## Implementation Order

1. **Domain layer first**: Enums → Entities → Repository interfaces → Param classes → Use cases
2. **Data layer**: Models (freezed) → Data sources → Repository implementations → `build_runner`
3. **DI**: `scheduling_injection.dart` + register in `injection_container.dart`
4. **Routes**: Add route names + register routes in `app_router.dart`
5. **Presentation**: Cubits/states → Pages → Widgets (split at 100-line boundary)

## Key Integration Points

- **Patient search**: `BookAppointmentCubit` injects `SearchPatients` use case from 005-patients
- **Provider list**: Read from `ClinicCubit.state.staff` (List<StaffAssignment>) filtered by role == doctor
- **Current user**: `AuthCubit.state.userId` for "My Day" view provider filtering
- **Clinic context**: `ClinicCubit.state.selectedClinicId` for all clinic-scoped queries

## Verification

After implementation, verify:
1. Creating an appointment type and seeing it in the list
2. Setting provider availability for a day
3. Booking an appointment — slot computation shows correct available times
4. Double-booking prevention — second booking for overlapping time fails
5. "My Day" shows only the logged-in doctor's today appointments
6. Status transitions work: scheduled → confirmed → checked_in → in_progress → completed
7. Cancel with reason stores the reason
8. Reschedule cancels old and creates new appointment
