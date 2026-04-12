import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/network_info.dart';
import '../router/app_router.dart';
import '../router/auth_state.dart';

final sl = GetIt.instance;

/// Registers all core dependencies.
///
/// Call this once during app startup after Supabase has been initialized.
///
/// ## Per-feature registration pattern
///
/// Each feature module should expose its own `initX()` function:
///
/// ```dart
/// // lib/features/scheduling/di/scheduling_injection.dart
/// Future<void> initScheduling() async {
///   // Data sources
///   sl.registerLazySingleton<SchedulingRemoteDataSource>(
///     () => SchedulingRemoteDataSourceImpl(sl()),
///   );
///   // Repositories
///   sl.registerLazySingleton<SchedulingRepository>(
///     () => SchedulingRepositoryImpl(
///       remoteDataSource: sl(),
///       networkInfo: sl(),
///     ),
///   );
///   // Use cases
///   sl.registerLazySingleton(() => GetDoctorSchedule(sl()));
///   // Cubits
///   sl.registerFactory(() => ScheduleCubit(sl()));
/// }
/// ```
///
/// Then call `initScheduling()` from this file or from `main.dart`.
Future<void> initCoreDependencies() async {
  // External
  sl.registerLazySingleton(() => Connectivity());
  sl.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AuthStateNotifier());

  // Router
  sl.registerLazySingleton(() => AppRouter(sl<AuthStateNotifier>()));
}
