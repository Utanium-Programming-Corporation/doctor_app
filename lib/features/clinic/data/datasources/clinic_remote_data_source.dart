import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/staff_role.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../models/clinic_model.dart';
import '../models/staff_assignment_model.dart';

abstract interface class ClinicRemoteDataSource {
  Future<ClinicModel> createClinic(CreateClinicParams params);
  Future<StaffAssignmentModel> joinClinicByCode(JoinClinicByCodeParams params);
  Future<List<StaffAssignmentModel>> getMyClinicAssignments();
  Future<List<StaffAssignmentModel>> getClinicStaff(String clinicId);
  Future<ClinicModel> updateClinic(UpdateClinicParams params);
  Future<StaffAssignmentModel> updateStaffRole(UpdateStaffRoleParams params);
  Future<void> deactivateStaff(String assignmentId);
  Future<ClinicModel> regenerateInviteCode(String clinicId);
  Future<ClinicModel> getClinicByInviteCode(String inviteCode);
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final SupabaseClient _supabase;

  ClinicRemoteDataSourceImpl(this._supabase);

  @override
  Future<ClinicModel> createClinic(CreateClinicParams params) async {
    try {
      final data = await _supabase.rpc(
        'create_clinic_with_defaults',
        params: {
          'p_name': params.name,
          'p_phone': params.phone,
          'p_address': params.address,
          'p_type': params.type.dbValue,
        },
      );
      return ClinicModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ClinicModel> getClinicByInviteCode(String inviteCode) async {
    try {
      final data = await _supabase
          .from('clinics')
          .select()
          .eq('invite_code', inviteCode)
          .eq('is_active', true)
          .maybeSingle();
      if (data == null) {
        throw const ServerException('Invalid or expired invite code');
      }
      return ClinicModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<StaffAssignmentModel> joinClinicByCode(
    JoinClinicByCodeParams params,
  ) async {
    try {
      final clinic = await getClinicByInviteCode(params.inviteCode);
      final userId = _supabase.auth.currentUser!.id;

      // Check if already a member
      final existing = await _supabase
          .from('staff_clinic_assignments')
          .select()
          .eq('user_id', userId)
          .eq('clinic_id', clinic.id)
          .maybeSingle();

      if (existing != null) {
        throw const ServerException(
          'You are already a member of this clinic',
        );
      }

      final data = await _supabase
          .from('staff_clinic_assignments')
          .insert({
            'user_id': userId,
            'clinic_id': clinic.id,
            'role': StaffRole.doctor.dbValue,
          })
          .select()
          .single();
      return StaffAssignmentModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StaffAssignmentModel>> getMyClinicAssignments() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('staff_clinic_assignments')
          .select('*, clinics(name)')
          .eq('user_id', userId)
          .eq('is_active', true);
      return (data as List).map((row) {
        final clinicData = row['clinics'] as Map<String, dynamic>?;
        final mapped = Map<String, dynamic>.from(row);
        mapped.remove('clinics');
        if (clinicData != null) {
          mapped['user_name'] = clinicData['name'];
        }
        return StaffAssignmentModel.fromJson(mapped);
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StaffAssignmentModel>> getClinicStaff(String clinicId) async {
    try {
      final data = await _supabase
          .from('staff_clinic_assignments')
          .select('*, profiles(full_name)')
          .eq('clinic_id', clinicId)
          .eq('is_active', true);
      return (data as List).map((row) {
        final profileData = row['profiles'] as Map<String, dynamic>?;
        final mapped = Map<String, dynamic>.from(row);
        mapped.remove('profiles');
        if (profileData != null) {
          mapped['user_name'] = profileData['full_name'];
        }
        return StaffAssignmentModel.fromJson(mapped);
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ClinicModel> updateClinic(UpdateClinicParams params) async {
    try {
      final data = await _supabase
          .from('clinics')
          .update({
            'name': params.name,
            'phone': params.phone,
            'address': params.address,
            'type': params.type.dbValue,
          })
          .eq('id', params.clinicId)
          .select()
          .single();
      return ClinicModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<StaffAssignmentModel> updateStaffRole(
    UpdateStaffRoleParams params,
  ) async {
    try {
      final data = await _supabase
          .from('staff_clinic_assignments')
          .update({'role': params.newRole.dbValue})
          .eq('id', params.assignmentId)
          .select()
          .single();
      return StaffAssignmentModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deactivateStaff(String assignmentId) async {
    try {
      await _supabase.rpc(
        'deactivate_staff_member',
        params: {'p_assignment_id': assignmentId},
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ClinicModel> regenerateInviteCode(String clinicId) async {
    try {
      final data = await _supabase.rpc(
        'regenerate_clinic_invite_code',
        params: {'p_clinic_id': clinicId},
      );
      return ClinicModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
