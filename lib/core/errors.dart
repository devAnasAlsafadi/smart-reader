/// Base exception for app-specific errors.
class AppException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException(
      this.message, {
        this.cause,
        this.stackTrace,
      });

  @override
  String toString() => 'AppException: $message';
}

/// More specific exceptions if you need them later.
class NetworkException extends AppException {
  const NetworkException(String message, {Object? cause, StackTrace? stackTrace})
      : super(message, cause: cause, stackTrace: stackTrace);
}

class OcrException extends AppException {
  const OcrException(String message, {Object? cause, StackTrace? stackTrace})
      : super(message, cause: cause, stackTrace: stackTrace);
}

/// Failure object used in domain layer (clean architecture style).
class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}
