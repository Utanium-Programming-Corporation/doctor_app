import 'package:equatable/equatable.dart';

class ProviderAvailability extends Equatable {
  final String id;
  final String clinicId;
  final String providerId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? locationId;
  final bool isActive;

  const ProviderAvailability({
    required this.id,
    required this.clinicId,
    required this.providerId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.locationId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        clinicId,
        providerId,
        dayOfWeek,
        startTime,
        endTime,
        locationId,
        isActive,
      ];
}
