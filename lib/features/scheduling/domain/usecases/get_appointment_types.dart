import '../../../../core/usecase/usecase.dart';
import '../entities/appointment_type.dart';
import '../repositories/availability_repository.dart';

class GetAppointmentTypes
    implements UseCaseWithParams<List<AppointmentType>, String> {
  final AvailabilityRepository _repository;

  GetAppointmentTypes(this._repository);

  @override
  FutureResult<List<AppointmentType>> call(String clinicId) =>
      _repository.getAppointmentTypes(clinicId);
}
