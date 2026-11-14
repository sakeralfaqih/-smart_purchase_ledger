/// نوع الوثيقة بعد عكس المنظور المحاسبي.
enum DocType { purchaseInvoice, receiptVoucher }

/// نوع الدفع.
enum PaymentStatus { credit, cash, partial }

/// معلومات المورد المستخرجة من الترويسة/الختم.
class SupplierInfo {
  const SupplierInfo({
    required this.name,
    this.branchName,
    this.phones = const [],
    this.analyticCode,
  });

  final String name;
  final String? branchName;
  final List<String> phones;
  final String? analyticCode;

  SupplierInfo copyWith({
    String? name,
    String? branchName,
    List<String>? phones,
    String? analyticCode,
  }) =>
      SupplierInfo(
        name: name ?? this.name,
        branchName: branchName ?? this.branchName,
        phones: phones ?? this.phones,
        analyticCode: analyticCode ?? this.analyticCode,
      );
}

/// سطر صنف مستخرج (قابل للتعديل قبل الاعتماد).
class ExtractedLineItem {
  const ExtractedLineItem({
    required this.lineNo,
    required this.rawName,
    required this.cleanItemName,
    required this.unit,
    required this.qtyNum,
    required this.unitPrice,
    required this.lineTotal,
    this.supplierItemCode,
    this.qtyWords,
    this.freeQty = 0.0,
    this.extractedPackSize,
    this.extractedRetailPrice,
    this.mathVerified = true,
    this.confidenceScore = 1.0,
    this.matchedItemId,
    this.previousUnitPrice,
    this.priceDiffAmount = 0.0,
    this.effectiveUnitCost,
    this.singlePieceCost,
    this.needsReview = false,
  });

  final int lineNo;
  final String? supplierItemCode;
  final String rawName;
  final String cleanItemName;
  final String unit;
  final double qtyNum;
  final String? qtyWords;
  final double freeQty;
  final double unitPrice;
  final double lineTotal;
  final int? extractedPackSize;
  final double? extractedRetailPrice;
  final bool mathVerified;
  final double confidenceScore;

  // حقول محسوبة/مطابقة محلياً
  final int? matchedItemId;
  final double? previousUnitPrice;
  final double priceDiffAmount;
  final double? effectiveUnitCost;
  final double? singlePieceCost;
  final bool needsReview;

  double get totalUnits => qtyNum + freeQty;

  ExtractedLineItem copyWith({
    int? lineNo,
    String? supplierItemCode,
    String? rawName,
    String? cleanItemName,
    String? unit,
    double? qtyNum,
    String? qtyWords,
    double? freeQty,
    double? unitPrice,
    double? lineTotal,
    int? extractedPackSize,
    double? extractedRetailPrice,
    bool? mathVerified,
    double? confidenceScore,
    int? matchedItemId,
    double? previousUnitPrice,
    double? priceDiffAmount,
    double? effectiveUnitCost,
    double? singlePieceCost,
    bool? needsReview,
  }) =>
      ExtractedLineItem(
        lineNo: lineNo ?? this.lineNo,
        supplierItemCode: supplierItemCode ?? this.supplierItemCode,
        rawName: rawName ?? this.rawName,
        cleanItemName: cleanItemName ?? this.cleanItemName,
        unit: unit ?? this.unit,
        qtyNum: qtyNum ?? this.qtyNum,
        qtyWords: qtyWords ?? this.qtyWords,
        freeQty: freeQty ?? this.freeQty,
        unitPrice: unitPrice ?? this.unitPrice,
        lineTotal: lineTotal ?? this.lineTotal,
        extractedPackSize: extractedPackSize ?? this.extractedPackSize,
        extractedRetailPrice:
            extractedRetailPrice ?? this.extractedRetailPrice,
        mathVerified: mathVerified ?? this.mathVerified,
        confidenceScore: confidenceScore ?? this.confidenceScore,
        matchedItemId: matchedItemId ?? this.matchedItemId,
        previousUnitPrice: previousUnitPrice ?? this.previousUnitPrice,
        priceDiffAmount: priceDiffAmount ?? this.priceDiffAmount,
        effectiveUnitCost: effectiveUnitCost ?? this.effectiveUnitCost,
        singlePieceCost: singlePieceCost ?? this.singlePieceCost,
        needsReview: needsReview ?? this.needsReview,
      );
}

/// ملخص التذييل المالي.
class FinancialSummary {
  const FinancialSummary({
    this.totalPiecesCount,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.extraCharges = 0.0,
    this.netTotal = 0.0,
    this.printedPreviousBalance,
    this.printedCurrentBalance,
  });

  final double? totalPiecesCount;
  final double subtotal;
  final double discount;
  final double extraCharges;
  final double netTotal;
  final double? printedPreviousBalance;
  final double? printedCurrentBalance;

  FinancialSummary copyWith({
    double? totalPiecesCount,
    double? subtotal,
    double? discount,
    double? extraCharges,
    double? netTotal,
    double? printedPreviousBalance,
    double? printedCurrentBalance,
  }) =>
      FinancialSummary(
        totalPiecesCount: totalPiecesCount ?? this.totalPiecesCount,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        extraCharges: extraCharges ?? this.extraCharges,
        netTotal: netTotal ?? this.netTotal,
        printedPreviousBalance:
            printedPreviousBalance ?? this.printedPreviousBalance,
        printedCurrentBalance:
            printedCurrentBalance ?? this.printedCurrentBalance,
      );
}

/// تفاصيل سند القبض.
class VoucherDetails {
  const VoucherDetails({
    this.amount = 0.0,
    this.amountWords,
    this.statementNote,
  });

  final double amount;
  final String? amountWords;
  final String? statementNote;

  VoucherDetails copyWith({
    double? amount,
    String? amountWords,
    String? statementNote,
  }) =>
      VoucherDetails(
        amount: amount ?? this.amount,
        amountWords: amountWords ?? this.amountWords,
        statementNote: statementNote ?? this.statementNote,
      );
}

/// الوثيقة المستخرجة الكاملة (قبل الاعتماد).
class ExtractedDocument {
  const ExtractedDocument({
    required this.docType,
    required this.paperNumber,
    required this.date,
    required this.supplier,
    required this.lineItems,
    required this.financial,
    this.paymentStatus = PaymentStatus.credit,
    this.currency = 'YER',
    this.voucherDetails,
    this.imagePaths = const [],
  });

  final DocType docType;
  final String paperNumber;
  final DateTime date;
  final String currency;
  final PaymentStatus paymentStatus;
  final SupplierInfo supplier;
  final List<ExtractedLineItem> lineItems;
  final VoucherDetails? voucherDetails;
  final FinancialSummary financial;
  final List<String> imagePaths;

  bool get isInvoice => docType == DocType.purchaseInvoice;
  bool get isVoucher => docType == DocType.receiptVoucher;

  ExtractedDocument copyWith({
    DocType? docType,
    String? paperNumber,
    DateTime? date,
    String? currency,
    PaymentStatus? paymentStatus,
    SupplierInfo? supplier,
    List<ExtractedLineItem>? lineItems,
    VoucherDetails? voucherDetails,
    FinancialSummary? financial,
    List<String>? imagePaths,
  }) =>
      ExtractedDocument(
        docType: docType ?? this.docType,
        paperNumber: paperNumber ?? this.paperNumber,
        date: date ?? this.date,
        currency: currency ?? this.currency,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        supplier: supplier ?? this.supplier,
        lineItems: lineItems ?? this.lineItems,
        voucherDetails: voucherDetails ?? this.voucherDetails,
        financial: financial ?? this.financial,
        imagePaths: imagePaths ?? this.imagePaths,
      );
}
