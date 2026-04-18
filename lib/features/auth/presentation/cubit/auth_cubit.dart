import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/create_user_profile.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/watch_auth_state.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final GetUserProfile _getUserProfile;
  final CreateUserProfile _createUserProfile;
  final WatchAuthState _watchAuthState;

  StreamSubscription<Either<Failure, User?>>? _authSub;

  AuthCubit({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required GetUserProfile getUserProfile,
    required CreateUserProfile createUserProfile,
    required WatchAuthState watchAuthState,
  })  : _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _getUserProfile = getUserProfile,
        _createUserProfile = createUserProfile,
        _watchAuthState = watchAuthState,
        super(const AuthInitial()) {
    _subscribeToAuthChanges();
    checkSession();
  }

  void _subscribeToAuthChanges() {
    _authSub = _watchAuthState().listen((result) {
      result.fold(
        (failure) => emit(const Unauthenticated()),
        (user) {
          if (user == null) {
            emit(const Unauthenticated());
          } else {
            _fetchProfileAndEmit(user);
          }
        },
      );
    });
  }

  Future<void> _fetchProfileAndEmit(User user) async {
    final result = await _getUserProfile(user.id);
    result.fold(
      (failure) => emit(Authenticated(user: user, profile: null)),
      (profile) => emit(Authenticated(user: user, profile: profile)),
    );
  }

  /// Checks for an existing session synchronously and emits the initial state.
  Future<void> checkSession() async {
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user == null) {
          emit(const Unauthenticated());
        } else {
          _fetchProfileAndEmit(user);
        }
      },
    );
  }

  Future<void> signInWithGoogle() async {
    debugPrint('[AuthCubit] signInWithGoogle called');
    emit(const AuthLoading());
    final result = await _signInWithGoogle();
    result.fold(
      (failure) {
        debugPrint('[AuthCubit] signInWithGoogle failure: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        debugPrint('[AuthCubit] signInWithGoogle succeeded, awaiting auth stream');
      }, // auth stream subscription handles the state transition
    );
  }

  Future<void> signInWithApple() async {
    emit(const AuthLoading());
    final result = await _signInWithApple();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {}, // auth stream subscription handles the state transition
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    await _signOut();
    // auth stream subscription handles the Unauthenticated emission
  }

  Future<void> createProfile(CreateProfileParams params) async {
    emit(const AuthLoading());
    final result = await _createUserProfile(params);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) {
        final current = state;
        if (current is Authenticated) {
          emit(Authenticated(user: current.user, profile: profile));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
