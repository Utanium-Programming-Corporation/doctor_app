import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientById implements UseCaseWithParams<Patient, String> {
  final PatientRepository _repository;

  GetPatientById(this._repository);

  @override
  FutureResult<Patient> call(String id) {
    return _repository.getPatientById(id);
  }
}
