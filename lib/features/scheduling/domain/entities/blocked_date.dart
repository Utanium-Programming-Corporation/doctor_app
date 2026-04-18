import 'package:equatable/equatable.dart';

class BlockedDate extends Equatable {
  final String id;
  final String clinicId;
  final String providerId;
  final DateTime blockedDate;
  final String? reason;
  final DateTime createdAt;

  const BlockedDate({
    required this.id,
    required this.clinicId,
    required this.providerId,
    required this.blockedDate,
    this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        clinicId,
        providerId,
        blockedDate,
        reason,
        createdAt,
      ];
}
