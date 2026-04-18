import '../../../../core/usecase/usecase.dart';
import '../entities/clinic.dart';
import '../repositories/clinic_repository.dart';

class CreateClinic implements UseCaseWithParams<Clinic, CreateClinicParams> {
  final ClinicRepository _repository;

  CreateClinic(this._repository);

  @override
  FutureResult<Clinic> call(CreateClinicParams params) {
    return _repository.createClinic(params);
  }
}
