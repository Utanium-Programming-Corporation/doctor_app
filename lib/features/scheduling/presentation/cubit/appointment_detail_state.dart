import '../../domain/entities/appointment.dart';

sealed class AppointmentDetailState {
  const AppointmentDetailState();
}

class AppointmentDetailInitial extends AppointmentDetailState {
  const AppointmentDetailInitial();
}

class AppointmentDetailLoading extends AppointmentDetailState {
  const AppointmentDetailLoading();
}

class AppointmentDetailLoaded extends AppointmentDetailState {
  final Appointment appointment;
  final bool isUpdating;

  const AppointmentDetailLoaded({
    required this.appointment,
    this.isUpdating = false,
  });

  AppointmentDetailLoaded copyWith({
    Appointment? appointment,
    bool? isUpdating,
  }) {
    return AppointmentDetailLoaded(
      appointment: appointment ?? this.appointment,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class AppointmentDetailError extends AppointmentDetailState {
  final String message;

  const AppointmentDetailError(this.message);
}
