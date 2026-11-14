import 'invoice_line_entity.dart';

class PurchaseInvoiceEntity {
  const PurchaseInvoiceEntity({
    this.id,
    required this.supplierId,
    required this.paperInvoiceNumber,
    required this.invoiceDate,
    this.currency = 'YER',
    this.paymentType = 'credit',
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.extraCharges = 0.0,
    this.netTotal = 0.0,
    this.paidAmount = 0.0,
    this.remainingAmount = 0.0,
    this.printedTotalQty,
    this.printedPrevBalance,
    this.printedCurrBalance,
    this.imagePaths = const [],
    this.hasMathWarning = false,
    this.status = 'confirmed',
    required this.createdAt,
    this.lines = const [],
  });

  final int? id;
  final int supplierId;
  final String paperInvoiceNumber;
  final DateTime invoiceDate;
  final String currency;
  final String paymentType;
  final double subtotal;
  final double discount;
  final double extraCharges;
  final double netTotal;
  final double paidAmount;
  final double remainingAmount;
  final double? printedTotalQty;
  final double? printedPrevBalance;
  final double? printedCurrBalance;
  final List<String> imagePaths;
  final bool hasMathWarning;
  final String status;
  final DateTime createdAt;
  final List<InvoiceLineEntity> lines;

  PurchaseInvoiceEntity copyWith({
    int? id,
    int? supplierId,
    String? paperInvoiceNumber,
    DateTime? invoiceDate,
    String? currency,
    String? paymentType,
    double? subtotal,
    double? discount,
    double? extraCharges,
    double? netTotal,
    double? paidAmount,
    double? remainingAmount,
    double? printedTotalQty,
    double? printedPrevBalance,
    double? printedCurrBalance,
    List<String>? imagePaths,
    bool? hasMathWarning,
    String? status,
    DateTime? createdAt,
    List<InvoiceLineEntity>? lines,
  }) =>
      PurchaseInvoiceEntity(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        paperInvoiceNumber: paperInvoiceNumber ?? this.paperInvoiceNumber,
        invoiceDate: invoiceDate ?? this.invoiceDate,
        currency: currency ?? this.currency,
        paymentType: paymentType ?? this.paymentType,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        extraCharges: extraCharges ?? this.extraCharges,
        netTotal: netTotal ?? this.netTotal,
        paidAmount: paidAmount ?? this.paidAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        printedTotalQty: printedTotalQty ?? this.printedTotalQty,
        printedPrevBalance: printedPrevBalance ?? this.printedPrevBalance,
        printedCurrBalance: printedCurrBalance ?? this.printedCurrBalance,
        imagePaths: imagePaths ?? this.imagePaths,
        hasMathWarning: hasMathWarning ?? this.hasMathWarning,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        lines: lines ?? this.lines,
      );
}
