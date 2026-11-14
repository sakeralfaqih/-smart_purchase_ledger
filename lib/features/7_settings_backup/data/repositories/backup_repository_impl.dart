import 'dart:io';

import '../../../../core/database/app_database.dart';
import '../../domain/repositories/backup_repository.dart';
import '../datasources/google_drive_backup_datasource.dart';

class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._drive, this._db);

  final GoogleDriveBackupDataSource _drive;
  final AppDatabase _db;

  @override
  Future<String?> signIn() async {
    final account = await _drive.signIn();
    return account?.email;
  }

  @override
  Future<void> signOut() => _drive.signOut();

  @override
  Future<bool> isSignedIn() => _drive.isSignedIn();

  @override
  Future<BackupResult> backupToDrive() async {
    try {
      final dbFile = await _drive.databaseFile();
      // تفريغ الـ WAL إلى الملف الرئيسي قبل الرفع لضمان شمول كافة الحركات الحديثة.
      try {
        await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
      } catch (_) {}

      final uploaded = await _drive.uploadBackup(dbFile);
      return BackupResult(
        success: true,
        message: 'تم رفع النسخة الاحتياطية بنجاح',
        fileName: uploaded.name,
        remoteId: uploaded.id,
        sizeBytes: uploaded.sizeBytes,
      );
    } catch (e) {
      return BackupResult(success: false, message: 'فشل النسخ الاحتياطي: $e');
    }
  }

  @override
  Future<BackupResult> restoreFromDrive() async {
    try {
      final downloaded = await _drive.downloadLatestBackup();
      final dbFile = await _drive.databaseFile();

      try {
        await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
      } catch (_) {}

      // إغلاق قاعدة البيانات قبل الاستبدال.
      await _db.close();

      // حذف ملفات الـ WAL و SHM الجانبية لمنع تلف قاعدة البيانات المستعادة
      final walFile = File('${dbFile.path}-wal');
      final shmFile = File('${dbFile.path}-shm');
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();

      await downloaded.copy(dbFile.path);
      if (await downloaded.exists()) {
        await downloaded.delete();
      }

      return const BackupResult(
        success: true,
        message: 'تمت الاستعادة بنجاح. يرجى إعادة تشغيل التطبيق.',
      );
    } catch (e) {
      return BackupResult(success: false, message: 'فشلت الاستعادة: $e');
    }
  }

  @override
  Future<List<DriveBackupFile>> listBackups() => _drive.listBackups();
}
