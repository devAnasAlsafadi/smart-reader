import 'dart:developer';
import 'package:flutter/foundation.dart';

class IO {
  logError(String text) {
    log("-------------ERROR------------ $text");
  }
}

/// Global developer utilities (logging, flags, etc.)
class Developer {
  /// Toggle this to false in production builds if needed.
  static const bool isDebug = kDebugMode;

  /// Simple logger that respects [isDebug].
  static void log(
      Object? message, {
        String tag = 'DEBUG',
      }) {
    if (!isDebug) return;
    debugPrint('[$tag] $message');
  }

  /// Log errors with optional stack trace.
  static void logError(
      Object error, {
        String tag = 'ERROR',
        StackTrace? stackTrace,
      }) {
    if (!isDebug) return;
    debugPrint('[$tag] $error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
