import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_status.dart';
import '../../domain/repositories/appointment_params.dart';
import '../../domain/usecases/cancel_appointment.dart';
import '../../domain/usecases/get_appointment_by_id.dart';
import '../../domain/usecases/update_appointment_status.dart';
import 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final GetAppointmentById _getAppointmentById;
  final UpdateAppointmentStatus _updateStatus;
  final CancelAppointment _cancelAppointment;

  AppointmentDetailCubit({
    required GetAppointmentById getAppointmentById,
    required UpdateAppointmentStatus updateStatus,
    required CancelAppointment cancelAppointment,
  })  : _getAppointmentById = getAppointmentById,
        _updateStatus = updateStatus,
        _cancelAppointment = cancelAppointment,
        super(const AppointmentDetailInitial());

  Future<void> loadAppointment(String id) async {
    emit(const AppointmentDetailLoading());
    final result = await _getAppointmentById(id);
    result.fold(
      (failure) => emit(AppointmentDetailError(failure.message)),
      (appointment) =>
          emit(AppointmentDetailLoaded(appointment: appointment)),
    );
  }

  Future<void> updateStatus({
    required String appointmentId,
    required AppointmentStatus newStatus,
  }) async {
    final current = state;
    if (current is! AppointmentDetailLoaded) return;
    emit(current.copyWith(isUpdating: true));
    final result = await _updateStatus(
      UpdateAppointmentStatusParams(
        appointmentId: appointmentId,
        newStatus: newStatus,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(isUpdating: false)),
      (updated) => emit(AppointmentDetailLoaded(appointment: updated)),
    );
  }

  Future<void> cancelAppointment({
    required String appointmentId,
    String? reason,
  }) async {
    final current = state;
    if (current is! AppointmentDetailLoaded) return;
    emit(current.copyWith(isUpdating: true));
    final result = await _cancelAppointment(
      CancelAppointmentParams(
        appointmentId: appointmentId,
        reason: reason,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(isUpdating: false)),
      (_) => emit(AppointmentDetailLoaded(
        appointment: current.appointment.copyWith(
          status: AppointmentStatus.cancelled,
        ),
      )),
    );
  }
}
