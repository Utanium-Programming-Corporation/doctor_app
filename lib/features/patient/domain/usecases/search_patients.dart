import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class SearchPatients
    implements UseCaseWithParams<List<Patient>, SearchPatientsParams> {
  final PatientRepository _repository;

  SearchPatients(this._repository);

  @override
  FutureResult<List<Patient>> call(SearchPatientsParams params) {
    return _repository.searchPatients(params);
  }
}
