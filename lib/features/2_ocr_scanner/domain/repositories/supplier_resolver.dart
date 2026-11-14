import '../entities/extracted_document_entity.dart';

/// واجهة إيجاد أو إنشاء المورد انطلاقاً من بيانات الـ OCR.
abstract class SupplierResolver {
  Future<int> resolveSupplier(SupplierInfo info);
}
