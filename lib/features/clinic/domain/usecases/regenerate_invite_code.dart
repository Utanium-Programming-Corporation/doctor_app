import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/clinic.dart';
import '../repositories/clinic_repository.dart';

class RegenerateInviteCode
    implements UseCaseWithParams<Clinic, RegenerateInviteCodeParams> {
  final ClinicRepository _repository;

  RegenerateInviteCode(this._repository);

  @override
  FutureResult<Clinic> call(RegenerateInviteCodeParams params) {
    return _repository.regenerateInviteCode(params.clinicId);
  }
}

class RegenerateInviteCodeParams extends Equatable {
  final String clinicId;

  const RegenerateInviteCodeParams({required this.clinicId});

  @override
  List<Object?> get props => [clinicId];
}
