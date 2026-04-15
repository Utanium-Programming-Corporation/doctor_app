import 'package:get_it/get_it.dart';

import '../data/datasources/clinic_remote_data_source.dart';
import '../data/repositories/clinic_repository_impl.dart';
import '../domain/repositories/clinic_repository.dart';
import '../domain/usecases/create_clinic.dart';
import '../domain/usecases/deactivate_staff.dart';
import '../domain/usecases/get_clinic_by_invite_code.dart';
import '../domain/usecases/get_clinic_staff.dart';
import '../domain/usecases/get_my_clinic_assignments.dart';
import '../domain/usecases/join_clinic_by_code.dart';
import '../domain/usecases/regenerate_invite_code.dart';
import '../domain/usecases/update_clinic.dart';
import '../domain/usecases/update_staff_role.dart';
import '../presentation/cubit/clinic_cubit.dart';
import '../presentation/cubit/clinic_cubit_refresh_listenable.dart';

Future<void> initClinic() async {
  final sl = GetIt.instance;

  // Data sources
  sl.registerLazySingleton<ClinicRemoteDataSource>(
    () => ClinicRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ClinicRepository>(
    () => ClinicRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateClinic(sl()));
  sl.registerLazySingleton(() => GetMyClinicAssignments(sl()));
  sl.registerLazySingleton(() => JoinClinicByCode(sl()));
  sl.registerLazySingleton(() => GetClinicByInviteCode(sl()));
  sl.registerLazySingleton(() => UpdateClinic(sl()));
  sl.registerLazySingleton(() => RegenerateInviteCode(sl()));
  sl.registerLazySingleton(() => GetClinicStaff(sl()));
  sl.registerLazySingleton(() => UpdateStaffRole(sl()));
  sl.registerLazySingleton(() => DeactivateStaff(sl()));

  // Cubit (singleton — drives global clinic state)
  sl.registerLazySingleton(
    () => ClinicCubit(
      createClinic: sl(),
      getMyClinicAssignments: sl(),
      joinClinicByCode: sl(),
      getClinicByInviteCode: sl(),
      updateClinic: sl(),
      regenerateInviteCode: sl(),
      getClinicStaff: sl(),
      updateStaffRole: sl(),
      deactivateStaff: sl(),
    ),
  );

  // GoRouter refresh bridge (depends on ClinicCubit)
  sl.registerLazySingleton(() => ClinicCubitRefreshListenable(sl()));
}
