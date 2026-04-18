import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/queue_priority.dart';
import '../entities/queue_token.dart';
import '../repositories/queue_repository.dart';

class CheckInPatientParams extends Equatable {
  final String clinicId;
  final String patientId;
  final String? appointmentId;
  final String providerId;
  final QueuePriority priority;
  final String? locationId;

  const CheckInPatientParams({
    required this.clinicId,
    required this.patientId,
    this.appointmentId,
    required this.providerId,
    this.priority = QueuePriority.normal,
    this.locationId,
  });

  @override
  List<Object?> get props => [
        clinicId,
        patientId,
        appointmentId,
        providerId,
        priority,
        locationId,
      ];
}

class CheckInPatient implements UseCaseWithParams<QueueToken, CheckInPatientParams> {
  final QueueRepository _repository;

  CheckInPatient(this._repository);

  @override
  FutureResult<QueueToken> call(CheckInPatientParams params) =>
      _repository.checkInPatient(
        clinicId: params.clinicId,
        patientId: params.patientId,
        appointmentId: params.appointmentId,
        providerId: params.providerId,
        priority: params.priority,
        locationId: params.locationId,
      );
}
