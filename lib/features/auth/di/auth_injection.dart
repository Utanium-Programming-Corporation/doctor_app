import 'package:get_it/get_it.dart';

import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/create_user_profile.dart';
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/get_user_profile.dart';
import '../domain/usecases/sign_in_with_apple.dart';
import '../domain/usecases/sign_in_with_google.dart';
import '../domain/usecases/sign_out.dart';
import '../domain/usecases/watch_auth_state.dart';
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/auth_cubit_refresh_listenable.dart';

Future<void> initAuth() async {
  final sl = GetIt.instance;

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => CreateUserProfile(sl()));
  sl.registerLazySingleton(() => WatchAuthState(sl()));

  // Cubit (singleton — drives global auth state)
  sl.registerLazySingleton(
    () => AuthCubit(
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      getUserProfile: sl(),
      createUserProfile: sl(),
      watchAuthState: sl(),
    ),
  );

  // GoRouter refresh bridge (depends on AuthCubit)
  sl.registerLazySingleton(() => AuthCubitRefreshListenable(sl()));
}
