import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_config.dart';
import '../errors/exceptions.dart';

/// ضغط صور الفواتير إلى أقل من 250KB بدقة 1600px وحفظها محلياً بصيغة JPG موحدة.
class ImageCompressionService {
  ImageCompressionService();

  int _counter = 0;

  /// يضغط الصورة ويعيد مسارها المحفوظ داخل مجلد التطبيق الدائم.
  Future<String> compressAndSave(String sourcePath, {String? subFolder}) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw OcrException('ملف الصورة غير موجود: $sourcePath');
    }

    final docs = await getApplicationDocumentsDirectory();
    final folder = Directory(
      p.join(docs.path, subFolder ?? 'invoices'),
    );
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    _counter = (_counter + 1) % 10000;
    final baseName = p
        .basenameWithoutExtension(sourcePath)
        .replaceAll(RegExp(r'[^\w\-]'), '_');
    // إجبار الامتداد على .jpg دائماً لتجنب انهيار CompressFormat.jpeg مع صور PNG/HEIC
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${_counter}_$baseName.jpg';
    final targetPath = p.join(folder.path, fileName);

    var quality = 85;
    File? output;
    while (quality >= 35) {
      final targetFile = File(targetPath);
      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: quality,
        minWidth: AppConfig.maxImageWidth,
        minHeight: AppConfig.maxImageWidth,
        format: CompressFormat.jpeg,
      );
      if (result == null) {
        throw OcrException('فشل ضغط الصورة.');
      }
      output = File(result.path);
      final length = await output.length();
      if (length <= AppConfig.maxImageBytes) {
        return output.path;
      }
      quality -= 10;
    }

    // حتى لو تجاوز الحجم بعد أقل جودة، نعيد آخر ناتج مضغوط.
    if (output != null) return output.path;
    throw OcrException('تعذّر ضغط الصورة إلى الحجم المطلوب.');
  }

  /// ضغط دفعة صور (صفحات فاتورة واحدة).
  Future<List<String>> compressAll(
    List<String> paths, {
    String? subFolder,
  }) async {
    final results = <String>[];
    for (final path in paths) {
      results.add(await compressAndSave(path, subFolder: subFolder));
    }
    return results;
  }
}
