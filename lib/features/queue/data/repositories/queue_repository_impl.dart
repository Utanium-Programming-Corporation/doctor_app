import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/queue_priority.dart';
import '../../domain/entities/queue_token.dart';
import '../../domain/entities/queue_token_status.dart';
import '../../domain/repositories/queue_repository.dart';
import '../datasources/queue_remote_data_source.dart';
import '../models/queue_token_model.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  QueueRepositoryImpl({
    required QueueRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, QueueToken>> checkInPatient({
    required String clinicId,
    required String patientId,
    String? appointmentId,
    required String providerId,
    QueuePriority priority = QueuePriority.normal,
    String? locationId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.checkInPatient(
        clinicId: clinicId,
        patientId: patientId,
        appointmentId: appointmentId,
        providerId: providerId,
        priority: priority,
        locationId: locationId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<QueueToken>>> watchQueueForClinic(
    String clinicId,
  ) {
    return _remoteDataSource
        .watchQueueForClinic(clinicId)
        .map<Either<Failure, List<QueueToken>>>(
          (models) => Right(models.map((m) => m.toEntity()).toList()),
        )
        .handleError(
          (Object e) => Left(
            ServerFailure(e is ServerException ? e.message : e.toString()),
          ),
        );
  }

  @override
  Stream<Either<Failure, List<QueueToken>>> watchMyQueue({
    required String clinicId,
    required String providerId,
  }) {
    return _remoteDataSource
        .watchMyQueue(clinicId: clinicId, providerId: providerId)
        .map<Either<Failure, List<QueueToken>>>(
          (models) => Right(models.map((m) => m.toEntity()).toList()),
        )
        .handleError(
          (Object e) => Left(
            ServerFailure(e is ServerException ? e.message : e.toString()),
          ),
        );
  }

  @override
  Future<Either<Failure, QueueToken>> callNextPatient({
    required String clinicId,
    required String providerId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.callNextPatient(
        clinicId: clinicId,
        providerId: providerId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QueueToken>> startConsultation(
    String tokenId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.updateTokenStatus(
        tokenId: tokenId,
        status: QueueTokenStatus.inProgress.toDbValue(),
        startedAt: DateTime.now(),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QueueToken>> completeQueueToken(
    String tokenId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.updateTokenStatus(
        tokenId: tokenId,
        status: QueueTokenStatus.completed.toDbValue(),
        completedAt: DateTime.now(),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QueueToken>> skipQueueToken(String tokenId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.skipToken(tokenId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QueueToken>> markNoShow(String tokenId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.updateTokenStatus(
        tokenId: tokenId,
        status: QueueTokenStatus.noShow.toDbValue(),
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
