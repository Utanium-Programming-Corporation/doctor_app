# Quickstart: Core UseCase Interface Upgrade

**Feature**: 002-usecase-upgrade  
**Date**: 2026-04-12

## What This Feature Does

Replaces the single `UseCase<T, Params>` base class with four typed abstract interface classes and adds code-generation dependencies (freezed + json_serializable) to `pubspec.yaml`.

## Files Modified

| File | Change |
|------|--------|
| `lib/core/usecase/usecase.dart` | Replace entire contents: remove `UseCase`, `NoParams`, add 4 interfaces + 2 type aliases |
| `pubspec.yaml` | Add `freezed_annotation`, `json_annotation` to deps; add `freezed`, `json_serializable`, `build_runner` to dev_deps |

## Files Created

| File | Purpose |
|------|---------|
| `test/core/usecase/usecase_test.dart` | Unit tests verifying all 4 interfaces compile and are implementable |

## How to Use the New Interfaces

### Future use case with parameters

```dart
import 'package:doctors_app/core/usecase/usecase.dart';

class GetPatientById implements UseCaseWithParams<Patient, String> {
  final PatientRepository _repository;
  GetPatientById(this._repository);

  @override
  FutureResult<Patient> call(String patientId) {
    return _repository.getPatientById(patientId);
  }
}
```

### Future use case without parameters

```dart
class GetCurrentUser implements UseCaseWithoutParams<User> {
  final AuthRepository _repository;
  GetCurrentUser(this._repository);

  @override
  FutureResult<User> call() {
    return _repository.getCurrentUser();
  }
}
```

### Stream use case with parameters

```dart
class WatchQueueTokens implements StreamUseCaseWithParams<List<Token>, String> {
  final QueueRepository _repository;
  WatchQueueTokens(this._repository);

  @override
  StreamResult<List<Token>> call(String clinicId) {
    return _repository.watchTokens(clinicId);
  }
}
```

### Stream use case without parameters

```dart
class WatchNotifications implements StreamUseCaseWithoutParams<List<Notification>> {
  final NotificationRepository _repository;
  WatchNotifications(this._repository);

  @override
  StreamResult<List<Notification>> call() {
    return _repository.watchAll();
  }
}
```

## Running Code Generation (after adding freezed models in future features)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Verification

```bash
# Ensure dependencies resolve
flutter pub get

# Run tests
flutter test test/core/usecase/

# Verify no references to old UseCase/NoParams remain
grep -r "NoParams\|class UseCase<" lib/
# Expected: no output
```
