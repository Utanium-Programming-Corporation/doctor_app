// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderAvailabilityModel _$ProviderAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => _ProviderAvailabilityModel(
  id: json['id'] as String,
  clinicId: json['clinic_id'] as String,
  providerId: json['provider_id'] as String,
  dayOfWeek: (json['day_of_week'] as num).toInt(),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  locationId: json['location_id'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ProviderAvailabilityModelToJson(
  _ProviderAvailabilityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'clinic_id': instance.clinicId,
  'provider_id': instance.providerId,
  'day_of_week': instance.dayOfWeek,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'location_id': instance.locationId,
  'is_active': instance.isActive,
};
