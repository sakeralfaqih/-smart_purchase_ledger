import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// عنصر في طابور الانتظار.
class PendingScan {
  PendingScan({
    required this.imagePaths,
    this.hint,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final List<String> imagePaths;
  final String? hint;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'imagePaths': imagePaths,
        'hint': hint,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PendingScan.fromJson(Map<String, dynamic> json) => PendingScan(
        imagePaths:
            (json['imagePaths'] as List?)?.map((e) => e.toString()).toList() ??
                [],
        hint: json['hint'] as String?,
        createdAt:
            DateTime.tryParse(json['createdAt'] as String? ?? '') ??
                DateTime.now(),
      );
}

/// طابور انتظار الصور عند انقطاع الإنترنت (تخزين محلي في ملف JSON).
class OfflineOcrQueueLocalDataSource {
  static const String _fileName = 'offline_ocr_queue.json';

  Future<File> _file() async {
    final docs = await getApplicationDocumentsDirectory();
    return File(p.join(docs.path, _fileName));
  }

  Future<List<PendingScan>> load() async {
    final file = await _file();
    if (!await file.exists()) return [];
    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final list = jsonDecode(content) as List;
      return list
          .whereType<Map>()
          .map((e) => PendingScan.fromJson(e.cast<String, dynamic>()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(List<PendingScan> items) async {
    final file = await _file();
    await file.writeAsString(
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> enqueue(List<String> imagePaths, {String? hint}) async {
    final items = await load();
    items.add(PendingScan(imagePaths: imagePaths, hint: hint));
    await _save(items);
  }

  Future<int> count() async => (await load()).length;

  Future<List<PendingScan>> list() => load();

  Future<void> removeAt(int index) async {
    final items = await load();
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await _save(items);
    }
  }

  Future<void> clear() async => _save([]);
}
