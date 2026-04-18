import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/appointment_params.dart';
import '../models/appointment_model.dart';

abstract interface class AppointmentRemoteDataSource {
  Future<AppointmentModel> createAppointment(CreateAppointmentParams params);
  Future<AppointmentModel> getAppointmentById(String id);
  Future<List<AppointmentModel>> getAppointmentsForDate(
    GetAppointmentsForDateParams params,
  );
  Future<List<AppointmentModel>> getMyAppointmentsToday(
    GetMyAppointmentsTodayParams params,
  );
  Future<AppointmentModel> updateAppointmentStatus(
    UpdateAppointmentStatusParams params,
  );
  Future<void> cancelAppointment(CancelAppointmentParams params);
  Future<AppointmentModel> rescheduleAppointment(
    RescheduleAppointmentParams params,
  );
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final SupabaseClient _supabase;

  static const _joinSelect =
      '*, patients(first_name, last_name), appointment_types(name, color_hex)';

  AppointmentRemoteDataSourceImpl(this._supabase);

  @override
  Future<AppointmentModel> createAppointment(
    CreateAppointmentParams params,
  ) async {
    try {
      final data = await _supabase
          .from('appointments')
          .insert({
            'clinic_id': params.clinicId,
            'patient_id': params.patientId,
            'provider_id': params.providerId,
            'appointment_type_id': params.appointmentTypeId,
            if (params.locationId != null) 'location_id': params.locationId,
            'start_time': params.startTime.toIso8601String(),
            'end_time': params.endTime.toIso8601String(),
            if (params.notes != null) 'notes': params.notes,
            'created_by': params.createdBy,
          })
          .select(_joinSelect)
          .single();
      return AppointmentModelX.fromSupabaseJoin(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    try {
      final data = await _supabase
          .from('appointments')
          .select(_joinSelect)
          .eq('id', id)
          .single();
      return AppointmentModelX.fromSupabaseJoin(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsForDate(
    GetAppointmentsForDateParams params,
  ) async {
    try {
      final dateStr = params.date.toIso8601String().split('T')[0];
      var query = _supabase
          .from('appointments')
          .select(_joinSelect)
          .eq('clinic_id', params.clinicId)
          .gte('start_time', '${dateStr}T00:00:00.000Z')
          .lt('start_time', '${dateStr}T23:59:59.999Z');

      if (params.providerId != null) {
        query = query.eq('provider_id', params.providerId!);
      }

      final data = await query.order('start_time', ascending: true);
      return data.map((row) => AppointmentModelX.fromSupabaseJoin(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AppointmentModel>> getMyAppointmentsToday(
    GetMyAppointmentsTodayParams params,
  ) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final data = await _supabase
          .from('appointments')
          .select(_joinSelect)
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .gte('start_time', '${dateStr}T00:00:00.000Z')
          .lt('start_time', '${dateStr}T23:59:59.999Z')
          .order('start_time', ascending: true);
      return data.map((row) => AppointmentModelX.fromSupabaseJoin(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> updateAppointmentStatus(
    UpdateAppointmentStatusParams params,
  ) async {
    try {
      final data = await _supabase
          .from('appointments')
          .update({'status': params.newStatus.toDbValue()})
          .eq('id', params.appointmentId)
          .select(_joinSelect)
          .single();
      return AppointmentModelX.fromSupabaseJoin(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> cancelAppointment(CancelAppointmentParams params) async {
    try {
      await _supabase.from('appointments').update({
        'status': 'cancelled',
        if (params.reason != null) 'cancel_reason': params.reason,
      }).eq('id', params.appointmentId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(
    RescheduleAppointmentParams params,
  ) async {
    try {
      final data = await _supabase
          .from('appointments')
          .update({
            'start_time': params.newStartTime.toIso8601String(),
            'end_time': params.newEndTime.toIso8601String(),
            'status': 'scheduled',
            if (params.reason != null) 'cancel_reason': params.reason,
          })
          .eq('id', params.appointmentId)
          .select(_joinSelect)
          .single();
      return AppointmentModelX.fromSupabaseJoin(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
