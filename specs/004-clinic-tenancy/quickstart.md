# Quickstart: Clinic & Multi-Tenant Setup (004-clinic-tenancy)

**Date**: 2026-04-12
**Feature**: [spec.md](spec.md) | [plan.md](plan.md) | [data-model.md](data-model.md)

## Prerequisites

- 003-auth fully implemented (AuthCubit, profiles table, GoRouter auth redirects)
- Supabase migration from `contracts/supabase-migration.sql` applied
- AppFormField and AppValidators available in `core/theme/components/`

## File Creation Order

Files are ordered by dependency — each file only depends on files above it.

### Phase 1: Domain Layer (pure Dart, no Flutter imports)

| # | File | Action | Description |
|---|------|--------|-------------|
| 1 | `lib/features/clinic/domain/entities/clinic_type.dart` | CREATE | ClinicType enum with dbValue getter and fromDbValue factory |
| 2 | `lib/features/clinic/domain/entities/staff_role.dart` | CREATE | StaffRole enum with dbValue getter and fromDbValue factory |
| 3 | `lib/features/clinic/domain/entities/clinic.dart` | CREATE | Clinic entity (Equatable) with all fields from data-model |
| 4 | `lib/features/clinic/domain/entities/staff_assignment.dart` | CREATE | StaffAssignment entity (Equatable) with all fields |
| 5 | `lib/features/clinic/domain/entities/location.dart` | CREATE | Location entity (Equatable) with all fields |
| 6 | `lib/features/clinic/domain/repositories/clinic_repository.dart` | CREATE | Abstract ClinicRepository interface with 8 methods |
| 7 | `lib/features/clinic/domain/usecases/create_clinic.dart` | CREATE | UseCaseWithParams<Clinic, CreateClinicParams> |
| 8 | `lib/features/clinic/domain/usecases/join_clinic_by_code.dart` | CREATE | UseCaseWithParams<StaffAssignment, JoinClinicByCodeParams> |
| 9 | `lib/features/clinic/domain/usecases/get_my_clinic_assignments.dart` | CREATE | UseCaseWithoutParams<List<StaffAssignment>> |
| 10 | `lib/features/clinic/domain/usecases/get_clinic_staff.dart` | CREATE | UseCaseWithParams<List<StaffAssignment>, GetClinicStaffParams> |
| 11 | `lib/features/clinic/domain/usecases/update_clinic.dart` | CREATE | UseCaseWithParams<Clinic, UpdateClinicParams> |
| 12 | `lib/features/clinic/domain/usecases/update_staff_role.dart` | CREATE | UseCaseWithParams<StaffAssignment, UpdateStaffRoleParams> |
| 13 | `lib/features/clinic/domain/usecases/deactivate_staff.dart` | CREATE | UseCaseWithParams<void, DeactivateStaffParams> |
| 14 | `lib/features/clinic/domain/usecases/regenerate_invite_code.dart` | CREATE | UseCaseWithParams<Clinic, RegenerateInviteCodeParams> |

### Phase 2: Data Layer

| # | File | Action | Description |
|---|------|--------|-------------|
| 15 | `lib/features/clinic/data/models/clinic_model.dart` | CREATE | Freezed model with toEntity(), fromEntity(), JSON serialization |
| 16 | `lib/features/clinic/data/models/staff_assignment_model.dart` | CREATE | Freezed model with toEntity(), fromEntity(), JSON serialization |
| 17 | `lib/features/clinic/data/models/location_model.dart` | CREATE | Freezed model with toEntity(), fromEntity(), JSON serialization |
| 18 | `lib/features/clinic/data/datasources/clinic_remote_data_source.dart` | CREATE | Abstract + impl with Supabase queries and RPC calls |
| 19 | `lib/features/clinic/data/repositories/clinic_repository_impl.dart` | CREATE | ClinicRepositoryImpl catching exceptions, mapping to Failure |

### Phase 3: Presentation Layer

| # | File | Action | Description |
|---|------|--------|-------------|
| 20 | `lib/features/clinic/presentation/cubit/clinic_state.dart` | CREATE | Sealed class: ClinicInitial, ClinicLoading, ClinicLoaded, ClinicError |
| 21 | `lib/features/clinic/presentation/cubit/clinic_cubit.dart` | CREATE | ClinicCubit with loadAssignments, selectClinic, createClinic, joinClinic, etc. |
| 22 | `lib/features/clinic/presentation/cubit/clinic_cubit_refresh_listenable.dart` | CREATE | ChangeNotifier bridge for GoRouter (same pattern as auth) |
| 23 | `lib/features/clinic/presentation/pages/clinic_or_join_page.dart` | CREATE | Choice screen: "Create Clinic" or "Join Clinic" buttons |
| 24 | `lib/features/clinic/presentation/pages/create_clinic_page.dart` | CREATE | Form: name, phone, address, type dropdown. Uses AppFormField |
| 25 | `lib/features/clinic/presentation/pages/join_clinic_page.dart` | CREATE | Invite code input + confirmation. Uses AppFormField |
| 26 | `lib/features/clinic/presentation/pages/clinic_selector_page.dart` | CREATE | List of user's clinics, tap to select |
| 27 | `lib/features/clinic/presentation/pages/clinic_settings_page.dart` | CREATE | Editable clinic details + regenerate invite code |
| 28 | `lib/features/clinic/presentation/pages/staff_list_page.dart` | CREATE | Staff list with role change and deactivate actions |
| 29 | `lib/features/clinic/presentation/pages/widgets/clinic_type_dropdown.dart` | CREATE | Dropdown widget for clinic type selection |
| 30 | `lib/features/clinic/presentation/pages/widgets/clinic_card.dart` | CREATE | Clinic display card for selector page |
| 31 | `lib/features/clinic/presentation/pages/widgets/staff_member_tile.dart` | CREATE | Staff member list tile with role + actions |
| 32 | `lib/features/clinic/presentation/pages/widgets/role_selector_dialog.dart` | CREATE | Dialog for changing staff role |

### Phase 4: Integration

| # | File | Action | Description |
|---|------|--------|-------------|
| 33 | `lib/features/clinic/di/clinic_injection.dart` | CREATE | initClinic() registering all data sources, repos, use cases, cubit |
| 34 | `lib/core/di/injection_container.dart` | MODIFY | Add `import` and `await initClinic()` call |
| 35 | `lib/core/router/route_names.dart` | MODIFY | Add clinicSetup, clinicSelector, createClinic, joinClinic, clinicSettings, staffList |
| 36 | `lib/core/router/app_router.dart` | MODIFY | Add ClinicCubit dependency, clinic routes, extend redirect logic, merge listenables |
| 37 | `lib/app.dart` | MODIFY | Replace BlocProvider with MultiBlocProvider (AuthCubit + ClinicCubit) |

### Phase 5: Code Generation

| # | Command | Description |
|---|---------|-------------|
| 38 | `dart run build_runner build --delete-conflicting-outputs` | Generate .freezed.dart and .g.dart for models |

### Phase 6: Verification

| # | Command | Description |
|---|---------|-------------|
| 39 | `flutter analyze` | Zero errors, zero warnings |

## Total Files

- **CREATE**: 32 new files
- **MODIFY**: 4 existing files
- **GENERATE**: 6 files (3 × .freezed.dart + 3 × .g.dart via build_runner)
