import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithApple();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, UserProfile?>> getProfile(String userId);
  Future<Either<Failure, UserProfile>> createProfile(CreateProfileParams params);
  Stream<Either<Failure, User?>> onAuthStateChange();
}
