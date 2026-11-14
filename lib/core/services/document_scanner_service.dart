import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

import '../errors/exceptions.dart';

/// تغليف google_mlkit_document_scanner للتصوير متعدد الصفحات.
class DocumentScannerService {
  DocumentScannerService();

  DocumentScanner? _scanner;

  /// يفتح الكاميرا ويعيد مسارات الصور الملتقطة (صفحة أو أكثر).
  Future<List<String>> scanDocument({int pageLimit = 10}) async {
    try {
      _scanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormat: DocumentFormat.jpeg,
          mode: ScannerMode.full,
          pageLimit: pageLimit,
          isGalleryImport: true,
        ),
      );
      final result = await _scanner!.scanDocument();
      final images = result?.images ?? <String>[];
      if (images.isEmpty) {
        throw OcrException('لم يتم التقاط أي صفحة.');
      }
      return images;
    } on OcrException {
      rethrow;
    } catch (e) {
      throw OcrException('فشل فتح الماسح الضوئي: $e');
    } finally {
      await _scanner?.close();
      _scanner = null;
    }
  }
}
