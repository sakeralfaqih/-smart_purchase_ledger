import '../repositories/backup_repository.dart';

class RestoreFromGoogleDriveUseCase {
  const RestoreFromGoogleDriveUseCase(this._repository);

  final BackupRepository _repository;

  Future<BackupResult> call() => _repository.restoreFromDrive();
}
