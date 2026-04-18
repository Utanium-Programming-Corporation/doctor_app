import '../../../../core/usecase/usecase.dart';
import '../entities/clinic.dart';
import '../repositories/clinic_repository.dart';

class UpdateClinic implements UseCaseWithParams<Clinic, UpdateClinicParams> {
  final ClinicRepository _repository;

  UpdateClinic(this._repository);

  @override
  FutureResult<Clinic> call(UpdateClinicParams params) {
    return _repository.updateClinic(params);
  }
}
