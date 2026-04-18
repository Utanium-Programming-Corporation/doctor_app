import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class CreatePatient implements UseCaseWithParams<Patient, CreatePatientParams> {
  final PatientRepository _repository;

  CreatePatient(this._repository);

  @override
  FutureResult<Patient> call(CreatePatientParams params) {
    return _repository.createPatient(params);
  }
}
