import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_type.dart';
import '../../domain/entities/blocked_date.dart';
import '../../domain/entities/provider_availability.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/availability_params.dart';
import '../../domain/repositories/availability_repository.dart';
import '../datasources/availability_remote_data_source.dart';
import '../models/appointment_type_model.dart';
import '../models/blocked_date_model.dart';
import '../models/provider_availability_model.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final AvailabilityRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AvailabilityRepositoryImpl({
    required AvailabilityRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<AppointmentType>>> getAppointmentTypes(
    String clinicId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final models = await _remoteDataSource.getAppointmentTypes(clinicId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppointmentType>> createAppointmentType(
    CreateAppointmentTypeParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.createAppointmentType(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppointmentType>> updateAppointmentType(
    UpdateAppointmentTypeParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.updateAppointmentType(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProviderAvailability>>> getProviderAvailability(
    GetProviderAvailabilityParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final models = await _remoteDataSource.getProviderAvailability(params);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProviderAvailability>>> setProviderAvailability(
    SetProviderAvailabilityParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final models = await _remoteDataSource.setProviderAvailability(params);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlockedDate>>> getBlockedDates(
    GetProviderAvailabilityParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final models = await _remoteDataSource.getBlockedDates(params);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BlockedDate>> addBlockedDate(
    AddBlockedDateParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.addBlockedDate(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBlockedDate(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await _remoteDataSource.removeBlockedDate(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableSlots(
    GetAvailableSlotsParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final slots = await _remoteDataSource.getAvailableSlots(params);
      return Right(slots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
