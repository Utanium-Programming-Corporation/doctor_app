import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class UpdatePatient implements UseCaseWithParams<Patient, UpdatePatientParams> {
  final PatientRepository _repository;

  UpdatePatient(this._repository);

  @override
  FutureResult<Patient> call(UpdatePatientParams params) {
    return _repository.updatePatient(params);
  }
}
