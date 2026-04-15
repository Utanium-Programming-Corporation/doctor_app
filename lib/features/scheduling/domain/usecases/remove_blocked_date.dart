import '../../../../core/usecase/usecase.dart';
import '../repositories/availability_repository.dart';

class RemoveBlockedDate implements UseCaseWithParams<void, String> {
  final AvailabilityRepository _repository;

  RemoveBlockedDate(this._repository);

  @override
  FutureResult<void> call(String id) {
    return _repository.removeBlockedDate(id);
  }
}
