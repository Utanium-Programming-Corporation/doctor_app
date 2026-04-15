# Dart Interface Contracts: Queue & Check-In System

**Feature**: 007-queue-checkin
**Date**: 2026-04-12

## Repository Interfaces

### QueueRepository

```dart
abstract class QueueRepository {
  /// Check in a patient (scheduled or walk-in). Returns the created QueueToken.
  Future<Either<Failure, QueueToken>> checkInPatient({
    required String clinicId,
    required String patientId,
    required String appointmentId,
    required String providerId,
    QueuePriority priority = QueuePriority.normal,
    String? locationId,
  });

  /// Subscribe to real-time queue updates for a clinic (today only).
  Stream<Either<Failure, List<QueueToken>>> watchQueueForClinic(String clinicId);

  /// Subscribe to real-time queue updates for a specific provider (today only).
  Stream<Either<Failure, List<QueueToken>>> watchMyQueue({
    required String clinicId,
    required String providerId,
  });

  /// Call the next waiting patient for a provider. Returns the called QueueToken.
  Future<Either<Failure, QueueToken>> callNextPatient({
    required String clinicId,
    required String providerId,
  });

  /// Start consultation for a called token.
  Future<Either<Failure, QueueToken>> startConsultation(String tokenId);

  /// Complete a token (in_progress → completed).
  Future<Either<Failure, QueueToken>> completeQueueToken(String tokenId);

  /// Skip a token (waiting/called → skipped, increment skip_count).
  Future<Either<Failure, QueueToken>> skipQueueToken(String tokenId);

  /// Mark a called token as no-show.
  Future<Either<Failure, QueueToken>> markNoShow(String tokenId);
}
```

### TriageRepository

```dart
abstract class TriageRepository {
  /// Record triage vitals for a queue token.
  Future<Either<Failure, TriageAssessment>> recordTriage({
    required String queueTokenId,
    required String clinicId,
    required String recordedBy,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    int? heartRate,
    double? temperature,
    double? weight,
    int? spo2,
    String? chiefComplaint,
  });

  /// Get triage data for a specific queue token.
  Future<Either<Failure, TriageAssessment?>> getTriageForToken(String queueTokenId);
}
```

## Use Case Interfaces

| Use Case | Interface | Params | Return Type |
|----------|-----------|--------|-------------|
| CheckInPatient | UseCaseWithParams | CheckInPatientParams | QueueToken |
| CallNextPatient | UseCaseWithParams | CallNextPatientParams | QueueToken |
| StartConsultation | UseCaseWithParams | String (tokenId) | QueueToken |
| CompleteQueueToken | UseCaseWithParams | String (tokenId) | QueueToken |
| SkipQueueToken | UseCaseWithParams | String (tokenId) | QueueToken |
| MarkNoShow | UseCaseWithParams | String (tokenId) | QueueToken |
| GetQueueForClinic | StreamUseCaseWithParams | String (clinicId) | List\<QueueToken\> |
| GetMyQueue | StreamUseCaseWithParams | GetMyQueueParams | List\<QueueToken\> |
| RecordTriage | UseCaseWithParams | RecordTriageParams | TriageAssessment |
| GetTriageForToken | UseCaseWithParams | String (queueTokenId) | TriageAssessment? |

## Bloc Events

### QueueEvent (Receptionist)

```dart
sealed class QueueEvent extends Equatable {
  const QueueEvent();
}

class QueueSubscriptionRequested extends QueueEvent {
  final String clinicId;
}

class QueueCallNextRequested extends QueueEvent {
  final String clinicId;
  final String providerId;
}

class QueueSkipRequested extends QueueEvent {
  final String tokenId;
}

class QueueMarkNoShowRequested extends QueueEvent {
  final String tokenId;
}

class QueueStartConsultationRequested extends QueueEvent {
  final String tokenId;
}

class QueueCompleteRequested extends QueueEvent {
  final String tokenId;
}
```

### MyQueueEvent (Doctor)

```dart
sealed class MyQueueEvent extends Equatable {
  const MyQueueEvent();
}

class MyQueueSubscriptionRequested extends MyQueueEvent {
  final String clinicId;
  final String providerId;
}

class MyQueueCallNextRequested extends MyQueueEvent {
  final String clinicId;
  final String providerId;
}

class MyQueueStartConsultationRequested extends MyQueueEvent {
  final String tokenId;
}

class MyQueueCompleteRequested extends MyQueueEvent {
  final String tokenId;
}
```

## Routes

| Route Pattern | Page | Name Constant |
|--------------|------|---------------|
| `/home/queue` | QueueListPage | `RouteNames.queueList` |
| `/home/queue/check-in` | CheckInPage | `RouteNames.queueCheckIn` |
| `/home/queue/check-in/:appointmentId` | CheckInPage (pre-filled) | `RouteNames.queueCheckInAppointment` |
| `/home/queue/:tokenId/triage` | TriageFormPage | `RouteNames.queueTriage` |
| `/home/my-queue` | MyQueuePage | `RouteNames.myQueue` |
| `/home/waiting-room` | WaitingRoomDisplayPage | `RouteNames.waitingRoom` |
