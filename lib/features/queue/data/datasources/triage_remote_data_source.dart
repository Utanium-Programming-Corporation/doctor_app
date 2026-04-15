import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/triage_assessment_model.dart';

abstract interface class TriageRemoteDataSource {
  Future<TriageAssessmentModel> recordTriage({
    required String queueTokenId,
    required String clinicId,
    required String recordedBy,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    int? heartRate,
    double? temperature,
    double? weight,
    int? spo2,
    String? chiefComplaint,
  });

  Future<TriageAssessmentModel?> getTriageForToken(String queueTokenId);
}

class TriageRemoteDataSourceImpl implements TriageRemoteDataSource {
  final SupabaseClient _supabase;

  TriageRemoteDataSourceImpl(this._supabase);

  @override
  Future<TriageAssessmentModel> recordTriage({
    required String queueTokenId,
    required String clinicId,
    required String recordedBy,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    int? heartRate,
    double? temperature,
    double? weight,
    int? spo2,
    String? chiefComplaint,
  }) async {
    try {
      final data = await _supabase
          .from('triage_assessments')
          .insert({
            'queue_token_id': queueTokenId,
            'clinic_id': clinicId,
            'recorded_by': recordedBy,
            if (bloodPressureSystolic != null)
              'blood_pressure_systolic': bloodPressureSystolic,
            if (bloodPressureDiastolic != null)
              'blood_pressure_diastolic': bloodPressureDiastolic,
            if (heartRate != null) 'heart_rate': heartRate,
            if (temperature != null) 'temperature': temperature,
            if (weight != null) 'weight': weight,
            if (spo2 != null) 'spo2': spo2,
            if (chiefComplaint != null && chiefComplaint.isNotEmpty)
              'chief_complaint': chiefComplaint,
          })
          .select()
          .single();
      return TriageAssessmentModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TriageAssessmentModel?> getTriageForToken(
    String queueTokenId,
  ) async {
    try {
      final data = await _supabase
          .from('triage_assessments')
          .select()
          .eq('queue_token_id', queueTokenId)
          .maybeSingle();
      if (data == null) return null;
      return TriageAssessmentModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
