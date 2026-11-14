import '../entities/catalog_item_entity.dart';
import '../entities/supplier_price_offer_entity.dart';

/// عقد الوصول إلى ذاكرة الأسعار والكتالوج.
abstract class CatalogRepository {
  /// كل الأصناف المخزنة في ذاكرة الأسعار.
  Stream<List<CatalogItemEntity>> watchAllItems();

  Future<List<CatalogItemEntity>> getAllItems();

  Future<CatalogItemEntity?> getItem(int itemId);

  /// بحث نصّي في أسماء الأصناف.
  Future<List<CatalogItemEntity>> search(String query);

  /// كل عروض الأسعار لصنف من مختلف الموردين (مرتبة تصاعدياً بالسعر).
  Future<List<SupplierPriceOfferEntity>> getSupplierOffersForItem(int itemId);

  /// تاريخ أسعار صنف عبر الزمن (من أقدم إلى أحدث).
  Future<List<PriceHistoryPoint>> getPriceHistoryForItem(int itemId);
}

/// نقطة في تاريخ سعر صنف.
class PriceHistoryPoint {
  const PriceHistoryPoint({
    required this.date,
    required this.unitPrice,
    required this.supplierId,
    required this.supplierName,
    this.freeQuantity = 0,
    this.quantity = 0,
  });

  final DateTime date;
  final double unitPrice;
  final int supplierId;
  final String supplierName;
  final double freeQuantity;
  final double quantity;
}
