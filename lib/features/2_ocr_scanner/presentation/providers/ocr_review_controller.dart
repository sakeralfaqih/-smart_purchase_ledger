import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../3_invoices/domain/entities/invoice_line_entity.dart';
import '../../../3_invoices/domain/entities/purchase_invoice_entity.dart';
import '../../../3_invoices/presentation/providers/invoices_providers.dart';
import '../../../4_vouchers/domain/entities/payment_voucher_entity.dart';
import '../../../4_vouchers/presentation/providers/vouchers_providers.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../../domain/entities/validation_result_entity.dart';
import 'ocr_providers.dart';

/// حالة شاشة مراجعة المستند المستخرج.
class OcrReviewState {
  const OcrReviewState({
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.document,
    this.validation,
    this.supplierId,
    this.paidAmount = 0,
    this.savedInvoiceId,
  });

  final bool isLoading;
  final bool isSaving;
  final String? error;
  final ExtractedDocument? document;
  final ValidationResult? validation;
  final int? supplierId;
  final double paidAmount;
  final int? savedInvoiceId;

  bool get isReady => document != null && supplierId != null;
  bool get isVoucher => document?.docType == DocType.receiptVoucher;

  OcrReviewState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    ExtractedDocument? document,
    ValidationResult? validation,
    int? supplierId,
    double? paidAmount,
    int? savedInvoiceId,
    bool clearError = false,
  }) =>
      OcrReviewState(
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        error: clearError ? null : (error ?? this.error),
        document: document ?? this.document,
        validation: validation ?? this.validation,
        supplierId: supplierId ?? this.supplierId,
        paidAmount: paidAmount ?? this.paidAmount,
        savedInvoiceId: savedInvoiceId ?? this.savedInvoiceId,
      );
}

/// متحكّم شاشة المراجعة: يستخرج المستند، يتيح التعديل، ثم يعتمد الحفظ.
class OcrReviewController extends StateNotifier<OcrReviewState> {
  OcrReviewController(this._ref) : super(const OcrReviewState());

  final Ref _ref;

  Future<void> start({
    required List<String> imagePaths,
    DocType? hint,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final outcome = await _ref.read(scanAndExtractDocumentUseCaseProvider)(
        imagePaths: imagePaths,
        hint: hint,
      );
      final initialPaid = outcome.document.paymentStatus == PaymentStatus.cash
          ? outcome.document.financial.netTotal
          : 0.0;

      state = OcrReviewState(
        document: outcome.document,
        validation: outcome.validation,
        supplierId: outcome.supplierId,
        paidAmount: initialPaid,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'تعذّر استخراج البيانات: $e',
      );
    }
  }

  void updateLine(int index, ExtractedLineItem line) {
    final doc = state.document;
    if (doc == null) return;
    final lines = [...doc.lineItems];
    if (index < 0 || index >= lines.length) return;

    final totalUnits = line.qtyNum + line.freeQty;
    final effectiveCost =
        totalUnits > 0 ? line.lineTotal / totalUnits : line.unitPrice;
    final pack = line.extractedPackSize;
    final pieceCost =
        (pack != null && pack > 0) ? effectiveCost / pack : null;
    final expectedTotal = line.qtyNum * line.unitPrice;
    final mathOk = (expectedTotal - line.lineTotal).abs() <= 1.0;

    lines[index] = line.copyWith(
      effectiveUnitCost: effectiveCost,
      singlePieceCost: pieceCost,
      mathVerified: mathOk,
      needsReview: !mathOk,
    );
    _applyDocument(doc.copyWith(lineItems: lines));
  }

  void addLine([ExtractedLineItem? customLine]) {
    final doc = state.document;
    if (doc == null) return;
    final nextNo = doc.lineItems.length + 1;
    final newLine = (customLine ??
            ExtractedLineItem(
              lineNo: nextNo,
              rawName: '',
              cleanItemName: '',
              unit: 'كرتون',
              qtyNum: 1,
              unitPrice: 0,
              lineTotal: 0,
              needsReview: true,
            ))
        .copyWith(lineNo: nextNo);
    final lines = [...doc.lineItems, newLine];
    _applyDocument(doc.copyWith(lineItems: lines));
  }

  void removeLine(int index) {
    final doc = state.document;
    if (doc == null) return;
    final lines = [...doc.lineItems];
    if (index < 0 || index >= lines.length) return;
    lines.removeAt(index);
    for (var i = 0; i < lines.length; i++) {
      lines[i] = lines[i].copyWith(lineNo: i + 1);
    }
    _applyDocument(doc.copyWith(lineItems: lines));
  }

  void updateFinancial(FinancialSummary financial) {
    final doc = state.document;
    if (doc == null) return;
    _applyDocument(doc.copyWith(financial: financial));
  }

  void updateVoucherDetails({
    double? amount,
    String? amountWords,
    String? statementNote,
    double? printedRemainingBalance,
  }) {
    final doc = state.document;
    if (doc == null) return;
    final currentVoucher = doc.voucherDetails ?? const VoucherDetails();
    final updatedVoucher = currentVoucher.copyWith(
      amount: amount,
      amountWords: amountWords,
      statementNote: statementNote,
    );
    final updatedFinancial = printedRemainingBalance != null
        ? doc.financial.copyWith(printedCurrentBalance: printedRemainingBalance)
        : doc.financial;

    state = state.copyWith(
      document: doc.copyWith(
        voucherDetails: updatedVoucher,
        financial: updatedFinancial,
      ),
    );
  }

  void updateHeader({
    String? paperNumber,
    DateTime? date,
    PaymentStatus? paymentStatus,
    SupplierInfo? supplier,
    DocType? docType,
  }) {
    final doc = state.document;
    if (doc == null) return;
    final updatedDoc = doc.copyWith(
      paperNumber: paperNumber,
      date: date,
      paymentStatus: paymentStatus,
      supplier: supplier,
      docType: docType,
    );
    if (paymentStatus == PaymentStatus.cash) {
      state = state.copyWith(paidAmount: updatedDoc.financial.netTotal);
    } else if (paymentStatus == PaymentStatus.credit) {
      state = state.copyWith(paidAmount: 0.0);
    }
    _applyDocument(updatedDoc);
  }

  void setPaidAmount(double value) {
    state = state.copyWith(paidAmount: value);
  }

  /// إعادة حساب الإجماليات من الأسطر بعد التعديل اليدوي.
  void _applyDocument(ExtractedDocument doc) {
    if (doc.isVoucher) {
      final validation = _ref.read(validateInvoiceMathUseCaseProvider)(doc);
      state = state.copyWith(
        document: doc,
        validation: validation.result,
      );
      return;
    }

    final subtotal = doc.lineItems.fold<double>(0, (a, l) => a + l.lineTotal);
    final netTotal =
        subtotal - doc.financial.discount + doc.financial.extraCharges;
    final financial = doc.financial.copyWith(
      subtotal: subtotal,
      netTotal: netTotal,
    );
    final updated = doc.copyWith(financial: financial);
    final validation = _ref.read(validateInvoiceMathUseCaseProvider)(updated);
    final paid = updated.paymentStatus == PaymentStatus.cash
        ? netTotal
        : (updated.paymentStatus == PaymentStatus.credit
            ? 0.0
            : state.paidAmount);

    state = state.copyWith(
      document: updated,
      validation: validation.result,
      paidAmount: paid,
    );
  }

  Future<int?> save() async {
    final doc = state.document;
    var supplierId = state.supplierId;
    if (doc == null) return null;

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      // التأكد من حل المورد أو تحديث اسمه إذا عدّله المستخدم في الشاشة
      supplierId = await _ref
          .read(supplierResolverProvider)
          .resolveSupplier(doc.supplier);

      final int id;
      if (doc.docType == DocType.receiptVoucher) {
        id = await _saveVoucher(doc, supplierId);
      } else {
        final invoice = await _toInvoiceEntity(doc, supplierId);
        id = await _ref.read(saveConfirmedInvoiceUseCaseProvider)(invoice);
      }
      state = state.copyWith(
        isSaving: false,
        supplierId: supplierId,
        savedInvoiceId: id,
      );
      return id;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'تعذّر حفظ المستند: $e');
      return null;
    }
  }

  Future<int> _saveVoucher(ExtractedDocument doc, int supplierId) {
    final voucher = PaymentVoucherEntity(
      supplierId: supplierId,
      paperVoucherNumber:
          doc.paperNumber.trim().isEmpty ? 'بدون رقم' : doc.paperNumber.trim(),
      voucherDate: doc.date,
      currency: doc.currency,
      amount: (doc.voucherDetails?.amount ?? 0) > 0
          ? doc.voucherDetails!.amount
          : doc.financial.netTotal,
      amountWords: doc.voucherDetails?.amountWords,
      statementNote: doc.voucherDetails?.statementNote,
      printedRemainingBalance: doc.financial.printedCurrentBalance,
      imagePath: doc.imagePaths.isNotEmpty ? doc.imagePaths.first : null,
      createdAt: DateTime.now(),
    );
    return _ref.read(savePaymentVoucherUseCaseProvider)(voucher);
  }

  Future<PurchaseInvoiceEntity> _toInvoiceEntity(
    ExtractedDocument doc,
    int supplierId,
  ) async {
    final itemRepo = _ref.read(itemMatchingRepositoryProvider);
    final lines = <InvoiceLineEntity>[];

    for (var i = 0; i < doc.lineItems.length; i++) {
      final l = doc.lineItems[i];
      if (l.cleanItemName.trim().isEmpty && l.rawName.trim().isEmpty) {
        continue;
      }
      var itemId = l.matchedItemId;

      // إذا كان السطر مضافاً يدوياً أو لم يرتبط بصنف بعد، ننشئه في الدليل بدلاً من تجاهله!
      if (itemId == null) {
        final ensured = await itemRepo.ensureItemExists(
          canonicalName:
              l.cleanItemName.trim().isNotEmpty ? l.cleanItemName : l.rawName,
          defaultUnit: l.unit,
          packUnitsCount: l.extractedPackSize,
          suggestedRetailPrice: l.extractedRetailPrice,
          initialPurchasePrice: l.unitPrice,
        );
        itemId = ensured.itemId;
      }

      final pack = l.extractedPackSize;
      final effective = l.effectiveUnitCost ??
          (l.totalUnits <= 0 ? l.unitPrice : l.lineTotal / l.totalUnits);
      final singlePiece = l.singlePieceCost ??
          ((pack != null && pack > 0) ? effective / pack : null);

      lines.add(
        InvoiceLineEntity(
          itemId: itemId,
          lineNumber: lines.length + 1,
          supplierItemCode: l.supplierItemCode,
          rawItemName: l.rawName.trim().isEmpty ? l.cleanItemName : l.rawName,
          unitName: l.unit,
          quantity: l.qtyNum,
          quantityWords: l.qtyWords,
          freeQuantity: l.freeQty,
          unitPrice: l.unitPrice,
          lineTotal: l.lineTotal,
          effectiveUnitCost: effective,
          singlePieceCost: singlePiece,
          previousUnitPrice: l.previousUnitPrice,
          priceDiffAmount: l.priceDiffAmount,
          needsReview: l.needsReview,
          extractedPackSize: l.extractedPackSize,
          extractedRetailPrice: l.extractedRetailPrice,
        ),
      );
    }

    final paymentType = switch (doc.paymentStatus) {
      PaymentStatus.cash => 'cash',
      PaymentStatus.partial => 'partial',
      PaymentStatus.credit => 'credit',
    };

    final netTotal = doc.financial.netTotal;
    final effectivePaidAmount = switch (doc.paymentStatus) {
      PaymentStatus.cash => netTotal,
      PaymentStatus.credit => 0.0,
      PaymentStatus.partial => state.paidAmount.clamp(0.0, netTotal),
    };
    final effectiveRemaining = netTotal - effectivePaidAmount;

    return PurchaseInvoiceEntity(
      supplierId: supplierId,
      paperInvoiceNumber:
          doc.paperNumber.trim().isEmpty ? 'بدون رقم' : doc.paperNumber.trim(),
      invoiceDate: doc.date,
      currency: doc.currency,
      paymentType: paymentType,
      subtotal: doc.financial.subtotal,
      discount: doc.financial.discount,
      extraCharges: doc.financial.extraCharges,
      netTotal: netTotal,
      paidAmount: effectivePaidAmount,
      remainingAmount: effectiveRemaining,
      printedTotalQty: doc.financial.totalPiecesCount,
      printedPrevBalance: doc.financial.printedPreviousBalance,
      printedCurrBalance: doc.financial.printedCurrentBalance,
      imagePaths: doc.imagePaths,
      hasMathWarning: state.validation?.hasAnyWarning ?? false,
      status: 'confirmed',
      createdAt: DateTime.now(),
      lines: lines,
    );
  }
}

final ocrReviewControllerProvider =
    StateNotifierProvider.autoDispose<OcrReviewController, OcrReviewState>(
        (ref) {
  return OcrReviewController(ref);
});
