class CatalogItemEntity {
  const CatalogItemEntity({
    this.id,
    required this.canonicalName,
    required this.normalizedName,
    this.defaultUnit = 'كرتون',
    this.packUnitsCount,
    this.suggestedRetailPrice,
    this.lastPurchasePrice,
    this.lowestPurchasePrice,
    this.lowestSupplierId,
    this.updatedAt,
  });

  final int? id;
  final String canonicalName;
  final String normalizedName;
  final String defaultUnit;
  final int? packUnitsCount;
  final double? suggestedRetailPrice;
  final double? lastPurchasePrice;
  final double? lowestPurchasePrice;
  final int? lowestSupplierId;
  final DateTime? updatedAt;

  /// تكلفة الحبة الواحدة بناءً على آخر سعر شراء وعدد الحبات في العبوة.
  double? get singlePieceCost {
    final last = lastPurchasePrice;
    final pack = packUnitsCount;
    if (last == null || pack == null || pack <= 0) return null;
    return last / pack;
  }

  /// صافي ربح الحبة الواحدة (سعر البيع المقترح للجمهور - تكلفة الحبة).
  double? get profitPerPiece {
    final cost = singlePieceCost;
    final retail = suggestedRetailPrice;
    if (cost == null || retail == null || retail <= 0) return null;
    return retail - cost;
  }

  /// نسبة هامش الربح المئوية للحبة الواحدة.
  double? get profitMarginPercentage {
    final cost = singlePieceCost;
    final profit = profitPerPiece;
    if (cost == null || cost <= 0 || profit == null) return null;
    return (profit / cost) * 100;
  }

  CatalogItemEntity copyWith({
    int? id,
    String? canonicalName,
    String? normalizedName,
    String? defaultUnit,
    int? packUnitsCount,
    double? suggestedRetailPrice,
    double? lastPurchasePrice,
    double? lowestPurchasePrice,
    int? lowestSupplierId,
    DateTime? updatedAt,
  }) =>
      CatalogItemEntity(
        id: id ?? this.id,
        canonicalName: canonicalName ?? this.canonicalName,
        normalizedName: normalizedName ?? this.normalizedName,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        packUnitsCount: packUnitsCount ?? this.packUnitsCount,
        suggestedRetailPrice: suggestedRetailPrice ?? this.suggestedRetailPrice,
        lastPurchasePrice: lastPurchasePrice ?? this.lastPurchasePrice,
        lowestPurchasePrice: lowestPurchasePrice ?? this.lowestPurchasePrice,
        lowestSupplierId: lowestSupplierId ?? this.lowestSupplierId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
