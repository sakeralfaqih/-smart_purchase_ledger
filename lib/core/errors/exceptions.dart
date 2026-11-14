/// استثناءات البنية التحتية (قاعدة البيانات، الشبكة، OCR).
class AppException implements Exception {
  AppException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code});
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class OcrException extends AppException {
  OcrException(super.message, {super.code});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code});
}

class BackupException extends AppException {
  BackupException(super.message, {super.code});
}
