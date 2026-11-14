import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../2_ocr_scanner/data/datasources/offline_ocr_queue_local_datasource.dart';
import '../../../2_ocr_scanner/presentation/providers/ocr_providers.dart';
import '../../data/datasources/google_drive_backup_datasource.dart';
import '../../data/repositories/backup_repository_impl.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/usecases/authenticate_biometrics_usecase.dart';
import '../../domain/usecases/backup_to_google_drive_usecase.dart';
import '../../domain/usecases/restore_from_google_drive_usecase.dart';

final googleDriveBackupDataSourceProvider =
    Provider<GoogleDriveBackupDataSource>(
        (ref) => GoogleDriveBackupDataSource());

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => BackupRepositoryImpl(
    ref.watch(googleDriveBackupDataSourceProvider),
    ref.watch(appDatabaseProvider),
  ),
);

final backupToGoogleDriveUseCaseProvider =
    Provider<BackupToGoogleDriveUseCase>((ref) =>
        BackupToGoogleDriveUseCase(ref.watch(backupRepositoryProvider)));

final restoreFromGoogleDriveUseCaseProvider =
    Provider<RestoreFromGoogleDriveUseCase>((ref) =>
        RestoreFromGoogleDriveUseCase(ref.watch(backupRepositoryProvider)));

final authenticateBiometricsUseCaseProvider =
    Provider<AuthenticateBiometricsUseCase>(
        (ref) => AuthenticateBiometricsUseCase());

final driveBackupsProvider =
    FutureProvider.autoDispose<List<DriveBackupFile>>((ref) {
  return ref.watch(backupRepositoryProvider).listBackups();
});

/// مزود طابور الصور الملتقطة بدون إنترنت (Offline OCR Queue).
final pendingOcrQueueProvider =
    FutureProvider.autoDispose<List<PendingScan>>((ref) {
  return ref.watch(offlineOcrQueueProvider).list();
});

/// إدارة وحفظ حالة تفعيل قفل البصمة محلياً بشكل دائم على الهاتف.
class BiometricLockNotifier extends StateNotifier<bool> {
  BiometricLockNotifier() : super(false) {
    _load();
  }

  static const String _fileName = 'security_settings.json';

  Future<File> _settingsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _fileName));
  }

  Future<void> _load() async {
    try {
      final f = await _settingsFile();
      if (!await f.exists()) return;
      final map = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      state = map['biometricLockEnabled'] == true;
    } catch (_) {}
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    try {
      final f = await _settingsFile();
      await f.writeAsString(jsonEncode({'biometricLockEnabled': enabled}));
    } catch (_) {}
  }
}

final biometricLockEnabledProvider =
    StateNotifierProvider<BiometricLockNotifier, bool>(
  (ref) => BiometricLockNotifier(),
);
