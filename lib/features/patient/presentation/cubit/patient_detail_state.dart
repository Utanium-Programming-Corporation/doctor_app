import '../../domain/entities/patient.dart';

sealed class PatientDetailState {
  const PatientDetailState();
}

class PatientDetailInitial extends PatientDetailState {
  const PatientDetailInitial();
}

class PatientDetailLoading extends PatientDetailState {
  const PatientDetailLoading();
}

class PatientDetailLoaded extends PatientDetailState {
  final Patient patient;

  const PatientDetailLoaded(this.patient);
}

class PatientDetailSaved extends PatientDetailState {
  final Patient patient;

  const PatientDetailSaved(this.patient);
}

class PatientDetailError extends PatientDetailState {
  final String message;

  const PatientDetailError(this.message);
}
