/// نتيجة مقارنة رصيد التطبيق بالرصيد المطبوع لدى المورد.
class BalanceReconciliationEntity {
  const BalanceReconciliationEntity({
    required this.supplierId,
    required this.supplierName,
    required this.calculatedBalance,
    this.printedBalance,
    this.printedDocDate,
  });

  final int supplierId;
  final String supplierName;
  final double calculatedBalance;
  final double? printedBalance;
  final DateTime? printedDocDate;

  double get difference => (printedBalance ?? calculatedBalance) - calculatedBalance;

  bool get hasPrintedBalance => printedBalance != null;

  bool get isMatched => !hasPrintedBalance || difference.abs() <= 0.01;

  String get statusText => isMatched ? 'متطابق' : 'فرق رصيد';
}
