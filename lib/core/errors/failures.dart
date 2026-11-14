/// كائنات الفشل الموحدة لطبقة الـ Domain.
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class OcrFailure extends Failure {
  const OcrFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class BackupFailure extends Failure {
  const BackupFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
