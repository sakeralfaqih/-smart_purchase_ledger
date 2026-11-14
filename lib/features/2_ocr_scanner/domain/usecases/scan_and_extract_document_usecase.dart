import '../entities/extracted_document_entity.dart';
import '../entities/validation_result_entity.dart';
import '../repositories/ocr_scanner_repository.dart';
import '../repositories/supplier_resolver.dart';
import 'match_extracted_items_usecase.dart';
import 'validate_invoice_math_usecase.dart';

/// نتيجة عملية المسح الكاملة.
class ScanOutcome {
  const ScanOutcome({
    required this.document,
    required this.validation,
    required this.supplierId,
  });

  final ExtractedDocument document;
  final ValidationResult validation;
  final int supplierId;
}

/// تنسيق العملية: استخراج بصري ➔ حل المورد ➔ تدقيق رياضي ➔ مطابقة أصناف.
class ScanAndExtractDocumentUseCase {
  const ScanAndExtractDocumentUseCase(
    this._repository,
    this._supplierResolver,
    this._validateMath,
    this._matchItems,
  );

  final OcrScannerRepository _repository;
  final SupplierResolver _supplierResolver;
  final ValidateInvoiceMathUseCase _validateMath;
  final MatchExtractedItemsUseCase _matchItems;

  Future<ScanOutcome> call({
    required List<String> imagePaths,
    DocType? hint,
  }) async {
    final raw = await _repository.extractDocument(
      imagePaths: imagePaths,
      hint: hint,
    );

    final supplierId = await _supplierResolver.resolveSupplier(raw.supplier);

    final validated = _validateMath(raw);
    final matched = await _matchItems(
      validated.document,
      supplierId: supplierId,
    );

    return ScanOutcome(
      document: matched,
      validation: validated.result,
      supplierId: supplierId,
    );
  }
}
