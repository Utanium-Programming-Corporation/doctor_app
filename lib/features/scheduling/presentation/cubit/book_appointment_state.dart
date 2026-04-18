import '../../../../features/patient/domain/entities/patient.dart';
import '../../domain/entities/appointment_type.dart';
import '../../domain/entities/time_slot.dart';
import '../../../clinic/domain/entities/staff_assignment.dart';

sealed class BookAppointmentState {
  const BookAppointmentState();
}

class BookAppointmentInitial extends BookAppointmentState {
  const BookAppointmentInitial();
}

class BookAppointmentInProgress extends BookAppointmentState {
  final int currentStep;
  final Patient? selectedPatient;
  final List<Patient> patientSearchResults;
  final List<AppointmentType> appointmentTypes;
  final AppointmentType? selectedAppointmentType;
  final StaffAssignment? selectedProvider;
  final DateTime? selectedDate;
  final TimeSlot? selectedSlot;
  final List<TimeSlot> availableSlots;
  final bool isLoading;
  final String? error;
  final String? rescheduleAppointmentId;

  const BookAppointmentInProgress({
    required this.currentStep,
    this.selectedPatient,
    this.patientSearchResults = const [],
    this.appointmentTypes = const [],
    this.selectedAppointmentType,
    this.selectedProvider,
    this.selectedDate,
    this.selectedSlot,
    this.availableSlots = const [],
    this.isLoading = false,
    this.error,
    this.rescheduleAppointmentId,
  });

  BookAppointmentInProgress copyWith({
    int? currentStep,
    Patient? selectedPatient,
    List<Patient>? patientSearchResults,
    List<AppointmentType>? appointmentTypes,
    AppointmentType? selectedAppointmentType,
    StaffAssignment? selectedProvider,
    DateTime? selectedDate,
    TimeSlot? selectedSlot,
    List<TimeSlot>? availableSlots,
    bool? isLoading,
    String? error,
    String? rescheduleAppointmentId,
    bool clearError = false,
    bool clearSlot = false,
  }) {
    return BookAppointmentInProgress(
      currentStep: currentStep ?? this.currentStep,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      patientSearchResults: patientSearchResults ?? this.patientSearchResults,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      selectedAppointmentType:
          selectedAppointmentType ?? this.selectedAppointmentType,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      availableSlots: availableSlots ?? this.availableSlots,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      rescheduleAppointmentId:
          rescheduleAppointmentId ?? this.rescheduleAppointmentId,
    );
  }
}

class BookAppointmentSuccess extends BookAppointmentState {
  final String appointmentId;

  const BookAppointmentSuccess({required this.appointmentId});
}

class BookAppointmentError extends BookAppointmentState {
  final String message;

  const BookAppointmentError(this.message);
}
