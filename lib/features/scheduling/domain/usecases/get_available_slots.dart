import '../../../../core/usecase/usecase.dart';
import '../entities/time_slot.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class GetAvailableSlots
    implements UseCaseWithParams<List<TimeSlot>, GetAvailableSlotsParams> {
  final AvailabilityRepository _repository;

  GetAvailableSlots(this._repository);

  @override
  FutureResult<List<TimeSlot>> call(GetAvailableSlotsParams params) =>
      _repository.getAvailableSlots(params);
}
