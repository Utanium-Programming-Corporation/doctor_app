import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/config/env_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<void> signOut();
  User? getCurrentUser();
  Future<UserProfileModel?> getProfile(String userId);
  Future<UserProfileModel> createProfile(CreateProfileParams params);
  Stream<User?> onAuthStateChange();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSourceImpl(this._supabase);

  static String _generateRawNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<User> signInWithGoogle() async {
    debugPrint('[GoogleSignIn] Starting sign-in flow');
    try {
      final rawNonce = _generateRawNonce();
      final hashedNonce = _sha256ofString(rawNonce);
      debugPrint('[GoogleSignIn] Re-initializing GoogleSignIn with nonce');
      await GoogleSignIn.instance.initialize(
        clientId: Platform.isIOS ? EnvConfig.googleIosClientId : null,
        serverClientId: EnvConfig.googleWebClientId,
        nonce: hashedNonce,
      );
      debugPrint('[GoogleSignIn] Launching GoogleSignIn.authenticate()');
      final googleUser = await GoogleSignIn.instance.authenticate();
      debugPrint('[GoogleSignIn] Got googleUser: ${googleUser.email}');
      final idToken = googleUser.authentication.idToken;
      debugPrint('[GoogleSignIn] idToken present: ${idToken != null}');
      if (idToken == null) {
        debugPrint('[GoogleSignIn] ERROR: idToken is null');
        throw const AuthException('Failed to obtain Google ID token');
      }
      debugPrint('[GoogleSignIn] Calling Supabase signInWithIdToken');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        nonce: rawNonce,
      );
      if (response.user == null) {
        debugPrint('[GoogleSignIn] ERROR: Supabase returned no user');
        throw const AuthException('Supabase sign-in returned no user');
      }
      debugPrint(
        '[GoogleSignIn] Success — Supabase user: ${response.user!.id}',
      );
      return response.user!;
    } on AuthException {
      rethrow;
    } on GoogleSignInException catch (e) {
      debugPrint('[GoogleSignIn] GoogleSignInException: ${e.description} , $e');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint('[GoogleSignIn] Sign-in cancelled by user');
        throw const AuthException('Google sign-in was cancelled');
      }
      debugPrint('[GoogleSignIn] GoogleSignInException: ${e.description}');
      throw AuthException(e.description ?? e.toString());
    } catch (e, st) {
      debugPrint('[GoogleSignIn] CAUGHT EXCEPTION: $e');
      debugPrint('[GoogleSignIn] Stack trace: $st');
      throw AuthException(e.toString());
    }
  }

  @override
  Future<User> signInWithApple() async {
    try {
      final rawNonce = _generateRawNonce();
      final hashedNonce = _sha256ofString(rawNonce);
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('Failed to obtain Apple ID token');
      }
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      if (response.user == null) {
        throw const AuthException('Supabase sign-in returned no user');
      }
      return response.user!;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  User? getCurrentUser() => _supabase.auth.currentUser;

  @override
  Future<UserProfileModel?> getProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data == null) return null;
      return UserProfileModel.fromJson(data);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> createProfile(CreateProfileParams params) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw const AuthException('No authenticated user');
      final data = await _supabase
          .from('profiles')
          .insert({
            'id': userId,
            'full_name': params.fullName,
            if (params.phoneNumber != null) 'phone_number': params.phoneNumber,
            'preferred_language': params.preferredLanguage,
            'role': UserRole.doctor.dbValue,
          })
          .select()
          .single();
      return UserProfileModel.fromJson(data);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Stream<User?> onAuthStateChange() {
    return _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
  }
}
