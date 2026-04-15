import 'package:equatable/equatable.dart';

import 'appointment_status.dart';

class Appointment extends Equatable {
  final String id;
  final String clinicId;
  final String patientId;
  final String providerId;
  final String appointmentTypeId;
  final String? locationId;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentStatus status;
  final String? cancelReason;
  final String? notes;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Denormalized join fields (read-only, not stored in DB)
  final String? patientName;
  final String? appointmentTypeName;
  final String? appointmentTypeColor;
  final String? providerName;

  const Appointment({
    required this.id,
    required this.clinicId,
    required this.patientId,
    required this.providerId,
    required this.appointmentTypeId,
    this.locationId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.cancelReason,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.patientName,
    this.appointmentTypeName,
    this.appointmentTypeColor,
    this.providerName,
  });

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  bool get isEditable => !status.isTerminal;

  bool get canCancel =>
      status != AppointmentStatus.completed && !status.isTerminal;

  @override
  List<Object?> get props => [
        id,
        clinicId,
        patientId,
        providerId,
        appointmentTypeId,
        locationId,
        startTime,
        endTime,
        status,
        cancelReason,
        notes,
        createdBy,
        createdAt,
        updatedAt,
        patientName,
        appointmentTypeName,
        appointmentTypeColor,
        providerName,
      ];

  Appointment copyWith({
    AppointmentStatus? status,
    String? cancelReason,
    String? notes,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Appointment(
      id: id,
      clinicId: clinicId,
      patientId: patientId,
      providerId: providerId,
      appointmentTypeId: appointmentTypeId,
      locationId: locationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
      notes: notes ?? this.notes,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      patientName: patientName,
      appointmentTypeName: appointmentTypeName,
      appointmentTypeColor: appointmentTypeColor,
      providerName: providerName,
    );
  }
}
