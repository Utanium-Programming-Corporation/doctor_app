import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String clinicId;
  final String name;
  final String address;
  final String phone;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Location({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.address,
    required this.phone,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        clinicId,
        name,
        address,
        phone,
        isActive,
        createdAt,
        updatedAt,
      ];
}
