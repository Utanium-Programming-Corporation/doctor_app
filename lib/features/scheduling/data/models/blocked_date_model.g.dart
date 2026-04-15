// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedDateModel _$BlockedDateModelFromJson(Map<String, dynamic> json) =>
    _BlockedDateModel(
      id: json['id'] as String,
      clinicId: json['clinic_id'] as String,
      providerId: json['provider_id'] as String,
      blockedDate: DateTime.parse(json['blocked_date'] as String),
      reason: json['reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BlockedDateModelToJson(_BlockedDateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'provider_id': instance.providerId,
      'blocked_date': instance.blockedDate.toIso8601String(),
      'reason': instance.reason,
      'created_at': instance.createdAt.toIso8601String(),
    };
