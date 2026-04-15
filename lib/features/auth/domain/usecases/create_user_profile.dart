import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class CreateUserProfile
    implements UseCaseWithParams<UserProfile, CreateProfileParams> {
  final AuthRepository _repository;
  const CreateUserProfile(this._repository);

  @override
  FutureResult<UserProfile> call(CreateProfileParams params) =>
      _repository.createProfile(params);
}
