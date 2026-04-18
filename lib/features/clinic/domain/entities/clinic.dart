import 'package:equatable/equatable.dart';

import 'clinic_type.dart';

class Clinic extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String address;
  final ClinicType type;
  final String inviteCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Clinic({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
    required this.inviteCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        address,
        type,
        inviteCode,
        isActive,
        createdAt,
        updatedAt,
      ];
}
