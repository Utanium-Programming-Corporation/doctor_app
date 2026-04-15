import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsForDate
    implements UseCaseWithParams<List<Appointment>, GetAppointmentsForDateParams> {
  final AppointmentRepository _repository;

  GetAppointmentsForDate(this._repository);

  @override
  FutureResult<List<Appointment>> call(GetAppointmentsForDateParams params) {
    return _repository.getAppointmentsForDate(params);
  }
}
