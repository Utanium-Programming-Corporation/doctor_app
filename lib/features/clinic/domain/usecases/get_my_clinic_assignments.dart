import '../../../../core/usecase/usecase.dart';
import '../entities/staff_assignment.dart';
import '../repositories/clinic_repository.dart';

class GetMyClinicAssignments
    implements UseCaseWithoutParams<List<StaffAssignment>> {
  final ClinicRepository _repository;

  GetMyClinicAssignments(this._repository);

  @override
  FutureResult<List<StaffAssignment>> call() {
    return _repository.getMyClinicAssignments();
  }
}
