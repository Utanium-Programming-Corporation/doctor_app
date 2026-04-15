import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/provider_availability.dart';

part 'provider_availability_model.freezed.dart';
part 'provider_availability_model.g.dart';

@freezed
abstract class ProviderAvailabilityModel with _$ProviderAvailabilityModel {
  const factory ProviderAvailabilityModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'provider_id') required String providerId,
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'location_id') String? locationId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ProviderAvailabilityModel;

  factory ProviderAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderAvailabilityModelFromJson(json);
}

extension ProviderAvailabilityModelX on ProviderAvailabilityModel {
  ProviderAvailability toEntity() => ProviderAvailability(
        id: id,
        clinicId: clinicId,
        providerId: providerId,
        dayOfWeek: dayOfWeek,
        startTime: _normalizeTime(startTime),
        endTime: _normalizeTime(endTime),
        locationId: locationId,
        isActive: isActive,
      );

  /// PostgreSQL returns time as "HH:mm:ss" — normalize to "HH:mm".
  String _normalizeTime(String t) =>
      t.length > 5 ? t.substring(0, 5) : t;
}
