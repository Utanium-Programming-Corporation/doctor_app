import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/appointment_params.dart';
import '../../domain/usecases/get_my_appointments_today.dart';
import 'my_day_state.dart';

class MyDayCubit extends Cubit<MyDayState> {
  final GetMyAppointmentsToday _getMyAppointmentsToday;

  MyDayCubit({
    required GetMyAppointmentsToday getMyAppointmentsToday,
  })  : _getMyAppointmentsToday = getMyAppointmentsToday,
        super(const MyDayInitial());

  Future<void> loadMyDay({
    required String clinicId,
    required String providerId,
  }) async {
    emit(const MyDayLoading());
    final result = await _getMyAppointmentsToday(
      GetMyAppointmentsTodayParams(
        clinicId: clinicId,
        providerId: providerId,
      ),
    );
    result.fold(
      (failure) => emit(MyDayError(failure.message)),
      (appointments) => emit(MyDayLoaded(
        appointments: appointments,
        providerId: providerId,
      )),
    );
  }

  Future<void> refresh({required String clinicId}) async {
    final current = state;
    if (current is! MyDayLoaded) return;
    await loadMyDay(clinicId: clinicId, providerId: current.providerId);
  }
}
