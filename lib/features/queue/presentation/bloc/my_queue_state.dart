import 'package:equatable/equatable.dart';

import '../../domain/entities/queue_token.dart';

sealed class MyQueueState extends Equatable {
  const MyQueueState();
}

class MyQueueInitial extends MyQueueState {
  const MyQueueInitial();

  @override
  List<Object> get props => [];
}

class MyQueueLoading extends MyQueueState {
  const MyQueueLoading();

  @override
  List<Object> get props => [];
}

class MyQueueLoaded extends MyQueueState {
  final List<QueueToken> tokens;
  final bool isActioning;
  final String? actionError;

  const MyQueueLoaded({
    required this.tokens,
    this.isActioning = false,
    this.actionError,
  });

  MyQueueLoaded copyWith({
    List<QueueToken>? tokens,
    bool? isActioning,
    String? actionError,
  }) =>
      MyQueueLoaded(
        tokens: tokens ?? this.tokens,
        isActioning: isActioning ?? this.isActioning,
        actionError: actionError,
      );

  @override
  List<Object?> get props => [tokens, isActioning, actionError];
}

class MyQueueError extends MyQueueState {
  final String message;

  const MyQueueError(this.message);

  @override
  List<Object> get props => [message];
}
