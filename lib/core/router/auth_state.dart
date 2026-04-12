import 'package:flutter/foundation.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

enum UserRole {
  superAdmin,
  clinicAdmin,
  doctor,
  nurse,
  receptionist,
  pharmacist,
  patient,
}

class AuthStateNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserRole? _role;

  AuthStatus get status => _status;
  UserRole? get role => _role;

  void setAuth(AuthStatus status, [UserRole? role]) {
    _status = status;
    _role = role;
    notifyListeners();
  }
}
