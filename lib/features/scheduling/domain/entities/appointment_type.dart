import 'package:equatable/equatable.dart';

class AppointmentType extends Equatable {
  final String id;
  final String clinicId;
  final String name;
  final int durationMinutes;
  final String colorHex;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  const AppointmentType({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.durationMinutes,
    required this.colorHex,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        clinicId,
        name,
        durationMinutes,
        colorHex,
        description,
        isActive,
        createdAt,
      ];
}
