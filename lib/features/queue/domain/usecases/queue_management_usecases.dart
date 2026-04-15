import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/queue_token.dart';
import '../repositories/queue_repository.dart';

class GetQueueForClinic
    implements StreamUseCaseWithParams<List<QueueToken>, String> {
  final QueueRepository _repository;

  GetQueueForClinic(this._repository);

  @override
  StreamResult<List<QueueToken>> call(String params) =>
      _repository.watchQueueForClinic(params);
}

class CallNextPatientParams extends Equatable {
  final String clinicId;
  final String providerId;

  const CallNextPatientParams({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clinicId, providerId];
}

class CallNextPatient
    implements UseCaseWithParams<QueueToken, CallNextPatientParams> {
  final QueueRepository _repository;

  CallNextPatient(this._repository);

  @override
  FutureResult<QueueToken> call(CallNextPatientParams params) =>
      _repository.callNextPatient(
        clinicId: params.clinicId,
        providerId: params.providerId,
      );
}

class SkipQueueToken implements UseCaseWithParams<QueueToken, String> {
  final QueueRepository _repository;

  SkipQueueToken(this._repository);

  @override
  FutureResult<QueueToken> call(String params) =>
      _repository.skipQueueToken(params);
}

class MarkNoShow implements UseCaseWithParams<QueueToken, String> {
  final QueueRepository _repository;

  MarkNoShow(this._repository);

  @override
  FutureResult<QueueToken> call(String params) =>
      _repository.markNoShow(params);
}
