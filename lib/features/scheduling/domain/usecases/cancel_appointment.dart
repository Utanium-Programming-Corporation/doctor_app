import '../../../../core/usecase/usecase.dart';
import '../repositories/appointment_params.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointment
    implements UseCaseWithParams<void, CancelAppointmentParams> {
  final AppointmentRepository _repository;

  CancelAppointment(this._repository);

  @override
  FutureResult<void> call(CancelAppointmentParams params) {
    return _repository.cancelAppointment(params);
  }
}
