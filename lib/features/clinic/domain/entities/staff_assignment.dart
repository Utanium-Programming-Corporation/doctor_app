import 'package:equatable/equatable.dart';

import 'staff_role.dart';

class StaffAssignment extends Equatable {
  final String id;
  final String userId;
  final String clinicId;
  final StaffRole role;
  final bool isActive;
  final DateTime joinedAt;
  final DateTime updatedAt;
  final String? userName;

  const StaffAssignment({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.role,
    required this.isActive,
    required this.joinedAt,
    required this.updatedAt,
    this.userName,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        clinicId,
        role,
        isActive,
        joinedAt,
        updatedAt,
        userName,
      ];
}
