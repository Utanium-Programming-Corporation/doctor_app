import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/triage_assessment.dart';
import '../../domain/repositories/triage_repository.dart';
import '../datasources/triage_remote_data_source.dart';
import '../models/triage_assessment_model.dart';

class TriageRepositoryImpl implements TriageRepository {
  final TriageRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  TriageRepositoryImpl({
    required TriageRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
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
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.recordTriage(
        queueTokenId: queueTokenId,
        clinicId: clinicId,
        recordedBy: recordedBy,
        bloodPressureSystolic: bloodPressureSystolic,
        bloodPressureDiastolic: bloodPressureDiastolic,
        heartRate: heartRate,
        temperature: temperature,
        weight: weight,
        spo2: spo2,
        chiefComplaint: chiefComplaint,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TriageAssessment?>> getTriageForToken(
    String queueTokenId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.getTriageForToken(queueTokenId);
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
