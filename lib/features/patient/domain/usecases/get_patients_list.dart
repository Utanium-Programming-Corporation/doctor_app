import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientsList
    implements UseCaseWithParams<List<Patient>, GetPatientsListParams> {
  final PatientRepository _repository;

  GetPatientsList(this._repository);

  @override
  FutureResult<List<Patient>> call(GetPatientsListParams params) {
    return _repository.getPatientsList(params);
  }
}
