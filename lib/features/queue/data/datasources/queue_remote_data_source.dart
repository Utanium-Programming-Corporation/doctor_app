import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/queue_priority.dart';
import '../../domain/entities/queue_token_status.dart';
import '../models/queue_token_model.dart';

abstract interface class QueueRemoteDataSource {
  Future<QueueTokenModel> checkInPatient({
    required String clinicId,
    required String patientId,
    String? appointmentId,
    required String providerId,
    QueuePriority priority,
    String? locationId,
  });

  Stream<List<QueueTokenModel>> watchQueueForClinic(String clinicId);

  Stream<List<QueueTokenModel>> watchMyQueue({
    required String clinicId,
    required String providerId,
  });

  Future<QueueTokenModel> callNextPatient({
    required String clinicId,
    required String providerId,
  });

  Future<QueueTokenModel> updateTokenStatus({
    required String tokenId,
    required String status,
    DateTime? calledAt,
    DateTime? startedAt,
    DateTime? completedAt,
  });

  Future<QueueTokenModel> skipToken(String tokenId);

  Future<QueueTokenModel> getTokenById(String tokenId);
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final SupabaseClient _supabase;

  static const _joinSelect =
      '*, patients(first_name, last_name), profiles(full_name, display_name)';

  QueueRemoteDataSourceImpl(this._supabase);

  @override
  Future<QueueTokenModel> checkInPatient({
    required String clinicId,
    required String patientId,
    String? appointmentId,
    required String providerId,
    QueuePriority priority = QueuePriority.normal,
    String? locationId,
  }) async {
    try {
      final rpcResult = await _supabase.rpc('check_in_patient', params: {
        'p_clinic_id': clinicId,
        'p_patient_id': patientId,
        if (appointmentId != null) 'p_appointment_id': appointmentId,
        'p_provider_id': providerId,
        'p_priority': priority.toDbValue(),
        if (locationId != null) 'p_location_id': locationId,
      });
      final tokenId = rpcResult['token_id'] as String;
      return getTokenById(tokenId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<QueueTokenModel>> watchQueueForClinic(String clinicId) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _supabase
        .from('queue_tokens')
        .stream(primaryKey: ['id'])
        .eq('clinic_id', clinicId)
        .order('created_at', ascending: true)
        .map((rows) => rows
            .where((r) {
              final createdAt = r['created_at'] as String? ?? '';
              return createdAt.startsWith(today);
            })
            .map(QueueTokenModelX.fromSupabaseJoin)
            .toList());
  }

  @override
  Stream<List<QueueTokenModel>> watchMyQueue({
    required String clinicId,
    required String providerId,
  }) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _supabase
        .from('queue_tokens')
        .stream(primaryKey: ['id'])
        .eq('clinic_id', clinicId)
        .order('created_at', ascending: true)
        .map((rows) => rows
            .where((r) {
              final createdAt = r['created_at'] as String? ?? '';
              final rowProviderId = r['provider_id'] as String? ?? '';
              return createdAt.startsWith(today) && rowProviderId == providerId;
            })
            .map(QueueTokenModelX.fromSupabaseJoin)
            .toList());
  }

  @override
  Future<QueueTokenModel> callNextPatient({
    required String clinicId,
    required String providerId,
  }) async {
    try {
      final tokenId = await _supabase.rpc('call_next_patient', params: {
        'p_clinic_id': clinicId,
        'p_provider_id': providerId,
      }) as String?;
      if (tokenId == null) {
        throw const ServerException('No waiting patients in queue');
      }
      return getTokenById(tokenId);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<QueueTokenModel> updateTokenStatus({
    required String tokenId,
    required String status,
    DateTime? calledAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) async {
    try {
      final current = await getTokenById(tokenId);
      final nextStatus = QueueTokenStatus.fromDbValue(status);
      if (!current.status.isValidTransition(nextStatus)) {
        throw ServerException(
          'Invalid transition: cannot move from '
          '${current.status.displayName} to ${nextStatus.displayName}',
        );
      }
      final updates = <String, dynamic>{'status': status};
      if (calledAt != null) updates['called_at'] = calledAt.toIso8601String();
      if (startedAt != null) {
        updates['started_at'] = startedAt.toIso8601String();
      }
      if (completedAt != null) {
        updates['completed_at'] = completedAt.toIso8601String();
      }
      final data = await _supabase
          .from('queue_tokens')
          .update(updates)
          .eq('id', tokenId)
          .select(_joinSelect)
          .single();
      return QueueTokenModelX.fromSupabaseJoin(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<QueueTokenModel> skipToken(String tokenId) async {
    try {
      final current = await getTokenById(tokenId);
      if (!current.status.isValidTransition(QueueTokenStatus.skipped)) {
        throw ServerException(
          'Invalid transition: cannot skip from ${current.status.displayName}',
        );
      }
      final data = await _supabase
          .from('queue_tokens')
          .update({
            'status': 'skipped',
            'skip_count': current.skipCount + 1,
          })
          .eq('id', tokenId)
          .select(_joinSelect)
          .single();
      return QueueTokenModelX.fromSupabaseJoin(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<QueueTokenModel> getTokenById(String tokenId) async {
    try {
      final data = await _supabase
          .from('queue_tokens')
          .select(_joinSelect)
          .eq('id', tokenId)
          .single();
      return QueueTokenModelX.fromSupabaseJoin(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
