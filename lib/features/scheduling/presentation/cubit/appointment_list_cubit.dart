import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/appointment_params.dart';
import '../../domain/usecases/get_appointments_for_date.dart';
import 'appointment_list_state.dart';

class AppointmentListCubit extends Cubit<AppointmentListState> {
  final GetAppointmentsForDate _getAppointmentsForDate;

  AppointmentListCubit({
    required GetAppointmentsForDate getAppointmentsForDate,
  })  : _getAppointmentsForDate = getAppointmentsForDate,
        super(const AppointmentListInitial());

  Future<void> loadAppointments({
    required String clinicId,
    required DateTime date,
    String? providerId,
  }) async {
    emit(const AppointmentListLoading());
    final result = await _getAppointmentsForDate(
      GetAppointmentsForDateParams(
        clinicId: clinicId,
        date: date,
        providerId: providerId,
      ),
    );
    result.fold(
      (failure) => emit(AppointmentListError(failure.message)),
      (appointments) => emit(AppointmentListLoaded(
        appointments: appointments,
        selectedDate: date,
        selectedProviderId: providerId,
      )),
    );
  }

  Future<void> filterByProvider({
    required String clinicId,
    required String? providerId,
  }) async {
    final current = state;
    if (current is! AppointmentListLoaded) return;
    await loadAppointments(
      clinicId: clinicId,
      date: current.selectedDate,
      providerId: providerId,
    );
  }

  Future<void> changeDate({
    required String clinicId,
    required DateTime date,
  }) async {
    final current = state;
    final providerId =
        current is AppointmentListLoaded ? current.selectedProviderId : null;
    await loadAppointments(
      clinicId: clinicId,
      date: date,
      providerId: providerId,
    );
  }
}
