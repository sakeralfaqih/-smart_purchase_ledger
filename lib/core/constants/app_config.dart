/// إعدادات التطبيق العامة (المفاتيح تُمرر وقت البناء عبر --dart-define).
class AppConfig {
  AppConfig._();

  /// مفتاح Gemini — مرّر عند البناء:
  /// flutter run --dart-define=GEMINI_API_KEY=xxxx
  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  static const String geminiModel = 'gemini-2.5-flash';

  /// اسم قاعدة البيانات المحلية.
  static const String databaseName = 'hisab_almawrid';

  /// الحد الأقصى لحجم الصورة بعد الضغط (بايت).
  static const int maxImageBytes = 250 * 1024;

  /// العرض الأقصى للصورة بعد الضغط.
  static const int maxImageWidth = 1600;

  /// نطاق Google Drive للنسخ الاحتياطي.
  static const String driveScope =
      'https://www.googleapis.com/auth/drive.file';

  static const String backupFolderName = 'HisabAlMawridBackup';
  static const String backupFilePrefix = 'hisab_backup_';
}
