import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/clinic/domain/entities/staff_assignment.dart';
import '../../../../features/patient/domain/entities/patient.dart';
import '../../../../features/patient/domain/repositories/patient_repository.dart'
    show SearchPatientsParams;
import '../../../../features/patient/domain/usecases/search_patients.dart';
import '../../domain/entities/appointment_type.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/appointment_params.dart';
import '../../domain/repositories/availability_params.dart';
import '../../domain/usecases/create_appointment.dart';
import '../../domain/usecases/get_appointment_types.dart';
import '../../domain/usecases/get_available_slots.dart';
import '../../domain/usecases/reschedule_appointment.dart';
import 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final CreateAppointment _createAppointment;
  final GetAvailableSlots _getAvailableSlots;
  final GetAppointmentTypes _getAppointmentTypes;
  final SearchPatients _searchPatients;
  final RescheduleAppointment _rescheduleAppointment;

  BookAppointmentCubit({
    required CreateAppointment createAppointment,
    required GetAvailableSlots getAvailableSlots,
    required GetAppointmentTypes getAppointmentTypes,
    required SearchPatients searchPatients,
    required RescheduleAppointment rescheduleAppointment,
  })  : _createAppointment = createAppointment,
        _getAvailableSlots = getAvailableSlots,
        _getAppointmentTypes = getAppointmentTypes,
        _searchPatients = searchPatients,
        _rescheduleAppointment = rescheduleAppointment,
        super(const BookAppointmentInitial());

  void startBooking() {
    emit(const BookAppointmentInProgress(currentStep: 0));
  }

  /// Initialize for rescheduling — skip to slot selection (step 2)
  void startRescheduling({
    required Patient patient,
    required AppointmentType type,
    required StaffAssignment provider,
    required String appointmentId,
  }) {
    emit(BookAppointmentInProgress(
      currentStep: 2,
      selectedPatient: patient,
      selectedAppointmentType: type,
      selectedProvider: provider,
      rescheduleAppointmentId: appointmentId,
    ));
  }

  Future<void> searchPatients(String clinicId, String query) async {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    if (query.trim().isEmpty) {
      emit(current.copyWith(patientSearchResults: []));
      return;
    }
    emit(current.copyWith(isLoading: true, clearError: true));
    final result = await _searchPatients(
      SearchPatientsParams(clinicId: clinicId, query: query),
    );
    result.fold(
      (failure) => emit(current.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (patients) => emit(current.copyWith(
        isLoading: false,
        patientSearchResults: patients,
      )),
    );
  }

  Future<void> loadAppointmentTypes(String clinicId) async {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(isLoading: true, clearError: true));
    final result = await _getAppointmentTypes(clinicId);
    result.fold(
      (failure) => emit(current.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (types) => emit(current.copyWith(
        isLoading: false,
        appointmentTypes: types.where((t) => t.isActive).toList(),
      )),
    );
  }

  void selectPatient(Patient patient) {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(
      selectedPatient: patient,
      currentStep: 1,
      clearError: true,
    ));
  }

  void selectAppointmentType(AppointmentType type) {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(
      selectedAppointmentType: type,
      currentStep: 2,
      clearError: true,
    ));
  }

  void selectProvider(StaffAssignment provider) {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(
      selectedProvider: provider,
      clearSlot: true,
      clearError: true,
    ));
  }

  void selectDate(DateTime date) {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(
      selectedDate: date,
      clearSlot: true,
      availableSlots: [],
      clearError: true,
    ));
  }

  Future<void> loadAvailableSlots(String clinicId) async {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    if (current.selectedProvider == null ||
        current.selectedDate == null ||
        current.selectedAppointmentType == null) return;

    emit(current.copyWith(isLoading: true, clearError: true));
    final result = await _getAvailableSlots(
      GetAvailableSlotsParams(
        clinicId: clinicId,
        providerId: current.selectedProvider!.userId,
        date: current.selectedDate!,
        appointmentTypeId: current.selectedAppointmentType!.id,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (slots) => emit(current.copyWith(
        isLoading: false,
        availableSlots: slots,
      )),
    );
  }

  void selectSlot(TimeSlot slot) {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    emit(current.copyWith(
      selectedSlot: slot,
      currentStep: 3,
      clearError: true,
    ));
  }

  Future<void> confirmBooking(String clinicId) async {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    if (current.selectedPatient == null ||
        current.selectedAppointmentType == null ||
        current.selectedProvider == null ||
        current.selectedSlot == null) return;

    emit(current.copyWith(isLoading: true, clearError: true));
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    // If rescheduling, call reschedule instead of create
    if (current.rescheduleAppointmentId != null) {
      final result = await _rescheduleAppointment(
        RescheduleAppointmentParams(
          appointmentId: current.rescheduleAppointmentId!,
          newStartTime: current.selectedSlot!.startTime,
          newEndTime: current.selectedSlot!.endTime,
        ),
      );
      result.fold(
        (failure) => emit(current.copyWith(
          isLoading: false,
          error: failure.message,
        )),
        (appointment) =>
            emit(BookAppointmentSuccess(appointmentId: appointment.id)),
      );
      return;
    }

    final result = await _createAppointment(
      CreateAppointmentParams(
        clinicId: clinicId,
        patientId: current.selectedPatient!.id,
        providerId: current.selectedProvider!.userId,
        appointmentTypeId: current.selectedAppointmentType!.id,
        startTime: current.selectedSlot!.startTime,
        endTime: current.selectedSlot!.endTime,
        createdBy: userId,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (appointment) =>
          emit(BookAppointmentSuccess(appointmentId: appointment.id)),
    );
  }

  void goBack() {
    final current = state;
    if (current is! BookAppointmentInProgress) return;
    if (current.currentStep == 0) return;
    emit(current.copyWith(currentStep: current.currentStep - 1));
  }
}
