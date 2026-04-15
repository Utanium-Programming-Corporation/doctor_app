import '../../../../core/usecase/usecase.dart';
import '../entities/provider_availability.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class SetProviderAvailability
    implements
        UseCaseWithParams<List<ProviderAvailability>,
            SetProviderAvailabilityParams> {
  final AvailabilityRepository _repository;

  SetProviderAvailability(this._repository);

  @override
  FutureResult<List<ProviderAvailability>> call(
    SetProviderAvailabilityParams params,
  ) {
    return _repository.setProviderAvailability(params);
  }
}
