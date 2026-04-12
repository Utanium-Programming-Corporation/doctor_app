import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_logger.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: '.env');
      await EnvConfig.initSupabase();
      await initCoreDependencies();

      FlutterError.onError = (details) {
        AppLogger.error(
          details.exceptionAsString(),
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      runApp(const App());
    },
    (error, stackTrace) {
      AppLogger.error(
        'Uncaught zone error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
