/// نتيجة عملية النسخ الاحتياطي.
class BackupResult {
  const BackupResult({
    required this.success,
    required this.message,
    this.fileName,
    this.remoteId,
    this.sizeBytes,
  });

  final bool success;
  final String message;
  final String? fileName;
  final String? remoteId;
  final int? sizeBytes;
}

/// عقد النسخ الاحتياطي والاستعادة إلى Google Drive الشخصي.
abstract class BackupRepository {
  /// تسجيل الدخول إلى Google (مرة واحدة) والحصول على الحساب.
  Future<String?> signIn();

  Future<void> signOut();

  /// هل المستخدم مسجّل الدخول حالياً؟
  Future<bool> isSignedIn();

  /// رفع نسخة احتياطية من قاعدة البيانات إلى مجلد خاص في Drive.
  Future<BackupResult> backupToDrive();

  /// استعادة أحدث نسخة احتياطية من Drive (يستبدل قاعدة البيانات المحلية).
  Future<BackupResult> restoreFromDrive();

  /// قائمة النسخ الاحتياطية المتاحة.
  Future<List<DriveBackupFile>> listBackups();
}

class DriveBackupFile {
  const DriveBackupFile({
    required this.id,
    required this.name,
    required this.createdTime,
    this.sizeBytes,
  });

  final String id;
  final String name;
  final DateTime createdTime;
  final int? sizeBytes;
}
