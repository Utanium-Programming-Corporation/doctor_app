import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/staff_assignment.dart';
import '../../domain/entities/staff_role.dart';

part 'staff_assignment_model.freezed.dart';
part 'staff_assignment_model.g.dart';

class _StaffRoleConverter implements JsonConverter<StaffRole, String> {
  const _StaffRoleConverter();

  @override
  StaffRole fromJson(String json) => StaffRole.fromDbValue(json);

  @override
  String toJson(StaffRole object) => object.dbValue;
}

@freezed
abstract class StaffAssignmentModel with _$StaffAssignmentModel {
  const factory StaffAssignmentModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @_StaffRoleConverter() required StaffRole role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'user_name') String? userName,
  }) = _StaffAssignmentModel;

  factory StaffAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$StaffAssignmentModelFromJson(json);
}

extension StaffAssignmentModelX on StaffAssignmentModel {
  StaffAssignment toEntity() => StaffAssignment(
        id: id,
        userId: userId,
        clinicId: clinicId,
        role: role,
        isActive: isActive,
        joinedAt: joinedAt,
        updatedAt: updatedAt,
        userName: userName,
      );
}
