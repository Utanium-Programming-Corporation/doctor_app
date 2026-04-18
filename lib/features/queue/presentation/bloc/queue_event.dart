import 'package:equatable/equatable.dart';

sealed class QueueEvent extends Equatable {
  const QueueEvent();
}

class QueueSubscriptionRequested extends QueueEvent {
  final String clinicId;

  const QueueSubscriptionRequested(this.clinicId);

  @override
  List<Object> get props => [clinicId];
}

class QueueCallNextRequested extends QueueEvent {
  final String clinicId;
  final String providerId;

  const QueueCallNextRequested({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object> get props => [clinicId, providerId];
}

class QueueSkipRequested extends QueueEvent {
  final String tokenId;

  const QueueSkipRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}

class QueueMarkNoShowRequested extends QueueEvent {
  final String tokenId;

  const QueueMarkNoShowRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}

class QueueStartConsultationRequested extends QueueEvent {
  final String tokenId;

  const QueueStartConsultationRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}

class QueueCompleteRequested extends QueueEvent {
  final String tokenId;

  const QueueCompleteRequested(this.tokenId);

  @override
  List<Object> get props => [tokenId];
}
