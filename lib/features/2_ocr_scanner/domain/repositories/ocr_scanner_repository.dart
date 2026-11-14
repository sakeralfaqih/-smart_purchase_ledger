import '../entities/extracted_document_entity.dart';

/// واجهة خدمة المسح والاستخراج البصري.
abstract class OcrScannerRepository {
  /// يرسل الصور إلى Gemini ويعيد الوثيقة المستخرجة (بعد التحقق الرياضي والمطابقة).
  Future<ExtractedDocument> extractDocument({
    required List<String> imagePaths,
    DocType? hint,
  });

  /// يضيف الصور إلى طابور الانتظار عند انقطاع الإنترنت.
  Future<void> enqueueForOffline({
    required List<String> imagePaths,
    DocType? hint,
  });

  /// عدد العناصر المعلّقة في الطابور.
  Future<int> pendingCount();

  /// يعالج عناصر الطابور ويعيد مسارات الصور التي تمت معالجتها.
  Future<List<String>> processPendingQueue();
}
