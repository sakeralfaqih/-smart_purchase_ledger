/// مرشح مطابقة صنف من دليل الأصناف.
class ItemMatchCandidate {
  const ItemMatchCandidate({
    required this.itemId,
    required this.canonicalName,
    required this.normalizedName,
    this.packUnitsCount,
    this.suggestedRetailPrice,
  });

  final int itemId;
  final String canonicalName;
  final String normalizedName;
  final int? packUnitsCount;
  final double? suggestedRetailPrice;
}

/// واجهة البحث في دليل الأصناف وإنشاء الأصناف الجديدة (تبقى طبقة الـ Domain مستقلة عن SQLite).
abstract class ItemMatchingRepository {
  Future<List<ItemMatchCandidate>> getCandidates();

  Future<ItemMatchCandidate?> findBySupplierCode(int supplierId, String code);

  Future<double?> getLastUnitPrice(int itemId);

  /// يضمن وجود الصنف في دليل الأصناف (يجلبه إن وُجد أو ينشئه كصنف جديد ويعيد معرفه).
  Future<ItemMatchCandidate> ensureItemExists({
    required String canonicalName,
    required String defaultUnit,
    int? packUnitsCount,
    double? suggestedRetailPrice,
    double? initialPurchasePrice,
  });
}
