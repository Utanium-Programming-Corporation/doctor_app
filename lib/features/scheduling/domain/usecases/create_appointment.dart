import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointment
    implements UseCaseWithParams<Appointment, CreateAppointmentParams> {
  final AppointmentRepository _repository;

  CreateAppointment(this._repository);

  @override
  FutureResult<Appointment> call(CreateAppointmentParams params) =>
      _repository.createAppointment(params);
}
