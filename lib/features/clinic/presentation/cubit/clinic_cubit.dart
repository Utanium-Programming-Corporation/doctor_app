import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/clinic_repository.dart';
import '../../domain/usecases/create_clinic.dart';
import '../../domain/usecases/deactivate_staff.dart';
import '../../domain/usecases/get_clinic_by_invite_code.dart';
import '../../domain/usecases/get_clinic_staff.dart';
import '../../domain/usecases/get_my_clinic_assignments.dart';
import '../../domain/usecases/join_clinic_by_code.dart';
import '../../domain/usecases/regenerate_invite_code.dart';
import '../../domain/usecases/update_clinic.dart';
import '../../domain/usecases/update_staff_role.dart';
import 'clinic_state.dart';

class ClinicCubit extends Cubit<ClinicState> {
  final CreateClinic _createClinic;
  final GetMyClinicAssignments _getMyClinicAssignments;
  final JoinClinicByCode _joinClinicByCode;
  final GetClinicByInviteCode _getClinicByInviteCode;
  final UpdateClinic _updateClinic;
  final RegenerateInviteCode _regenerateInviteCode;
  final GetClinicStaff _getClinicStaff;
  final UpdateStaffRole _updateStaffRole;
  final DeactivateStaff _deactivateStaff;

  ClinicCubit({
    required CreateClinic createClinic,
    required GetMyClinicAssignments getMyClinicAssignments,
    required JoinClinicByCode joinClinicByCode,
    required GetClinicByInviteCode getClinicByInviteCode,
    required UpdateClinic updateClinic,
    required RegenerateInviteCode regenerateInviteCode,
    required GetClinicStaff getClinicStaff,
    required UpdateStaffRole updateStaffRole,
    required DeactivateStaff deactivateStaff,
  })  : _createClinic = createClinic,
        _getMyClinicAssignments = getMyClinicAssignments,
        _joinClinicByCode = joinClinicByCode,
        _getClinicByInviteCode = getClinicByInviteCode,
        _updateClinic = updateClinic,
        _regenerateInviteCode = regenerateInviteCode,
        _getClinicStaff = getClinicStaff,
        _updateStaffRole = updateStaffRole,
        _deactivateStaff = deactivateStaff,
        super(const ClinicInitial());

  Future<void> loadAssignments() async {
    emit(const ClinicLoading());
    final result = await _getMyClinicAssignments();
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (assignments) {
        if (assignments.length == 1) {
          emit(ClinicLoaded(
            assignments: assignments,
            selectedClinicId: assignments.first.clinicId,
          ));
        } else {
          emit(ClinicLoaded(assignments: assignments));
        }
      },
    );
  }

  void selectClinic(String clinicId) {
    final current = state;
    if (current is ClinicLoaded) {
      emit(current.copyWith(
        selectedClinicId: clinicId,
        clearStaff: true,
        clearSelectedClinic: true,
      ));
    }
  }

  Future<void> createClinic(CreateClinicParams params) async {
    final current = state;
    emit(const ClinicLoading());
    final result = await _createClinic(params);
    result.fold(
      (failure) {
        if (current is ClinicLoaded) {
          emit(current);
        }
        emit(ClinicError(failure.message));
      },
      (clinic) async {
        await loadAssignments();
      },
    );
  }

  Future<void> lookupClinicByCode(String inviteCode) async {
    final result = await _getClinicByInviteCode(inviteCode);
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (clinic) {
        final current = state;
        if (current is ClinicLoaded) {
          emit(current.copyWith(selectedClinic: clinic));
        } else {
          emit(ClinicLoaded(
            assignments: const [],
            selectedClinic: clinic,
          ));
        }
      },
    );
  }

  Future<void> joinClinic(JoinClinicByCodeParams params) async {
    final current = state;
    emit(const ClinicLoading());
    final result = await _joinClinicByCode(params);
    result.fold(
      (failure) {
        if (current is ClinicLoaded) {
          emit(current);
        }
        emit(ClinicError(failure.message));
      },
      (assignment) async {
        await loadAssignments();
      },
    );
  }

  Future<void> updateClinic(UpdateClinicParams params) async {
    final current = state;
    emit(const ClinicLoading());
    final result = await _updateClinic(params);
    result.fold(
      (failure) {
        if (current is ClinicLoaded) {
          emit(current);
        }
        emit(ClinicError(failure.message));
      },
      (clinic) {
        if (current is ClinicLoaded) {
          emit(current.copyWith(selectedClinic: clinic));
        }
        loadAssignments();
      },
    );
  }

  Future<void> regenerateInviteCode(String clinicId) async {
    final current = state;
    final result = await _regenerateInviteCode(
      RegenerateInviteCodeParams(clinicId: clinicId),
    );
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (clinic) {
        if (current is ClinicLoaded) {
          emit(current.copyWith(selectedClinic: clinic));
        }
      },
    );
  }

  Future<void> loadStaff(String clinicId) async {
    final result = await _getClinicStaff(
      GetClinicStaffParams(clinicId: clinicId),
    );
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (staff) {
        final current = state;
        if (current is ClinicLoaded) {
          emit(current.copyWith(staff: staff));
        }
      },
    );
  }

  Future<void> updateStaffRole(UpdateStaffRoleParams params) async {
    final result = await _updateStaffRole(params);
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (updated) {
        final current = state;
        if (current is ClinicLoaded &&
            current.staff != null &&
            current.selectedClinicId != null) {
          loadStaff(current.selectedClinicId!);
        }
      },
    );
  }

  Future<void> deactivateStaff(String assignmentId) async {
    final result = await _deactivateStaff(
      DeactivateStaffParams(assignmentId: assignmentId),
    );
    result.fold(
      (failure) => emit(ClinicError(failure.message)),
      (_) {
        final current = state;
        if (current is ClinicLoaded &&
            current.staff != null &&
            current.selectedClinicId != null) {
          loadStaff(current.selectedClinicId!);
        }
      },
    );
  }
}
