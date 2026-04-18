// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    _AppointmentModel(
      id: json['id'] as String,
      clinicId: json['clinic_id'] as String,
      patientId: json['patient_id'] as String,
      providerId: json['provider_id'] as String,
      appointmentTypeId: json['appointment_type_id'] as String,
      locationId: json['location_id'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] == null
          ? AppointmentStatus.scheduled
          : const _AppointmentStatusConverter().fromJson(
              json['status'] as String,
            ),
      cancelReason: json['cancel_reason'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      patientName: json['patientName'] as String?,
      appointmentTypeName: json['appointmentTypeName'] as String?,
      appointmentTypeColor: json['appointmentTypeColor'] as String?,
      providerName: json['providerName'] as String?,
    );

Map<String, dynamic> _$AppointmentModelToJson(_AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'patient_id': instance.patientId,
      'provider_id': instance.providerId,
      'appointment_type_id': instance.appointmentTypeId,
      'location_id': instance.locationId,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'status': const _AppointmentStatusConverter().toJson(instance.status),
      'cancel_reason': instance.cancelReason,
      'notes': instance.notes,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
