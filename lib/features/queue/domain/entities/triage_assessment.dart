import 'package:equatable/equatable.dart';

class TriageAssessment extends Equatable {
  final String id;
  final String queueTokenId;
  final String clinicId;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final int? heartRate;
  final double? temperature;
  final double? weight;
  final int? spo2;
  final String? chiefComplaint;
  final String recordedBy;
  final DateTime createdAt;

  const TriageAssessment({
    required this.id,
    required this.queueTokenId,
    required this.clinicId,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.weight,
    this.spo2,
    this.chiefComplaint,
    required this.recordedBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        queueTokenId,
        clinicId,
        bloodPressureSystolic,
        bloodPressureDiastolic,
        heartRate,
        temperature,
        weight,
        spo2,
        chiefComplaint,
        recordedBy,
        createdAt,
      ];
}
