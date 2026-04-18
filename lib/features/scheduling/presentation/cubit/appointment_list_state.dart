import '../../domain/entities/appointment.dart';

sealed class AppointmentListState {
  const AppointmentListState();
}

class AppointmentListInitial extends AppointmentListState {
  const AppointmentListInitial();
}

class AppointmentListLoading extends AppointmentListState {
  const AppointmentListLoading();
}

class AppointmentListLoaded extends AppointmentListState {
  final List<Appointment> appointments;
  final DateTime selectedDate;
  final String? selectedProviderId;

  const AppointmentListLoaded({
    required this.appointments,
    required this.selectedDate,
    this.selectedProviderId,
  });

  AppointmentListLoaded copyWith({
    List<Appointment>? appointments,
    DateTime? selectedDate,
    String? selectedProviderId,
    bool clearProvider = false,
  }) {
    return AppointmentListLoaded(
      appointments: appointments ?? this.appointments,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedProviderId:
          clearProvider ? null : (selectedProviderId ?? this.selectedProviderId),
    );
  }
}

class AppointmentListError extends AppointmentListState {
  final String message;

  const AppointmentListError(this.message);
}
