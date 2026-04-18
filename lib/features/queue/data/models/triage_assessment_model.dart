import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/triage_assessment.dart';

part 'triage_assessment_model.freezed.dart';
part 'triage_assessment_model.g.dart';

@freezed
abstract class TriageAssessmentModel with _$TriageAssessmentModel {
  const factory TriageAssessmentModel({
    required String id,
    @JsonKey(name: 'queue_token_id') required String queueTokenId,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'blood_pressure_systolic') int? bloodPressureSystolic,
    @JsonKey(name: 'blood_pressure_diastolic') int? bloodPressureDiastolic,
    @JsonKey(name: 'heart_rate') int? heartRate,
    double? temperature,
    double? weight,
    int? spo2,
    @JsonKey(name: 'chief_complaint') String? chiefComplaint,
    @JsonKey(name: 'recorded_by') required String recordedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TriageAssessmentModel;

  factory TriageAssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$TriageAssessmentModelFromJson(json);
}

extension TriageAssessmentModelX on TriageAssessmentModel {
  TriageAssessment toEntity() => TriageAssessment(
        id: id,
        queueTokenId: queueTokenId,
        clinicId: clinicId,
        bloodPressureSystolic: bloodPressureSystolic,
        bloodPressureDiastolic: bloodPressureDiastolic,
        heartRate: heartRate,
        temperature: temperature,
        weight: weight,
        spo2: spo2,
        chiefComplaint: chiefComplaint,
        recordedBy: recordedBy,
        createdAt: createdAt,
      );
}
