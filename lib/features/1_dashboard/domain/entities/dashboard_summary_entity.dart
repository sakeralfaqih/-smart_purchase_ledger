/// اتجاه تغيّر السعر.
enum PriceDirection { up, down, same }

/// تنبيه تغيّر سعر صنف بين آخر شراء وسابقه.
class PriceChangeAlert {
  const PriceChangeAlert({
    required this.itemId,
    required this.itemName,
    required this.supplierId,
    required this.supplierName,
    required this.previousPrice,
    required this.currentPrice,
    required this.changeDate,
  });

  final int itemId;
  final String itemName;
  final int supplierId;
  final String supplierName;
  final double previousPrice;
  final double currentPrice;
  final DateTime changeDate;

  double get difference => currentPrice - previousPrice;

  double get percentageChange =>
      previousPrice == 0 ? 0 : (difference / previousPrice) * 100;

  PriceDirection get direction {
    if (difference > 0.0001) return PriceDirection.up;
    if (difference < -0.0001) return PriceDirection.down;
    return PriceDirection.same;
  }
}

/// ملخص نشاط حديث (فاتورة شراء).
class RecentInvoiceSummary {
  const RecentInvoiceSummary({
    required this.invoiceId,
    required this.supplierId,
    required this.supplierName,
    required this.paperInvoiceNumber,
    required this.invoiceDate,
    required this.netTotal,
    required this.paymentType,
    this.hasMathWarning = false,
  });

  final int invoiceId;
  final int supplierId;
  final String supplierName;
  final String paperInvoiceNumber;
  final DateTime invoiceDate;
  final double netTotal;
  final String paymentType;
  final bool hasMathWarning;
}

/// الملخص الكامل للوحة الرئيسية.
class DashboardSummary {
  const DashboardSummary({
    required this.totalDebt,
    required this.supplierCount,
    required this.mismatchedSupplierCount,
    required this.recentPriceChanges,
    required this.recentInvoices,
    this.monthPurchases = 0,
    this.monthPayments = 0,
  });

  final double totalDebt;
  final int supplierCount;
  final int mismatchedSupplierCount;
  final List<PriceChangeAlert> recentPriceChanges;
  final List<RecentInvoiceSummary> recentInvoices;
  final double monthPurchases;
  final double monthPayments;

  bool get hasMismatches => mismatchedSupplierCount > 0;
  bool get hasPriceAlerts => recentPriceChanges.isNotEmpty;
}
