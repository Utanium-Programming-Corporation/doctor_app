import 'package:equatable/equatable.dart';

class CreateAppointmentTypeParams extends Equatable {
  final String clinicId;
  final String name;
  final int durationMinutes;
  final String colorHex;
  final String? description;
  final bool isActive;

  const CreateAppointmentTypeParams({
    required this.clinicId,
    required this.name,
    required this.durationMinutes,
    required this.colorHex,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        clinicId,
        name,
        durationMinutes,
        colorHex,
        description,
        isActive,
      ];
}

class UpdateAppointmentTypeParams extends Equatable {
  final String id;
  final String? name;
  final int? durationMinutes;
  final String? colorHex;
  final String? description;
  final bool? isActive;

  const UpdateAppointmentTypeParams({
    required this.id,
    this.name,
    this.durationMinutes,
    this.colorHex,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, durationMinutes, colorHex, description, isActive];
}

class GetProviderAvailabilityParams extends Equatable {
  final String clinicId;
  final String providerId;

  const GetProviderAvailabilityParams({
    required this.clinicId,
    required this.providerId,
  });

  @override
  List<Object?> get props => [clinicId, providerId];
}

class AvailabilityEntry extends Equatable {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? locationId;
  final bool isActive;

  const AvailabilityEntry({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.locationId,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, locationId, isActive];
}

class SetProviderAvailabilityParams extends Equatable {
  final String clinicId;
  final String providerId;
  final List<AvailabilityEntry> entries;

  const SetProviderAvailabilityParams({
    required this.clinicId,
    required this.providerId,
    required this.entries,
  });

  @override
  List<Object?> get props => [clinicId, providerId, entries];
}

class AddBlockedDateParams extends Equatable {
  final String clinicId;
  final String providerId;
  final DateTime blockedDate;
  final String? reason;

  const AddBlockedDateParams({
    required this.clinicId,
    required this.providerId,
    required this.blockedDate,
    this.reason,
  });

  @override
  List<Object?> get props => [clinicId, providerId, blockedDate, reason];
}

class GetAvailableSlotsParams extends Equatable {
  final String clinicId;
  final String providerId;
  final DateTime date;
  final String appointmentTypeId;

  const GetAvailableSlotsParams({
    required this.clinicId,
    required this.providerId,
    required this.date,
    required this.appointmentTypeId,
  });

  @override
  List<Object?> get props => [clinicId, providerId, date, appointmentTypeId];
}
