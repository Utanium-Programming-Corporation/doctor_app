# Quickstart: Patient Management (005-patients)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Prerequisites

- 003-auth fully implemented (authentication + profile setup)
- 004-clinic-tenancy fully implemented (clinic creation/join, ClinicCubit at app root)
- A Supabase project with the 004-clinic-tenancy migration already applied
- Flutter SDK, Dart 3.8.0+

## Quick Setup

### 1. Apply Database Migration

Run the SQL in [`contracts/supabase-migration.sql`](contracts/supabase-migration.sql) in your Supabase SQL editor. This creates:
- `patients` table with all columns
- `patient_gender` enum type
- `generate_patient_number()` trigger function for auto-generating P-NNNN numbers
- Indexes for search and pagination performance
- RLS policies scoped to `staff_clinic_assignments`
- `updated_at` trigger

### 2. Run Code Generation

After creating the data layer files with freezed models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Verify DI Registration

Ensure `initPatient()` is called in `lib/core/di/injection_container.dart`:

```dart
await initPatient(); // after initClinic()
```

### 4. Verify Routes

Patient routes should be registered inside the home branch of the StatefulShellRoute:

- `/home/patients` → Patient list (paginated, searchable)
- `/home/patients/new` → Create patient form
- `/home/patients/:id` → Patient detail
- `/home/patients/:id/edit` → Edit patient form

### 5. Test Flow

1. Sign in → Create/join a clinic → Select clinic
2. Navigate to Home → Patients
3. Tap "+" to create a new patient
4. Fill required fields (first name, last name, DOB, phone)
5. Save → patient created with auto-generated P-NNNN number
6. Patient appears in list
7. Tap patient → detail screen
8. Tap "Edit" → edit form
9. Use search bar to find patients by name, phone, national ID, or patient number
10. Use global search icon in nav bar for cross-screen patient lookup

## Key Architecture Notes

- **Clinic scoping**: Every patient operation requires `clinicId`. Pages read `clinicId` from `context.read<ClinicCubit>().state.selectedClinicId`.
- **Two cubits**: `PatientListCubit` (list + pagination + search) and `PatientDetailCubit` (single patient CRUD). Scoped to their respective pages.
- **Form reuse**: `PatientFormPage` serves both create (no `patientId`) and edit (with `patientId`) modes.
- **No PHI in logs**: Patient data must not appear in debug output or error messages.
