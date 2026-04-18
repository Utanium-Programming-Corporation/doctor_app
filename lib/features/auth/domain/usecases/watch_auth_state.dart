import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class WatchAuthState implements StreamUseCaseWithoutParams<User?> {
  final AuthRepository _repository;
  const WatchAuthState(this._repository);

  @override
  StreamResult<User?> call() => _repository.onAuthStateChange();
}
