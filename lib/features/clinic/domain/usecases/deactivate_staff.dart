import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/clinic_repository.dart';

class DeactivateStaff
    implements UseCaseWithParams<void, DeactivateStaffParams> {
  final ClinicRepository _repository;

  DeactivateStaff(this._repository);

  @override
  FutureResult<void> call(DeactivateStaffParams params) {
    return _repository.deactivateStaff(params.assignmentId);
  }
}

class DeactivateStaffParams extends Equatable {
  final String assignmentId;

  const DeactivateStaffParams({required this.assignmentId});

  @override
  List<Object?> get props => [assignmentId];
}
