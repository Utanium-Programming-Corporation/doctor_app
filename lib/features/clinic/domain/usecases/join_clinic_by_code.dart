import '../../../../core/usecase/usecase.dart';
import '../entities/staff_assignment.dart';
import '../repositories/clinic_repository.dart';

class JoinClinicByCode
    implements UseCaseWithParams<StaffAssignment, JoinClinicByCodeParams> {
  final ClinicRepository _repository;

  JoinClinicByCode(this._repository);

  @override
  FutureResult<StaffAssignment> call(JoinClinicByCodeParams params) {
    return _repository.joinClinicByCode(params);
  }
}
