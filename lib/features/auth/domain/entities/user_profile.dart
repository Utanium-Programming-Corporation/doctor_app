import 'package:equatable/equatable.dart';

enum UserRole {
  superAdmin,
  clinicAdmin,
  doctor,
  nurse,
  receptionist,
  pharmacist;

  String get dbValue => switch (this) {
        UserRole.superAdmin => 'super_admin',
        UserRole.clinicAdmin => 'clinic_admin',
        UserRole.doctor => 'doctor',
        UserRole.nurse => 'nurse',
        UserRole.receptionist => 'receptionist',
        UserRole.pharmacist => 'pharmacist',
      };

  static UserRole fromDbValue(String value) => switch (value) {
        'super_admin' => UserRole.superAdmin,
        'clinic_admin' => UserRole.clinicAdmin,
        'doctor' => UserRole.doctor,
        'nurse' => UserRole.nurse,
        'receptionist' => UserRole.receptionist,
        'pharmacist' => UserRole.pharmacist,
        _ => UserRole.doctor,
      };
}

class UserProfile extends Equatable {
  final String id;
  final String fullName;
  final String? phoneNumber;
  final UserRole role;
  final String preferredLanguage;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    required this.preferredLanguage,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        role,
        preferredLanguage,
        avatarUrl,
        createdAt,
        updatedAt,
      ];
}

class CreateProfileParams extends Equatable {
  final String fullName;
  final String? phoneNumber;
  final String preferredLanguage;

  const CreateProfileParams({
    required this.fullName,
    this.phoneNumber,
    this.preferredLanguage = 'en',
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, preferredLanguage];
}
