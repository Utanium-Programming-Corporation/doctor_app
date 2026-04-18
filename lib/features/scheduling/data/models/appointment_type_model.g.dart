// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppointmentTypeModel _$AppointmentTypeModelFromJson(
  Map<String, dynamic> json,
) => _AppointmentTypeModel(
  id: json['id'] as String,
  clinicId: json['clinic_id'] as String,
  name: json['name'] as String,
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  colorHex: json['color_hex'] as String,
  description: json['description'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AppointmentTypeModelToJson(
  _AppointmentTypeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'clinic_id': instance.clinicId,
  'name': instance.name,
  'duration_minutes': instance.durationMinutes,
  'color_hex': instance.colorHex,
  'description': instance.description,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};
