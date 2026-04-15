import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/patient_repository.dart';
import '../models/patient_model.dart';

abstract interface class PatientRemoteDataSource {
  Future<PatientModel> createPatient(CreatePatientParams params);
  Future<PatientModel> updatePatient(UpdatePatientParams params);
  Future<PatientModel> getPatientById(String id);
  Future<List<PatientModel>> searchPatients(SearchPatientsParams params);
  Future<List<PatientModel>> getPatientsList(GetPatientsListParams params);
  Future<void> deactivatePatient(String id);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient _supabase;
  static const int _pageSize = 20;

  PatientRemoteDataSourceImpl(this._supabase);

  @override
  Future<PatientModel> createPatient(CreatePatientParams params) async {
    try {
      final data = await _supabase
          .from('patients')
          .insert({
            'clinic_id': params.clinicId,
            'first_name': params.firstName,
            'last_name': params.lastName,
            'date_of_birth': params.dateOfBirth.toIso8601String().split('T')[0],
            'phone_number': params.phoneNumber,
            if (params.gender != null) 'gender': params.gender!.toDbString(),
            if (params.email != null) 'email': params.email,
            if (params.nationalId != null) 'national_id': params.nationalId,
            if (params.bloodType != null)
              'blood_type': params.bloodType!.toDbValue(),
            if (params.address != null) 'address': params.address,
            if (params.emergencyContactName != null)
              'emergency_contact_name': params.emergencyContactName,
            if (params.emergencyContactPhone != null)
              'emergency_contact_phone': params.emergencyContactPhone,
            if (params.notes != null) 'notes': params.notes,
          })
          .select()
          .single();
      return PatientModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PatientModel> updatePatient(UpdatePatientParams params) async {
    try {
      final data = await _supabase
          .from('patients')
          .update({
            'first_name': params.firstName,
            'last_name': params.lastName,
            'date_of_birth': params.dateOfBirth.toIso8601String().split('T')[0],
            'phone_number': params.phoneNumber,
            'gender': params.gender?.toDbString(),
            'email': params.email,
            'national_id': params.nationalId,
            'blood_type': params.bloodType?.toDbValue(),
            'address': params.address,
            'emergency_contact_name': params.emergencyContactName,
            'emergency_contact_phone': params.emergencyContactPhone,
            'notes': params.notes,
          })
          .eq('id', params.id)
          .select()
          .single();
      return PatientModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PatientModel> getPatientById(String id) async {
    try {
      final data = await _supabase
          .from('patients')
          .select()
          .eq('id', id)
          .single();
      return PatientModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PatientModel>> searchPatients(SearchPatientsParams params) async {
    try {
      final q = '%${params.query}%';
      final data = await _supabase
          .from('patients')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('is_active', true)
          .or(
            'first_name.ilike.$q,'
            'last_name.ilike.$q,'
            'phone_number.ilike.$q,'
            'national_id.ilike.$q,'
            'patient_number.ilike.$q',
          )
          .order('last_name', ascending: true)
          .limit(_pageSize);
      return data
          .map((row) => PatientModel.fromJson(row))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PatientModel>> getPatientsList(
    GetPatientsListParams params,
  ) async {
    try {
      final from = params.page * _pageSize;
      final to = from + _pageSize - 1;
      final data = await _supabase
          .from('patients')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .range(from, to);
      return data
          .map((row) => PatientModel.fromJson(row))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deactivatePatient(String id) async {
    try {
      await _supabase
          .from('patients')
          .update({
            'is_active': false,
            'deactivated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
