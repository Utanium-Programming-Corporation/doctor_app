import '../../../../core/usecase/usecase.dart';
import '../entities/clinic.dart';
import '../repositories/clinic_repository.dart';

class GetClinicByInviteCode
    implements UseCaseWithParams<Clinic, String> {
  final ClinicRepository _repository;

  GetClinicByInviteCode(this._repository);

  @override
  FutureResult<Clinic> call(String inviteCode) {
    return _repository.getClinicByInviteCode(inviteCode);
  }
}
