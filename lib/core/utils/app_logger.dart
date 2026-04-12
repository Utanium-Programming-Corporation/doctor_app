import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      developer.log(
        message,
        name: 'WARNING',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void info(String message) {
    if (!kReleaseMode) {
      developer.log(message, name: 'INFO');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG');
    }
  }
}
