import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/catalog_dao.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/entities/supplier_price_offer_entity.dart';
import '../../domain/repositories/catalog_repository.dart';

/// مصدر بيانات محلي لذاكرة الأسعار يعتمد على CatalogDao.
class CatalogLocalDataSource {
  CatalogLocalDataSource(this._dao);

  final CatalogDao _dao;

  Stream<List<CatalogItemEntity>> watchAllItems() =>
      _dao.watchAllItems().map((rows) => rows.map(_mapItem).toList());

  Future<List<CatalogItemEntity>> getAllItems() async {
    final rows = await _dao.getAllItems();
    return rows.map(_mapItem).toList();
  }

  Future<CatalogItemEntity?> getItem(int itemId) async {
    final row = await _dao.getItem(itemId);
    return row == null ? null : _mapItem(row);
  }

  Future<List<CatalogItemEntity>> search(String query) async {
    final rows = await _dao.search(query);
    return rows.map(_mapItem).toList();
  }

  Future<List<SupplierPriceOfferEntity>> getSupplierOffersForItem(
    int itemId,
  ) async {
    final rows = await _dao.getSupplierOffersForItem(itemId);
    return rows
        .map(
          (r) => SupplierPriceOfferEntity(
            supplierId: r.supplier.id,
            supplierName: r.supplier.name,
            unitPrice: r.supplierItem.lastUnitPrice,
            lastPurchaseDate: r.supplierItem.lastPurchaseDate,
            supplierItemCode: r.supplierItem.supplierItemCode,
          ),
        )
        .toList();
  }

  Future<List<PriceHistoryPoint>> getPriceHistoryForItem(int itemId) async {
    final rows = await _dao.getPriceHistoryForItem(itemId);
    return rows
        .map(
          (r) => PriceHistoryPoint(
            date: r.invoice.invoiceDate,
            unitPrice: r.line.unitPrice,
            supplierId: r.invoice.supplierId,
            supplierName:
                r.supplier?.name ?? 'مورد #${r.invoice.supplierId}',
            freeQuantity: r.line.freeQuantity,
            quantity: r.line.quantity,
          ),
        )
        .toList();
  }

  CatalogItemEntity _mapItem(Item row) => CatalogItemEntity(
        id: row.id,
        canonicalName: row.canonicalName,
        normalizedName: row.normalizedName,
        defaultUnit: row.defaultUnit,
        packUnitsCount: row.packUnitsCount,
        suggestedRetailPrice: row.suggestedRetailPrice,
        lastPurchasePrice: row.lastPurchasePrice,
        lowestPurchasePrice: row.lowestPurchasePrice,
        lowestSupplierId: row.lowestSupplierId,
        updatedAt: row.updatedAt,
      );
}
