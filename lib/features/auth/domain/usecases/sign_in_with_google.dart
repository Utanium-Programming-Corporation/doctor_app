import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle implements UseCaseWithoutParams<User> {
  final AuthRepository _repository;
  const SignInWithGoogle(this._repository);

  @override
  FutureResult<User> call() => _repository.signInWithGoogle();
}
