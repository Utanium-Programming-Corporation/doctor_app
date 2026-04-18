import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithApple implements UseCaseWithoutParams<User> {
  final AuthRepository _repository;
  const SignInWithApple(this._repository);

  @override
  FutureResult<User> call() => _repository.signInWithApple();
}
