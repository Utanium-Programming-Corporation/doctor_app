import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOut implements UseCaseWithoutParams<void> {
  final AuthRepository _repository;
  const SignOut(this._repository);

  @override
  FutureResult<void> call() => _repository.signOut();
}
