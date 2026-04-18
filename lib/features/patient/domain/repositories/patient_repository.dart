import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/blood_type.dart';
import '../entities/gender.dart';
import '../entities/patient.dart';

abstract interface class PatientRepository {
  FutureResult<Patient> createPatient(CreatePatientParams params);
  FutureResult<Patient> updatePatient(UpdatePatientParams params);
  FutureResult<Patient> getPatientById(String id);
  FutureResult<List<Patient>> searchPatients(SearchPatientsParams params);
  FutureResult<List<Patient>> getPatientsList(GetPatientsListParams params);
  FutureResult<void> deactivatePatient(String id);
}

class CreatePatientParams extends Equatable {
  final String clinicId;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final Gender? gender;
  final String? email;
  final String? nationalId;
  final BloodType? bloodType;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;

  const CreatePatientParams({
    required this.clinicId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.gender,
    this.email,
    this.nationalId,
    this.bloodType,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notes,
  });

  @override
  List<Object?> get props => [
        clinicId,
        firstName,
        lastName,
        dateOfBirth,
        phoneNumber,
        gender,
        email,
        nationalId,
        bloodType,
        address,
        emergencyContactName,
        emergencyContactPhone,
        notes,
      ];
}

class UpdatePatientParams extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final Gender? gender;
  final String? email;
  final String? nationalId;
  final BloodType? bloodType;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;

  const UpdatePatientParams({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.gender,
    this.email,
    this.nationalId,
    this.bloodType,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        dateOfBirth,
        phoneNumber,
        gender,
        email,
        nationalId,
        bloodType,
        address,
        emergencyContactName,
        emergencyContactPhone,
        notes,
      ];
}

class SearchPatientsParams extends Equatable {
  final String clinicId;
  final String query;

  const SearchPatientsParams({
    required this.clinicId,
    required this.query,
  });

  @override
  List<Object?> get props => [clinicId, query];
}

class GetPatientsListParams extends Equatable {
  final String clinicId;
  final int page;

  const GetPatientsListParams({
    required this.clinicId,
    this.page = 0,
  });

  @override
  List<Object?> get props => [clinicId, page];
}
