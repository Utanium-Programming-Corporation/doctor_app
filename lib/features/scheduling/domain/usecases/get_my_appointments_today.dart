import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class GetMyAppointmentsToday
    implements
        UseCaseWithParams<List<Appointment>, GetMyAppointmentsTodayParams> {
  final AppointmentRepository _repository;

  GetMyAppointmentsToday(this._repository);

  @override
  FutureResult<List<Appointment>> call(GetMyAppointmentsTodayParams params) {
    return _repository.getMyAppointmentsToday(params);
  }
}
