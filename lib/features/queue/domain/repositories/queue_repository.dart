import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/queue_priority.dart';
import '../entities/queue_token.dart';

abstract class QueueRepository {
  Future<Either<Failure, QueueToken>> checkInPatient({
    required String clinicId,
    required String patientId,
    String? appointmentId,
    required String providerId,
    QueuePriority priority,
    String? locationId,
  });

  Stream<Either<Failure, List<QueueToken>>> watchQueueForClinic(
    String clinicId,
  );

  Stream<Either<Failure, List<QueueToken>>> watchMyQueue({
    required String clinicId,
    required String providerId,
  });

  Future<Either<Failure, QueueToken>> callNextPatient({
    required String clinicId,
    required String providerId,
  });

  Future<Either<Failure, QueueToken>> startConsultation(String tokenId);

  Future<Either<Failure, QueueToken>> completeQueueToken(String tokenId);

  Future<Either<Failure, QueueToken>> skipQueueToken(String tokenId);

  Future<Either<Failure, QueueToken>> markNoShow(String tokenId);
}
