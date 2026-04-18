import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/blood_type.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/patient.dart';

part 'patient_model.freezed.dart';
part 'patient_model.g.dart';

class _GenderConverter implements JsonConverter<Gender?, String?> {
  const _GenderConverter();

  @override
  Gender? fromJson(String? json) =>
      json != null ? Gender.fromString(json) : null;

  @override
  String? toJson(Gender? object) => object?.toDbString();
}

class _BloodTypeConverter implements JsonConverter<BloodType?, String?> {
  const _BloodTypeConverter();

  @override
  BloodType? fromJson(String? json) =>
      json != null ? BloodType.fromDbValue(json) : null;

  @override
  String? toJson(BloodType? object) => object?.toDbValue();
}

@freezed
abstract class PatientModel with _$PatientModel {
  const factory PatientModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'patient_number') required String patientNumber,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'date_of_birth') required DateTime dateOfBirth,
    @_GenderConverter() Gender? gender,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    String? email,
    @JsonKey(name: 'national_id') String? nationalId,
    @JsonKey(name: 'blood_type') @_BloodTypeConverter() BloodType? bloodType,
    String? address,
    @JsonKey(name: 'emergency_contact_name') String? emergencyContactName,
    @JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone,
    String? notes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PatientModel;

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);
}

extension PatientModelX on PatientModel {
  Patient toEntity() => Patient(
        id: id,
        clinicId: clinicId,
        patientNumber: patientNumber,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        email: email,
        nationalId: nationalId,
        bloodType: bloodType,
        address: address,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        notes: notes,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
