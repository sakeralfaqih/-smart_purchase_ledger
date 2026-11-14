/// سعر الصنف لدى مورد مع تاريخ آخر فاتورة.
class SupplierPriceOfferEntity {
  const SupplierPriceOfferEntity({
    required this.supplierId,
    required this.supplierName,
    required this.unitPrice,
    this.lastPurchaseDate,
    this.supplierItemCode,
  });

  final int supplierId;
  final String supplierName;
  final double unitPrice;
  final DateTime? lastPurchaseDate;
  final String? supplierItemCode;
}
