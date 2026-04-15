import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentById implements UseCaseWithParams<Appointment, String> {
  final AppointmentRepository _repository;

  GetAppointmentById(this._repository);

  @override
  FutureResult<Appointment> call(String id) {
    return _repository.getAppointmentById(id);
  }
}
