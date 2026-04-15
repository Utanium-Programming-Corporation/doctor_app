// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_assignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffAssignmentModel _$StaffAssignmentModelFromJson(
  Map<String, dynamic> json,
) => _StaffAssignmentModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  clinicId: json['clinic_id'] as String,
  role: const _StaffRoleConverter().fromJson(json['role'] as String),
  isActive: json['is_active'] as bool? ?? true,
  joinedAt: DateTime.parse(json['joined_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  userName: json['user_name'] as String?,
);

Map<String, dynamic> _$StaffAssignmentModelToJson(
  _StaffAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'clinic_id': instance.clinicId,
  'role': const _StaffRoleConverter().toJson(instance.role),
  'is_active': instance.isActive,
  'joined_at': instance.joinedAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'user_name': instance.userName,
};
