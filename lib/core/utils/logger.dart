import 'dart:developer';

enum LogLevel { debug, info, warning, error }

class Logger {
  static const bool _isDebugMode = true; // Set to false for production

  static void logMessage(String message, {LogLevel level = LogLevel.debug}) {
    if (!_isDebugMode) return;

    switch (level) {
      case LogLevel.debug:
        log("[DEBUG]: $message");
        break;
      case LogLevel.info:
        log("ℹ️ INFO: $message");
        break;
      case LogLevel.warning:
        log("⚠️ WARNING: $message");
        break;
      case LogLevel.error:
        log("❌ ERROR: $message", name: 'Logger', level: 1000);
        break;
    }
  }
}
