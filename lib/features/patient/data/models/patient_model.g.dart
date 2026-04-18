// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientModel _$PatientModelFromJson(Map<String, dynamic> json) =>
    _PatientModel(
      id: json['id'] as String,
      clinicId: json['clinic_id'] as String,
      patientNumber: json['patient_number'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: const _GenderConverter().fromJson(json['gender'] as String?),
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      nationalId: json['national_id'] as String?,
      bloodType: const _BloodTypeConverter().fromJson(
        json['blood_type'] as String?,
      ),
      address: json['address'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PatientModelToJson(_PatientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'patient_number': instance.patientNumber,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date_of_birth': instance.dateOfBirth.toIso8601String(),
      'gender': const _GenderConverter().toJson(instance.gender),
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'national_id': instance.nationalId,
      'blood_type': const _BloodTypeConverter().toJson(instance.bloodType),
      'address': instance.address,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'notes': instance.notes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
