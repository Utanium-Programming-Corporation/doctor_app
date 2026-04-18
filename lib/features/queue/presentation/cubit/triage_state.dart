import 'package:equatable/equatable.dart';

import '../../domain/entities/triage_assessment.dart';

sealed class TriageState extends Equatable {
  const TriageState();
}

class TriageInitial extends TriageState {
  const TriageInitial();

  @override
  List<Object> get props => [];
}

class TriageLoading extends TriageState {
  const TriageLoading();

  @override
  List<Object> get props => [];
}

class TriageSaved extends TriageState {
  final TriageAssessment assessment;

  const TriageSaved(this.assessment);

  @override
  List<Object> get props => [assessment];
}

class TriageLoaded extends TriageState {
  final TriageAssessment? assessment;

  const TriageLoaded(this.assessment);

  @override
  List<Object?> get props => [assessment];
}

class TriageError extends TriageState {
  final String message;

  const TriageError(this.message);

  @override
  List<Object> get props => [message];
}
