import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/queue_token.dart';
import '../repositories/queue_repository.dart';

class GetMyQueueParams extends Equatable {
  final String clinicId;
  final String providerId;

  const GetMyQueueParams({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clinicId, providerId];
}

class GetMyQueue
    implements StreamUseCaseWithParams<List<QueueToken>, GetMyQueueParams> {
  final QueueRepository _repository;

  GetMyQueue(this._repository);

  @override
  StreamResult<List<QueueToken>> call(GetMyQueueParams params) =>
      _repository.watchMyQueue(
        clinicId: params.clinicId,
        providerId: params.providerId,
      );
}

class StartConsultation implements UseCaseWithParams<QueueToken, String> {
  final QueueRepository _repository;

  StartConsultation(this._repository);

  @override
  FutureResult<QueueToken> call(String params) =>
      _repository.startConsultation(params);
}

class CompleteQueueToken implements UseCaseWithParams<QueueToken, String> {
  final QueueRepository _repository;

  CompleteQueueToken(this._repository);

  @override
  FutureResult<QueueToken> call(String params) =>
      _repository.completeQueueToken(params);
}
