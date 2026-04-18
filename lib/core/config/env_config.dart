import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class EnvConfig {
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    assert(
      value != null && value.isNotEmpty,
      'SUPABASE_URL is not set in .env',
    );
    return value!;
  }

  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    assert(
      value != null && value.isNotEmpty,
      'SUPABASE_ANON_KEY is not set in .env',
    );
    return value!;
  }

  /// Web OAuth 2.0 client ID from Google Cloud Console.
  ///
  /// Required on Android (passed as `serverClientId`) so Google returns an
  /// ID token that Supabase can verify. Also used on iOS when no
  /// platform-specific iOS client ID is configured.
  static String get googleWebClientId {
    final value = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    assert(
      value != null && value.isNotEmpty,
      'GOOGLE_WEB_CLIENT_ID is not set in .env',
    );
    return value!;
  }

  /// iOS OAuth 2.0 client ID from Google Cloud Console.
  ///
  /// Required on iOS to obtain an ID token. Optional on Android (ignored).
  /// Returns null if not configured so the Google Sign-In plugin falls back
  /// to the GoogleService-Info.plist / reversed client ID scheme on iOS.
  static String? get googleIosClientId {
    final value = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<void> initSupabase() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
}
