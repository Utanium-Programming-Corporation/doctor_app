import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/availability_params.dart';
import '../models/appointment_type_model.dart';
import '../models/blocked_date_model.dart';
import '../models/provider_availability_model.dart';

abstract interface class AvailabilityRemoteDataSource {
  Future<List<AppointmentTypeModel>> getAppointmentTypes(String clinicId);
  Future<AppointmentTypeModel> createAppointmentType(
    CreateAppointmentTypeParams params,
  );
  Future<AppointmentTypeModel> updateAppointmentType(
    UpdateAppointmentTypeParams params,
  );
  Future<List<ProviderAvailabilityModel>> getProviderAvailability(
    GetProviderAvailabilityParams params,
  );
  Future<List<ProviderAvailabilityModel>> setProviderAvailability(
    SetProviderAvailabilityParams params,
  );
  Future<List<BlockedDateModel>> getBlockedDates(
    GetProviderAvailabilityParams params,
  );
  Future<BlockedDateModel> addBlockedDate(AddBlockedDateParams params);
  Future<void> removeBlockedDate(String id);
  Future<List<TimeSlot>> getAvailableSlots(GetAvailableSlotsParams params);
}

class AvailabilityRemoteDataSourceImpl implements AvailabilityRemoteDataSource {
  final SupabaseClient _supabase;

  AvailabilityRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<AppointmentTypeModel>> getAppointmentTypes(
    String clinicId,
  ) async {
    try {
      final data = await _supabase
          .from('appointment_types')
          .select()
          .eq('clinic_id', clinicId)
          .order('name', ascending: true);
      return data.map((row) => AppointmentTypeModel.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentTypeModel> createAppointmentType(
    CreateAppointmentTypeParams params,
  ) async {
    try {
      final data = await _supabase
          .from('appointment_types')
          .insert({
            'clinic_id': params.clinicId,
            'name': params.name,
            'duration_minutes': params.durationMinutes,
            'color_hex': params.colorHex,
            if (params.description != null) 'description': params.description,
            'is_active': params.isActive,
          })
          .select()
          .single();
      return AppointmentTypeModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentTypeModel> updateAppointmentType(
    UpdateAppointmentTypeParams params,
  ) async {
    try {
      final updates = <String, dynamic>{};
      if (params.name != null) updates['name'] = params.name;
      if (params.durationMinutes != null)
        updates['duration_minutes'] = params.durationMinutes;
      if (params.colorHex != null) updates['color_hex'] = params.colorHex;
      if (params.description != null)
        updates['description'] = params.description;
      if (params.isActive != null) updates['is_active'] = params.isActive;

      final data = await _supabase
          .from('appointment_types')
          .update(updates)
          .eq('id', params.id)
          .select()
          .single();
      return AppointmentTypeModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProviderAvailabilityModel>> getProviderAvailability(
    GetProviderAvailabilityParams params,
  ) async {
    try {
      final data = await _supabase
          .from('provider_availability')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .order('day_of_week', ascending: true);
      return data
          .map((row) => ProviderAvailabilityModel.fromJson(row))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProviderAvailabilityModel>> setProviderAvailability(
    SetProviderAvailabilityParams params,
  ) async {
    try {
      // Delete existing entries and replace with new set
      await _supabase
          .from('provider_availability')
          .delete()
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId);

      if (params.entries.isEmpty) return [];

      final rows = params.entries
          .map((e) => {
                'clinic_id': params.clinicId,
                'provider_id': params.providerId,
                'day_of_week': e.dayOfWeek,
                'start_time': e.startTime,
                'end_time': e.endTime,
                if (e.locationId != null) 'location_id': e.locationId,
                'is_active': e.isActive,
              })
          .toList();

      final data = await _supabase
          .from('provider_availability')
          .insert(rows)
          .select();
      return data
          .map((row) => ProviderAvailabilityModel.fromJson(row))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlockedDateModel>> getBlockedDates(
    GetProviderAvailabilityParams params,
  ) async {
    try {
      final data = await _supabase
          .from('provider_blocked_dates')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .order('blocked_date', ascending: true);
      return data.map((row) => BlockedDateModel.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlockedDateModel> addBlockedDate(AddBlockedDateParams params) async {
    try {
      final data = await _supabase
          .from('provider_blocked_dates')
          .insert({
            'clinic_id': params.clinicId,
            'provider_id': params.providerId,
            'blocked_date':
                params.blockedDate.toIso8601String().split('T')[0],
            if (params.reason != null) 'reason': params.reason,
          })
          .select()
          .single();
      return BlockedDateModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeBlockedDate(String id) async {
    try {
      await _supabase.from('provider_blocked_dates').delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TimeSlot>> getAvailableSlots(
    GetAvailableSlotsParams params,
  ) async {
    try {
      // 1. Get appointment type duration
      final typeData = await _supabase
          .from('appointment_types')
          .select('duration_minutes')
          .eq('id', params.appointmentTypeId)
          .single();
      final durationMinutes = typeData['duration_minutes'] as int;

      // 2. Check for blocked dates
      final dateStr = params.date.toIso8601String().split('T')[0];
      final blocked = await _supabase
          .from('provider_blocked_dates')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .eq('blocked_date', dateStr)
          .limit(1);
      if (blocked.isNotEmpty) return [];

      // 3. Get provider availability for this day of week
      // Flutter weekday: 1=Mon, 7=Sun. Our DB: 0=Sun, 1=Mon, ..., 6=Sat
      final weekday = params.date.weekday; // 1=Mon..7=Sun
      final dayOfWeek = weekday % 7; // 1=Mon, 2=Tue, ..., 6=Sat, 0=Sun
      final availabilityData = await _supabase
          .from('provider_availability')
          .select()
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .eq('day_of_week', dayOfWeek)
          .eq('is_active', true);

      if (availabilityData.isEmpty) return [];

      // 4. Get existing appointments for provider on this date (non-cancelled)
      final terminalStatuses = [
        AppointmentStatus.cancelled.toDbValue(),
        AppointmentStatus.noShow.toDbValue(),
      ];
      final existingData = await _supabase
          .from('appointments')
          .select('start_time, end_time')
          .eq('clinic_id', params.clinicId)
          .eq('provider_id', params.providerId)
          .gte('start_time', '${dateStr}T00:00:00.000Z')
          .lt('start_time', '${dateStr}T23:59:59.999Z')
          .not('status', 'in', '(${terminalStatuses.join(',')})');

      final existingSlots = existingData
          .map((row) => (
                start: DateTime.parse(row['start_time'] as String),
                end: DateTime.parse(row['end_time'] as String),
              ))
          .toList();

      // 5. Generate candidate slots for each availability window
      final slots = <TimeSlot>[];
      for (final avail in availabilityData) {
        final startParts = (avail['start_time'] as String).split(':');
        final endParts = (avail['end_time'] as String).split(':');

        final windowStart = DateTime(
          params.date.year,
          params.date.month,
          params.date.day,
          int.parse(startParts[0]),
          int.parse(startParts[1]),
        );
        final windowEnd = DateTime(
          params.date.year,
          params.date.month,
          params.date.day,
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );

        var slotStart = windowStart;
        while (slotStart.isBefore(windowEnd)) {
          final slotEnd =
              slotStart.add(Duration(minutes: durationMinutes));
          if (slotEnd.isAfter(windowEnd)) break;

          // Check no overlap with existing appointments
          final hasOverlap = existingSlots.any((existing) =>
              slotStart.isBefore(existing.end) &&
              slotEnd.isAfter(existing.start));

          if (!hasOverlap) {
            slots.add(TimeSlot(startTime: slotStart, endTime: slotEnd));
          }

          slotStart = slotStart.add(Duration(minutes: durationMinutes));
        }
      }

      slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      return slots;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
