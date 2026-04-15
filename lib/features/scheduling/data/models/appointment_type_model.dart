import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/appointment_type.dart';

part 'appointment_type_model.freezed.dart';
part 'appointment_type_model.g.dart';

@freezed
abstract class AppointmentTypeModel with _$AppointmentTypeModel {
  const factory AppointmentTypeModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    required String name,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'color_hex') required String colorHex,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AppointmentTypeModel;

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentTypeModelFromJson(json);
}

extension AppointmentTypeModelX on AppointmentTypeModel {
  AppointmentType toEntity() => AppointmentType(
        id: id,
        clinicId: clinicId,
        name: name,
        durationMinutes: durationMinutes,
        colorHex: colorHex,
        description: description,
        isActive: isActive,
        createdAt: createdAt,
      );
}
