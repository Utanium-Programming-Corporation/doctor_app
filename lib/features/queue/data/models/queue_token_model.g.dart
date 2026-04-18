// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QueueTokenModel _$QueueTokenModelFromJson(
  Map<String, dynamic> json,
) => _QueueTokenModel(
  id: json['id'] as String,
  clinicId: json['clinic_id'] as String,
  locationId: json['location_id'] as String?,
  tokenNumber: (json['token_number'] as num).toInt(),
  patientId: json['patient_id'] as String,
  appointmentId: json['appointment_id'] as String?,
  providerId: json['provider_id'] as String,
  status: json['status'] == null
      ? QueueTokenStatus.waiting
      : const _QueueTokenStatusConverter().fromJson(json['status'] as String),
  priority: json['priority'] == null
      ? QueuePriority.normal
      : const _QueuePriorityConverter().fromJson(json['priority'] as String),
  skipCount: (json['skip_count'] as num?)?.toInt() ?? 0,
  calledAt: json['called_at'] == null
      ? null
      : DateTime.parse(json['called_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  patientName: json['patientName'] as String?,
  providerName: json['providerName'] as String?,
);

Map<String, dynamic> _$QueueTokenModelToJson(_QueueTokenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'location_id': instance.locationId,
      'token_number': instance.tokenNumber,
      'patient_id': instance.patientId,
      'appointment_id': instance.appointmentId,
      'provider_id': instance.providerId,
      'status': const _QueueTokenStatusConverter().toJson(instance.status),
      'priority': const _QueuePriorityConverter().toJson(instance.priority),
      'skip_count': instance.skipCount,
      'called_at': instance.calledAt?.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
