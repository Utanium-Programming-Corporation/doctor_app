import '../../../../core/usecase/usecase.dart';
import '../entities/appointment_type.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class CreateAppointmentType
    implements
        UseCaseWithParams<AppointmentType, CreateAppointmentTypeParams> {
  final AvailabilityRepository _repository;

  CreateAppointmentType(this._repository);

  @override
  FutureResult<AppointmentType> call(CreateAppointmentTypeParams params) {
    return _repository.createAppointmentType(params);
  }
}
