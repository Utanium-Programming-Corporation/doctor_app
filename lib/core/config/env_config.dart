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

  static Future<void> initSupabase() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
}
