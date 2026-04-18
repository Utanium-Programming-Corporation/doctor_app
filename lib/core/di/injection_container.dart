import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/di/auth_injection.dart';
import '../../features/clinic/di/clinic_injection.dart';
import '../../features/patient/di/patient_injection.dart';
import '../../features/queue/di/queue_injection.dart';
import '../../features/scheduling/di/scheduling_injection.dart';
import '../config/env_config.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';

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

  // Initialize Google Sign-In (must be called once before authenticate())
  await GoogleSignIn.instance.initialize(
    clientId: Platform.isIOS ? EnvConfig.googleIosClientId : null,
    serverClientId: EnvConfig.googleWebClientId,
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Features
  await initAuth();
  await initClinic();
  await initPatient();
  await initScheduling();
  await initQueue();

  // Router (must be registered after initAuth + initClinic — depends on AuthCubit, ClinicCubit)
  sl.registerLazySingleton(
    () => AppRouter(sl(), sl(), sl(), sl()),
  );
}

