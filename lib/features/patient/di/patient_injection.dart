import 'package:get_it/get_it.dart';

import '../data/datasources/patient_remote_data_source.dart';
import '../data/repositories/patient_repository_impl.dart';
import '../domain/repositories/patient_repository.dart';
import '../domain/usecases/create_patient.dart';
import '../domain/usecases/deactivate_patient.dart';
import '../domain/usecases/get_patient_by_id.dart';
import '../domain/usecases/get_patients_list.dart';
import '../domain/usecases/search_patients.dart';
import '../domain/usecases/update_patient.dart';
import '../presentation/cubit/patient_detail_cubit.dart';
import '../presentation/cubit/patient_list_cubit.dart';

Future<void> initPatient() async {
  final sl = GetIt.instance;

  // Data sources
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreatePatient(sl()));
  sl.registerLazySingleton(() => UpdatePatient(sl()));
  sl.registerLazySingleton(() => GetPatientById(sl()));
  sl.registerLazySingleton(() => SearchPatients(sl()));
  sl.registerLazySingleton(() => GetPatientsList(sl()));
  sl.registerLazySingleton(() => DeactivatePatient(sl()));

  // Cubits (factory — new instance per page)
  sl.registerFactory(
    () => PatientListCubit(
      getPatientsList: sl(),
      searchPatients: sl(),
    ),
  );
  sl.registerFactory(
    () => PatientDetailCubit(
      createPatient: sl(),
      updatePatient: sl(),
      getPatientById: sl(),
      deactivatePatient: sl(),
    ),
  );
}
