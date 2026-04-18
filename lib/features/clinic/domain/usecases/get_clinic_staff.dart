import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/staff_assignment.dart';
import '../repositories/clinic_repository.dart';

class GetClinicStaff
    implements UseCaseWithParams<List<StaffAssignment>, GetClinicStaffParams> {
  final ClinicRepository _repository;

  GetClinicStaff(this._repository);

  @override
  FutureResult<List<StaffAssignment>> call(GetClinicStaffParams params) {
    return _repository.getClinicStaff(params.clinicId);
  }
}

class GetClinicStaffParams extends Equatable {
  final String clinicId;

  const GetClinicStaffParams({required this.clinicId});

  @override
  List<Object?> get props => [clinicId];
}
