import '../../../../core/usecase/usecase.dart';
import '../entities/staff_assignment.dart';
import '../repositories/clinic_repository.dart';

class UpdateStaffRole
    implements UseCaseWithParams<StaffAssignment, UpdateStaffRoleParams> {
  final ClinicRepository _repository;

  UpdateStaffRole(this._repository);

  @override
  FutureResult<StaffAssignment> call(UpdateStaffRoleParams params) {
    return _repository.updateStaffRole(params);
  }
}
