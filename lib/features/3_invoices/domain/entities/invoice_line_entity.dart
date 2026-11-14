class InvoiceLineEntity {
  const InvoiceLineEntity({
    this.id,
    this.invoiceId,
    required this.itemId,
    required this.lineNumber,
    this.supplierItemCode,
    required this.rawItemName,
    required this.unitName,
    required this.quantity,
    this.quantityWords,
    this.freeQuantity = 0.0,
    required this.unitPrice,
    required this.lineTotal,
    required this.effectiveUnitCost,
    this.singlePieceCost,
    this.previousUnitPrice,
    this.priceDiffAmount = 0.0,
    this.needsReview = false,
    this.extractedPackSize,
    this.extractedRetailPrice,
  });

  final int? id;
  final int? invoiceId;
  final int itemId;
  final int lineNumber;
  final String? supplierItemCode;
  final String rawItemName;
  final String unitName;
  final double quantity;
  final String? quantityWords;
  final double freeQuantity;
  final double unitPrice;
  final double lineTotal;
  final double effectiveUnitCost;
  final double? singlePieceCost;
  final double? previousUnitPrice;
  final double priceDiffAmount;
  final bool needsReview;
  final int? extractedPackSize;
  final double? extractedRetailPrice;
}
