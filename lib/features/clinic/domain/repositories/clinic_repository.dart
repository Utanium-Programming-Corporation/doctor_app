import '../../../../core/usecase/usecase.dart';
import '../entities/clinic.dart';
import '../entities/clinic_type.dart';
import '../entities/staff_assignment.dart';
import '../entities/staff_role.dart';

abstract interface class ClinicRepository {
  FutureResult<Clinic> createClinic(CreateClinicParams params);
  FutureResult<StaffAssignment> joinClinicByCode(JoinClinicByCodeParams params);
  FutureResult<List<StaffAssignment>> getMyClinicAssignments();
  FutureResult<List<StaffAssignment>> getClinicStaff(String clinicId);
  FutureResult<Clinic> updateClinic(UpdateClinicParams params);
  FutureResult<StaffAssignment> updateStaffRole(UpdateStaffRoleParams params);
  FutureResult<void> deactivateStaff(String assignmentId);
  FutureResult<Clinic> regenerateInviteCode(String clinicId);
  FutureResult<Clinic> getClinicByInviteCode(String inviteCode);
}

class CreateClinicParams {
  final String name;
  final String phone;
  final String address;
  final ClinicType type;

  const CreateClinicParams({
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
  });
}

class JoinClinicByCodeParams {
  final String inviteCode;

  const JoinClinicByCodeParams({required this.inviteCode});
}

class UpdateClinicParams {
  final String clinicId;
  final String name;
  final String phone;
  final String address;
  final ClinicType type;

  const UpdateClinicParams({
    required this.clinicId,
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
  });
}

class UpdateStaffRoleParams {
  final String assignmentId;
  final StaffRole newRole;

  const UpdateStaffRoleParams({
    required this.assignmentId,
    required this.newRole,
  });
}
