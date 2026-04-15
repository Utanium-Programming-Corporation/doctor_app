import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class RescheduleAppointment
    implements UseCaseWithParams<Appointment, RescheduleAppointmentParams> {
  final AppointmentRepository _repository;

  RescheduleAppointment(this._repository);

  @override
  FutureResult<Appointment> call(RescheduleAppointmentParams params) {
    return _repository.rescheduleAppointment(params);
  }
}
