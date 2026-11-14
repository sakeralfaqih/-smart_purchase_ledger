import '../repositories/backup_repository.dart';

class BackupToGoogleDriveUseCase {
  const BackupToGoogleDriveUseCase(this._repository);

  final BackupRepository _repository;

  Future<BackupResult> call() => _repository.backupToDrive();
}
