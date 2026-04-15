import 'package:get_it/get_it.dart';

import '../data/datasources/queue_remote_data_source.dart';
import '../data/datasources/triage_remote_data_source.dart';
import '../data/repositories/queue_repository_impl.dart';
import '../data/repositories/triage_repository_impl.dart';
import '../domain/repositories/queue_repository.dart';
import '../domain/repositories/triage_repository.dart';
import '../domain/usecases/check_in_patient.dart';
import '../domain/usecases/my_queue_usecases.dart';
import '../domain/usecases/queue_management_usecases.dart';
import '../domain/usecases/triage_usecases.dart';
import '../presentation/bloc/my_queue_bloc.dart';
import '../presentation/bloc/queue_bloc.dart';
import '../presentation/bloc/walk_in_cubit.dart';
import '../presentation/cubit/triage_cubit.dart';

Future<void> initQueue() async {
  final sl = GetIt.instance;

  // Data sources
  sl.registerLazySingleton<QueueRemoteDataSource>(
    () => QueueRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TriageRemoteDataSource>(
    () => TriageRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<QueueRepository>(
    () => QueueRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<TriageRepository>(
    () => TriageRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckInPatient(sl()));
  sl.registerLazySingleton(() => GetQueueForClinic(sl()));
  sl.registerLazySingleton(() => CallNextPatient(sl()));
  sl.registerLazySingleton(() => SkipQueueToken(sl()));
  sl.registerLazySingleton(() => MarkNoShow(sl()));
  sl.registerLazySingleton(() => GetMyQueue(sl()));
  sl.registerLazySingleton(() => StartConsultation(sl()));
  sl.registerLazySingleton(() => CompleteQueueToken(sl()));
  sl.registerLazySingleton(() => RecordTriage(sl()));
  sl.registerLazySingleton(() => GetTriageForToken(sl()));

  // Blocs / Cubits (factory — new instance per page)
  sl.registerFactory(
    () => QueueBloc(
      getQueueForClinic: sl(),
      callNextPatient: sl(),
      skipQueueToken: sl(),
      markNoShow: sl(),
      startConsultation: sl(),
      completeQueueToken: sl(),
    ),
  );
  sl.registerFactory(
    () => MyQueueBloc(
      getMyQueue: sl(),
      callNextPatient: sl(),
      startConsultation: sl(),
      completeQueueToken: sl(),
    ),
  );
  sl.registerFactory(
    () => TriageCubit(
      recordTriage: sl(),
      getTriageForToken: sl(),
    ),
  );
  sl.registerFactory(
    () => WalkInCubit(checkInPatient: sl()),
  );
}
