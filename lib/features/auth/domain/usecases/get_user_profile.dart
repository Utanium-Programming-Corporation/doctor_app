import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class GetUserProfile implements UseCaseWithParams<UserProfile?, String> {
  final AuthRepository _repository;
  const GetUserProfile(this._repository);

  @override
  FutureResult<UserProfile?> call(String userId) =>
      _repository.getProfile(userId);
}
