import '../../domain/entities/appointment.dart';

sealed class MyDayState {
  const MyDayState();
}

class MyDayInitial extends MyDayState {
  const MyDayInitial();
}

class MyDayLoading extends MyDayState {
  const MyDayLoading();
}

class MyDayLoaded extends MyDayState {
  final List<Appointment> appointments;
  final String providerId;

  const MyDayLoaded({
    required this.appointments,
    required this.providerId,
  });
}

class MyDayError extends MyDayState {
  final String message;

  const MyDayError(this.message);
}
