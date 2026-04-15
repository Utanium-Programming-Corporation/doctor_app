import '../../../../core/usecase/usecase.dart';
import '../entities/appointment.dart';
import 'appointment_params.dart';

abstract interface class AppointmentRepository {
  FutureResult<Appointment> createAppointment(CreateAppointmentParams params);
  FutureResult<Appointment> getAppointmentById(String id);
  FutureResult<List<Appointment>> getAppointmentsForDate(
    GetAppointmentsForDateParams params,
  );
  FutureResult<List<Appointment>> getMyAppointmentsToday(
    GetMyAppointmentsTodayParams params,
  );
  FutureResult<Appointment> updateAppointmentStatus(
    UpdateAppointmentStatusParams params,
  );
  FutureResult<void> cancelAppointment(CancelAppointmentParams params);
  FutureResult<Appointment> rescheduleAppointment(
    RescheduleAppointmentParams params,
  );
}
