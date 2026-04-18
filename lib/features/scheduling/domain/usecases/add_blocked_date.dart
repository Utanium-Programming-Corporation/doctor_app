import '../../../../core/usecase/usecase.dart';
import '../entities/blocked_date.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class AddBlockedDate
    implements UseCaseWithParams<BlockedDate, AddBlockedDateParams> {
  final AvailabilityRepository _repository;

  AddBlockedDate(this._repository);

  @override
  FutureResult<BlockedDate> call(AddBlockedDateParams params) {
    return _repository.addBlockedDate(params);
  }
}
