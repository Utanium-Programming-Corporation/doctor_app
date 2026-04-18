import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentStatus
    implements
        UseCaseWithParams<Appointment, UpdateAppointmentStatusParams> {
  final AppointmentRepository _repository;

  UpdateAppointmentStatus(this._repository);

  @override
  FutureResult<Appointment> call(UpdateAppointmentStatusParams params) {
    return _repository.updateAppointmentStatus(params);
  }
}
