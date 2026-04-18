import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    debugPrint('[AuthRepo] signInWithGoogle called');
    if (!await _networkInfo.isConnected) {
      debugPrint('[AuthRepo] No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      debugPrint('[AuthRepo] signInWithGoogle succeeded: ${user.id}');
      return Right(user);
    } on AuthException catch (e) {
      debugPrint('[AuthRepo] signInWithGoogle AuthException: ${e.message}');
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      return Right(await _remoteDataSource.signInWithApple());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      return Right(_remoteDataSource.getCurrentUser());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getProfile(String userId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.getProfile(userId);
      return Right(model?.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> createProfile(
    CreateProfileParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = await _remoteDataSource.createProfile(params);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, User?>> onAuthStateChange() {
    return _remoteDataSource
        .onAuthStateChange()
        .map<Either<Failure, User?>>((user) => Right(user))
        .handleError(
          (Object error) => Left<Failure, User?>(
            AuthFailure(error.toString()),
          ),
        );
  }
}
