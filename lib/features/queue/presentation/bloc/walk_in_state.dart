import 'package:equatable/equatable.dart';

sealed class WalkInState extends Equatable {
  const WalkInState();
}

class WalkInInitial extends WalkInState {
  const WalkInInitial();

  @override
  List<Object> get props => [];
}

class WalkInLoading extends WalkInState {
  const WalkInLoading();

  @override
  List<Object> get props => [];
}

class WalkInSuccess extends WalkInState {
  const WalkInSuccess();

  @override
  List<Object> get props => [];
}

class WalkInError extends WalkInState {
  final String message;

  const WalkInError(this.message);

  @override
  List<Object> get props => [message];
}
