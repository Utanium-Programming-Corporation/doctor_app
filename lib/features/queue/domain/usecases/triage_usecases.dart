import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/triage_assessment.dart';
import '../repositories/triage_repository.dart';

class RecordTriageParams extends Equatable {
  final String queueTokenId;
  final String clinicId;
  final String recordedBy;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final int? heartRate;
  final double? temperature;
  final double? weight;
  final int? spo2;
  final String? chiefComplaint;

  const RecordTriageParams({
    required this.queueTokenId,
    required this.clinicId,
    required this.recordedBy,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.weight,
    this.spo2,
    this.chiefComplaint,
  });

  @override
  List<Object?> get props => [
        queueTokenId,
        clinicId,
        recordedBy,
        bloodPressureSystolic,
        bloodPressureDiastolic,
        heartRate,
        temperature,
        weight,
        spo2,
        chiefComplaint,
      ];
}

class RecordTriage
    implements UseCaseWithParams<TriageAssessment, RecordTriageParams> {
  final TriageRepository _repository;

  RecordTriage(this._repository);

  @override
  FutureResult<TriageAssessment> call(RecordTriageParams params) =>
      _repository.recordTriage(
        queueTokenId: params.queueTokenId,
        clinicId: params.clinicId,
        recordedBy: params.recordedBy,
        bloodPressureSystolic: params.bloodPressureSystolic,
        bloodPressureDiastolic: params.bloodPressureDiastolic,
        heartRate: params.heartRate,
        temperature: params.temperature,
        weight: params.weight,
        spo2: params.spo2,
        chiefComplaint: params.chiefComplaint,
      );
}

class GetTriageForToken
    implements UseCaseWithParams<TriageAssessment?, String> {
  final TriageRepository _repository;

  GetTriageForToken(this._repository);

  @override
  FutureResult<TriageAssessment?> call(String params) =>
      _repository.getTriageForToken(params);
}
