class PaymentVoucherEntity {
  const PaymentVoucherEntity({
    this.id,
    required this.supplierId,
    this.linkedInvoiceId,
    required this.paperVoucherNumber,
    required this.voucherDate,
    this.currency = 'YER',
    required this.amount,
    this.amountWords,
    this.paymentMethod = 'cash',
    this.statementNote,
    this.printedRemainingBalance,
    this.imagePath,
    required this.createdAt,
  });

  final int? id;
  final int supplierId;
  final int? linkedInvoiceId;
  final String paperVoucherNumber;
  final DateTime voucherDate;
  final String currency;
  final double amount;
  final String? amountWords;
  final String paymentMethod;
  final String? statementNote;
  final double? printedRemainingBalance;
  final String? imagePath;
  final DateTime createdAt;
}
