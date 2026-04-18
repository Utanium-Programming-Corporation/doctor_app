import 'package:equatable/equatable.dart';

import '../../domain/entities/queue_token.dart';

sealed class QueueState extends Equatable {
  const QueueState();
}

class QueueInitial extends QueueState {
  const QueueInitial();

  @override
  List<Object> get props => [];
}

class QueueLoading extends QueueState {
  const QueueLoading();

  @override
  List<Object> get props => [];
}

class QueueLoaded extends QueueState {
  final List<QueueToken> tokens;
  final bool isActioning;
  final String? actionError;

  const QueueLoaded({
    required this.tokens,
    this.isActioning = false,
    this.actionError,
  });

  QueueLoaded copyWith({
    List<QueueToken>? tokens,
    bool? isActioning,
    String? actionError,
  }) =>
      QueueLoaded(
        tokens: tokens ?? this.tokens,
        isActioning: isActioning ?? this.isActioning,
        actionError: actionError,
      );

  @override
  List<Object?> get props => [tokens, isActioning, actionError];
}

class QueueError extends QueueState {
  final String message;

  const QueueError(this.message);

  @override
  List<Object> get props => [message];
}
