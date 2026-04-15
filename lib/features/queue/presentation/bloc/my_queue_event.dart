import 'package:equatable/equatable.dart';

sealed class MyQueueEvent extends Equatable {
  const MyQueueEvent();
}

class MyQueueSubscriptionRequested extends MyQueueEvent {
  final String clinicId;
  final String providerId;

  const MyQueueSubscriptionRequested({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clinicId, providerId];
}

class MyQueueCallNextRequested extends MyQueueEvent {
  final String clinicId;
  final String providerId;

  const MyQueueCallNextRequested({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clinicId, providerId];
}

class MyQueueStartConsultationRequested extends MyQueueEvent {
  final String tokenId;

  const MyQueueStartConsultationRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}

class MyQueueCompleteRequested extends MyQueueEvent {
  final String tokenId;

  const MyQueueCompleteRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}
