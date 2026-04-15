import 'package:equatable/equatable.dart';

import 'queue_priority.dart';
import 'queue_token_status.dart';

class QueueToken extends Equatable {
  final String id;
  final String clinicId;
  final String? locationId;
  final int tokenNumber;
  final String patientId;
  final String? appointmentId;
  final String providerId;
  final QueueTokenStatus status;
  final QueuePriority priority;
  final int skipCount;
  final DateTime? calledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final String? patientName;
  final String? providerName;

  const QueueToken({
    required this.id,
    required this.clinicId,
    this.locationId,
    required this.tokenNumber,
    required this.patientId,
    this.appointmentId,
    required this.providerId,
    required this.status,
    required this.priority,
    required this.skipCount,
    this.calledAt,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    this.patientName,
    this.providerName,
  });

  String get formattedToken => 'Q-${tokenNumber.toString().padLeft(3, '0')}';

  @override
  List<Object?> get props => [
        id,
        clinicId,
        locationId,
        tokenNumber,
        patientId,
        appointmentId,
        providerId,
        status,
        priority,
        skipCount,
        calledAt,
        startedAt,
        completedAt,
        createdAt,
        patientName,
        providerName,
      ];
}
