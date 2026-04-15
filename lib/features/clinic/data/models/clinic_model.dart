import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/clinic.dart';
import '../../domain/entities/clinic_type.dart';

part 'clinic_model.freezed.dart';
part 'clinic_model.g.dart';

class _ClinicTypeConverter implements JsonConverter<ClinicType, String> {
  const _ClinicTypeConverter();

  @override
  ClinicType fromJson(String json) => ClinicType.fromDbValue(json);

  @override
  String toJson(ClinicType object) => object.dbValue;
}

@freezed
abstract class ClinicModel with _$ClinicModel {
  const factory ClinicModel({
    required String id,
    required String name,
    required String phone,
    required String address,
    @_ClinicTypeConverter() required ClinicType type,
    @JsonKey(name: 'invite_code') required String inviteCode,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ClinicModel;

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
}

extension ClinicModelX on ClinicModel {
  Clinic toEntity() => Clinic(
        id: id,
        name: name,
        phone: phone,
        address: address,
        type: type,
        inviteCode: inviteCode,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
