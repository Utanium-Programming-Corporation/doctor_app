import 'package:get_it/get_it.dart';

import '../data/datasources/appointment_remote_data_source.dart';
import '../data/datasources/availability_remote_data_source.dart';
import '../data/repositories/appointment_repository_impl.dart';
import '../data/repositories/availability_repository_impl.dart';
import '../domain/repositories/appointment_repository.dart';
import '../domain/repositories/availability_repository.dart';
import '../domain/usecases/add_blocked_date.dart';
import '../domain/usecases/cancel_appointment.dart';
import '../domain/usecases/create_appointment_type.dart';
import '../domain/usecases/create_appointment.dart';
import '../domain/usecases/get_appointment_by_id.dart';
import '../domain/usecases/get_appointment_types.dart';
import '../domain/usecases/get_appointments_for_date.dart';
import '../domain/usecases/get_available_slots.dart';
import '../domain/usecases/get_my_appointments_today.dart';
import '../domain/usecases/get_provider_availability.dart';
import '../domain/usecases/remove_blocked_date.dart';
import '../domain/usecases/reschedule_appointment.dart';
import '../domain/usecases/set_provider_availability.dart';
import '../domain/usecases/update_appointment_status.dart';
import '../domain/usecases/update_appointment_type.dart';
import '../presentation/cubit/availability_cubit.dart';
import '../presentation/cubit/appointment_type_cubit.dart';
import '../presentation/cubit/appointment_detail_cubit.dart';
import '../presentation/cubit/appointment_list_cubit.dart';
import '../presentation/cubit/book_appointment_cubit.dart';
import '../presentation/cubit/my_day_cubit.dart';

Future<void> initScheduling() async {
  final sl = GetIt.instance;

  // Data sources
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AvailabilityRemoteDataSource>(
    () => AvailabilityRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AvailabilityRepository>(
    () => AvailabilityRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateAppointment(sl()));
  sl.registerLazySingleton(() => GetAvailableSlots(sl()));
  sl.registerLazySingleton(() => GetAppointmentTypes(sl()));
  sl.registerLazySingleton(() => GetAppointmentsForDate(sl()));
  sl.registerLazySingleton(() => GetMyAppointmentsToday(sl()));
  sl.registerLazySingleton(() => UpdateAppointmentStatus(sl()));
  sl.registerLazySingleton(() => CancelAppointment(sl()));
  sl.registerLazySingleton(() => GetAppointmentById(sl()));
  sl.registerLazySingleton(() => RescheduleAppointment(sl()));
  sl.registerLazySingleton(() => CreateAppointmentType(sl()));
  sl.registerLazySingleton(() => UpdateAppointmentType(sl()));
  sl.registerLazySingleton(() => GetProviderAvailability(sl()));
  sl.registerLazySingleton(() => SetProviderAvailability(sl()));
  sl.registerLazySingleton(() => AddBlockedDate(sl()));
  sl.registerLazySingleton(() => RemoveBlockedDate(sl()));

  // Cubits (factory — new instance per page)
  sl.registerFactory(
    () => BookAppointmentCubit(
      createAppointment: sl(),
      getAvailableSlots: sl(),
      getAppointmentTypes: sl(),
      searchPatients: sl(),
      rescheduleAppointment: sl(),
    ),
  );
  sl.registerFactory(
    () => AppointmentListCubit(
      getAppointmentsForDate: sl(),
    ),
  );
  sl.registerFactory(
    () => MyDayCubit(
      getMyAppointmentsToday: sl(),
    ),
  );
  sl.registerFactory(
    () => AppointmentDetailCubit(
      getAppointmentById: sl(),
      updateStatus: sl(),
      cancelAppointment: sl(),
    ),
  );
  sl.registerFactory(
    () => AppointmentTypeCubit(
      getTypes: sl(),
      createType: sl(),
      updateType: sl(),
    ),
  );
  sl.registerFactory(
    () => AvailabilityCubit(
      getAvailability: sl(),
      setAvailability: sl(),
      addBlockedDate: sl(),
      removeBlockedDate: sl(),
    ),
  );
}
