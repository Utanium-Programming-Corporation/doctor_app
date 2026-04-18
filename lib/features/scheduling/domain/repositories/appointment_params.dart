import 'package:equatable/equatable.dart';

import '../entities/appointment_status.dart';

class CreateAppointmentParams extends Equatable {
  final String clinicId;
  final String patientId;
  final String providerId;
  final String appointmentTypeId;
  final String? locationId;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;
  final String createdBy;

  const CreateAppointmentParams({
    required this.clinicId,
    required this.patientId,
    required this.providerId,
    required this.appointmentTypeId,
    this.locationId,
    required this.startTime,
    required this.endTime,
    this.notes,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
        clinicId,
        patientId,
        providerId,
        appointmentTypeId,
        locationId,
        startTime,
        endTime,
        notes,
        createdBy,
      ];
}

class CancelAppointmentParams extends Equatable {
  final String appointmentId;
  final String? reason;

  const CancelAppointmentParams({
    required this.appointmentId,
    this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, reason];
}

class RescheduleAppointmentParams extends Equatable {
  final String appointmentId;
  final DateTime newStartTime;
  final DateTime newEndTime;
  final String? reason;

  const RescheduleAppointmentParams({
    required this.appointmentId,
    required this.newStartTime,
    required this.newEndTime,
    this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, newStartTime, newEndTime, reason];
}

class UpdateAppointmentStatusParams extends Equatable {
  final String appointmentId;
  final AppointmentStatus newStatus;

  const UpdateAppointmentStatusParams({
    required this.appointmentId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [appointmentId, newStatus];
}

class GetAppointmentsForDateParams extends Equatable {
  final String clinicId;
  final DateTime date;
  final String? providerId;

  const GetAppointmentsForDateParams({
    required this.clinicId,
    required this.date,
    this.providerId,
  });

  @override
  List<Object?> get props => [clinicId, date, providerId];
}

class GetMyAppointmentsTodayParams extends Equatable {
  final String clinicId;
  final String providerId;

  const GetMyAppointmentsTodayParams({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object?> get props => [clinicId, providerId];
}
