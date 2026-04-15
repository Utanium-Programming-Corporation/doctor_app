import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/triage_assessment.dart';

abstract class TriageRepository {
  Future<Either<Failure, TriageAssessment>> recordTriage({
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

  Future<Either<Failure, TriageAssessment?>> getTriageForToken(
    String queueTokenId,
  );
}
