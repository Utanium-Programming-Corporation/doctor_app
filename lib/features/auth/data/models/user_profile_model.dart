import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

class _UserRoleConverter implements JsonConverter<UserRole, String> {
  const _UserRoleConverter();

  @override
  UserRole fromJson(String json) => UserRole.fromDbValue(json);

  @override
  String toJson(UserRole object) => object.dbValue;
}

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @_UserRoleConverter() @Default(UserRole.doctor) UserRole role,
    @JsonKey(name: 'preferred_language') @Default('en') String preferredLanguage,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

extension UserProfileModelX on UserProfileModel {
  UserProfile toEntity() => UserProfile(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
        preferredLanguage: preferredLanguage,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
