import '../../../../core/usecase/usecase.dart';
import '../entities/appointment_type.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class UpdateAppointmentType
    implements
        UseCaseWithParams<AppointmentType, UpdateAppointmentTypeParams> {
  final AvailabilityRepository _repository;

  UpdateAppointmentType(this._repository);

  @override
  FutureResult<AppointmentType> call(UpdateAppointmentTypeParams params) {
    return _repository.updateAppointmentType(params);
  }
}
