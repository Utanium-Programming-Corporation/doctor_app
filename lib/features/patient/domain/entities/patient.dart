import 'package:equatable/equatable.dart';

import 'blood_type.dart';
import 'gender.dart';

class Patient extends Equatable {
  final String id;
  final String clinicId;
  final String patientNumber;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final Gender? gender;
  final String phoneNumber;
  final String? email;
  final String? nationalId;
  final BloodType? bloodType;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Patient({
    required this.id,
    required this.clinicId,
    required this.patientNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.gender,
    required this.phoneNumber,
    this.email,
    this.nationalId,
    this.bloodType,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }

  @override
  List<Object?> get props => [
        id,
        clinicId,
        patientNumber,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        phoneNumber,
        email,
        nationalId,
        bloodType,
        address,
        emergencyContactName,
        emergencyContactPhone,
        notes,
        isActive,
        createdAt,
        updatedAt,
      ];
}
