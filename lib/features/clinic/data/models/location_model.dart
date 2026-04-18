import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/location.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    required String name,
    required String address,
    required String phone,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}

extension LocationModelX on LocationModel {
  Location toEntity() => Location(
        id: id,
        clinicId: clinicId,
        name: name,
        address: address,
        phone: phone,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
