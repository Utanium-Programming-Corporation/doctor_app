// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage_assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TriageAssessmentModel _$TriageAssessmentModelFromJson(
  Map<String, dynamic> json,
) => _TriageAssessmentModel(
  id: json['id'] as String,
  queueTokenId: json['queue_token_id'] as String,
  clinicId: json['clinic_id'] as String,
  bloodPressureSystolic: (json['blood_pressure_systolic'] as num?)?.toInt(),
  bloodPressureDiastolic: (json['blood_pressure_diastolic'] as num?)?.toInt(),
  heartRate: (json['heart_rate'] as num?)?.toInt(),
  temperature: (json['temperature'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  spo2: (json['spo2'] as num?)?.toInt(),
  chiefComplaint: json['chief_complaint'] as String?,
  recordedBy: json['recorded_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$TriageAssessmentModelToJson(
  _TriageAssessmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'queue_token_id': instance.queueTokenId,
  'clinic_id': instance.clinicId,
  'blood_pressure_systolic': instance.bloodPressureSystolic,
  'blood_pressure_diastolic': instance.bloodPressureDiastolic,
  'heart_rate': instance.heartRate,
  'temperature': instance.temperature,
  'weight': instance.weight,
  'spo2': instance.spo2,
  'chief_complaint': instance.chiefComplaint,
  'recorded_by': instance.recordedBy,
  'created_at': instance.createdAt.toIso8601String(),
};
