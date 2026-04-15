import '../../../../core/usecase/usecase.dart';
import '../entities/provider_availability.dart';
import '../repositories/availability_params.dart';
import '../repositories/availability_repository.dart';

class GetProviderAvailability
    implements
        UseCaseWithParams<List<ProviderAvailability>,
            GetProviderAvailabilityParams> {
  final AvailabilityRepository _repository;

  GetProviderAvailability(this._repository);

  @override
  FutureResult<List<ProviderAvailability>> call(
    GetProviderAvailabilityParams params,
  ) {
    return _repository.getProviderAvailability(params);
  }
}
