import '../../../../core/usecase/usecase.dart';
import '../repositories/patient_repository.dart';

class DeactivatePatient implements UseCaseWithParams<void, String> {
  final PatientRepository _repository;

  DeactivatePatient(this._repository);

  @override
  FutureResult<void> call(String id) {
    return _repository.deactivatePatient(id);
  }
}
