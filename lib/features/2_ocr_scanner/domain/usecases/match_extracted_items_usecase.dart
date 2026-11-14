import '../../../../core/services/arabic_text_normalizer.dart';
import '../entities/extracted_document_entity.dart';
import '../repositories/item_matching_repository.dart';
import 'parse_item_pack_and_retail_usecase.dart';

/// القاعدة الثالثة والرابعة: تفكيك اسم الصنف، مطابقة الأصناف بكود المورد أو بالبحث الضبابي،
/// إنشاء الأصناف الجديدة تلقائياً في الدليل، وحساب فرق السعر وتكلفة الحبة الواحدة.
class MatchExtractedItemsUseCase {
  const MatchExtractedItemsUseCase(
    this._repository, [
    this._parseItemName = const ParseItemPackAndRetailUseCase(),
  ]);

  final ItemMatchingRepository _repository;
  final ParseItemPackAndRetailUseCase _parseItemName;

  Future<ExtractedDocument> call(
    ExtractedDocument document, {
    required int supplierId,
  }) async {
    if (document.docType == DocType.receiptVoucher) {
      return document;
    }

    var candidates = await _repository.getCandidates();
    var candidateNames = candidates.map((c) => c.canonicalName).toList();

    final matchedLines = <ExtractedLineItem>[];
    for (final line in document.lineItems) {
      // 1) تفكيك اسم الصنف لاستخراج (شد العبوة) و(سعر البيع المقترح) والاسم النظيف
      final parsed = _parseItemName(line.rawName);
      final cleanName = line.cleanItemName.trim().isNotEmpty &&
              line.cleanItemName != line.rawName
          ? line.cleanItemName.trim()
          : parsed.cleanName;

      ItemMatchCandidate? match;
      var wasNewItemCreated = false;

      // 2) مطابقة بكود المورد (أعلى ثقة 100%).
      final code = line.supplierItemCode;
      if (code != null && code.trim().isNotEmpty) {
        match = await _repository.findBySupplierCode(supplierId, code.trim());
      }

      // 3) البحث الضبابي بالاسم في دليل الأصناف.
      if (match == null && candidates.isNotEmpty) {
        final best = ArabicTextNormalizer.bestMatch(
          cleanName.isNotEmpty ? cleanName : line.rawName,
          candidateNames,
          threshold: 0.75,
        );
        if (best != null) {
          match = candidates[best.index];
        }
      }

      final packSize =
          line.extractedPackSize ?? parsed.packSize ?? match?.packUnitsCount;
      final retailPrice = line.extractedRetailPrice ??
          parsed.retailPrice ??
          match?.suggestedRetailPrice;

      // 4) إذا كان الصنف جديداً يُشترى لأول مرة، نضمن تسجيله في الدليل حتى لا يُحذف عند الحفظ!
      double? previousUnitPrice;
      var priceDiff = 0.0;

      if (match != null) {
        previousUnitPrice = await _repository.getLastUnitPrice(match.itemId);
        if (previousUnitPrice != null) {
          priceDiff = line.unitPrice - previousUnitPrice;
        }
      } else {
        wasNewItemCreated = true;
        match = await _repository.ensureItemExists(
          canonicalName: cleanName.isNotEmpty ? cleanName : line.rawName,
          defaultUnit: line.unit,
          packUnitsCount: packSize,
          suggestedRetailPrice: retailPrice,
          initialPurchasePrice: line.unitPrice,
        );
        // تحديث قائمة المرشحين حتى إذا تكرر نفس الصنف الجديد في سطر لاحق من نفس الفاتورة يرتبط به
        candidates = [...candidates, match];
        candidateNames = [...candidateNames, match.canonicalName];
      }

      final totalUnits = line.qtyNum + line.freeQty;
      final effectiveUnitCost =
          totalUnits > 0 ? line.lineTotal / totalUnits : line.unitPrice;
      final singlePieceCost = (packSize != null && packSize > 0)
          ? effectiveUnitCost / packSize
          : null;

      matchedLines.add(
        line.copyWith(
          cleanItemName: match.canonicalName,
          matchedItemId: match.itemId,
          extractedPackSize: packSize,
          extractedRetailPrice: retailPrice,
          previousUnitPrice: previousUnitPrice,
          priceDiffAmount: priceDiff,
          effectiveUnitCost: effectiveUnitCost,
          singlePieceCost: singlePieceCost,
          needsReview: line.needsReview || wasNewItemCreated,
        ),
      );
    }

    return document.copyWith(lineItems: matchedLines);
  }
}
