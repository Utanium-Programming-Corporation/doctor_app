import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCaseWithoutParams<User?> {
  final AuthRepository _repository;
  const GetCurrentUser(this._repository);

  @override
  FutureResult<User?> call() => _repository.getCurrentUser();
}
