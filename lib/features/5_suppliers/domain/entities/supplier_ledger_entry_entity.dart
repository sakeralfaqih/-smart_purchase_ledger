/// نوع حركة كشف الحساب.
enum LedgerEntryType { invoice, voucher, opening }

/// سطر في كشف الحساب مع الرصيد التراكمي.
class SupplierLedgerEntryEntity {
  const SupplierLedgerEntryEntity({
    required this.date,
    required this.type,
    required this.referenceNumber,
    required this.description,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.documentId,
    this.imagePath,
  });

  final DateTime date;
  final LedgerEntryType type;
  final String referenceNumber;
  final String description;

  /// مدين: يزيد مديونية المحل للمورد (فاتورة مشتريات).
  final double debit;

  /// دائن: ينقص المديونية (سند سداد).
  final double credit;
  final double runningBalance;
  final int? documentId;
  final String? imagePath;

  double get signedAmount => debit - credit;
}
