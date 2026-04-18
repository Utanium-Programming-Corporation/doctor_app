import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../domain/entities/user_profile.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User user;
  final UserProfile? profile;

  const Authenticated({required this.user, this.profile});
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
