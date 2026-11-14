import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/common/common.dart' as common;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/backup_repository.dart';

/// عميل HTTP يضيف ترويسة Bearer تلقائياً لكل الطلبات.
class _BearerClient extends http.BaseClient {
  _BearerClient(this._inner, this._token);

  final http.Client _inner;
  final String _token;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request);
  }
}

/// التواصل مع Google Drive الشخصي لرفع/تنزيل نسخ قاعدة البيانات.
class GoogleDriveBackupDataSource {
  GoogleDriveBackupDataSource([GoogleSignIn? signIn])
      : _signIn = signIn ?? GoogleSignIn(scopes: const [AppConfig.driveScope]);

  final GoogleSignIn _signIn;

  Future<GoogleSignInAccount?> signIn() async {
    final account = await _signIn.signIn();
    return account;
  }

  Future<void> signOut() async {
    await _signIn.signOut();
  }

  Future<bool> isSignedIn() async {
    final account = _signIn.currentUser ?? await _signIn.signInSilently();
    return account != null;
  }

  Future<drive.DriveApi> _api() async {
    final account = _signIn.currentUser ?? await _signIn.signInSilently();
    if (account == null) {
      throw BackupException('يجب تسجيل الدخول إلى حساب Google أولاً');
    }
    final auth = await account.authentication;
    final token = auth.accessToken;
    if (token == null || token.isEmpty) {
      throw BackupException('تعذّر الحصول على رمز وصول Google Drive');
    }
    return drive.DriveApi(_BearerClient(http.Client(), token));
  }

  /// مسار ملف قاعدة البيانات المحلي.
  Future<File> databaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final candidates = [
      File(p.join(dir.path, '${AppConfig.databaseName}.sqlite')),
      File(p.join(dir.path, '${AppConfig.databaseName}.db')),
    ];
    for (final f in candidates) {
      if (await f.exists()) return f;
    }
    await for (final entity in dir.list(recursive: false)) {
      if (entity is File &&
          entity.path.contains(AppConfig.databaseName) &&
          !entity.path.endsWith('-wal') &&
          !entity.path.endsWith('-shm')) {
        return entity;
      }
    }
    return candidates.first;
  }

  Future<String> _ensureFolder(drive.DriveApi api) async {
    final query =
        "name = '${AppConfig.backupFolderName}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final found = await api.files.list(q: query, $fields: 'files(id, name)');
    final existing = found.files;
    if (existing != null && existing.isNotEmpty) {
      return existing.first.id!;
    }
    final folder = drive.File()
      ..name = AppConfig.backupFolderName
      ..mimeType = 'application/vnd.google-apps.folder';
    final created = await api.files.create(folder);
    return created.id!;
  }

  Future<DriveBackupFile> uploadBackup(File dbFile) async {
    if (!await dbFile.exists()) {
      throw BackupException('ملف قاعدة البيانات غير موجود');
    }
    final api = await _api();
    final folderId = await _ensureFolder(api);
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final name = '${AppConfig.backupFilePrefix}$timestamp.sqlite';
    final length = await dbFile.length();

    final media = common.Media(
      dbFile.openRead(),
      length,
      contentType: 'application/x-sqlite3',
    );
    final file = drive.File()
      ..name = name
      ..parents = [folderId];
    final created = await api.files.create(
      file,
      uploadMedia: media,
      $fields: 'id, name, createdTime, size',
    );
    return DriveBackupFile(
      id: created.id!,
      name: created.name ?? name,
      createdTime: (created.createdTime ?? DateTime.now()).toLocal(),
      sizeBytes: length,
    );
  }

  Future<List<DriveBackupFile>> listBackups() async {
    final api = await _api();
    final folderId = await _ensureFolder(api);
    final query = "'$folderId' in parents and trashed = false";
    final result = await api.files.list(
      q: query,
      orderBy: 'createdTime desc',
      $fields: 'files(id, name, createdTime, size)',
    );
    return (result.files ?? [])
        .map(
          (f) => DriveBackupFile(
            id: f.id!,
            name: f.name ?? '',
            createdTime: (f.createdTime ?? DateTime.now()).toLocal(),
            sizeBytes: f.size == null ? null : int.tryParse(f.size!),
          ),
        )
        .toList();
  }

  /// ينزّل أحدث نسخة احتياطية إلى ملف مؤقّت ويعيده.
  Future<File> downloadLatestBackup() async {
    final backups = await listBackups();
    if (backups.isEmpty) {
      throw BackupException('لا توجد نسخة احتياطية على Google Drive');
    }
    final api = await _api();
    final media = await api.files.get(
      backups.first.id,
      downloadOptions: common.DownloadOptions.fullMedia,
    ) as common.Media;

    final dir = await getTemporaryDirectory();
    final target = File(
      p.join(
        dir.path,
        'restore_${DateTime.now().millisecondsSinceEpoch}.sqlite',
      ),
    );
    final sink = target.openWrite();
    await media.stream.pipe(sink);
    await sink.close();
    return target;
  }
}
