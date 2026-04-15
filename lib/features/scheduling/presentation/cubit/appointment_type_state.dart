import '../../domain/entities/appointment_type.dart';

sealed class AppointmentTypeState {
  const AppointmentTypeState();
}

class AppointmentTypeInitial extends AppointmentTypeState {
  const AppointmentTypeInitial();
}

class AppointmentTypeLoading extends AppointmentTypeState {
  const AppointmentTypeLoading();
}

class AppointmentTypeLoaded extends AppointmentTypeState {
  final List<AppointmentType> types;
  final bool isSaving;

  const AppointmentTypeLoaded({
    required this.types,
    this.isSaving = false,
  });

  AppointmentTypeLoaded copyWith({
    List<AppointmentType>? types,
    bool? isSaving,
  }) {
    return AppointmentTypeLoaded(
      types: types ?? this.types,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AppointmentTypeError extends AppointmentTypeState {
  final String message;
  const AppointmentTypeError(this.message);
}
