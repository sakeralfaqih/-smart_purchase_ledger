import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/entities/supplier_price_offer_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_local_datasource.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._local);

  final CatalogLocalDataSource _local;

  @override
  Stream<List<CatalogItemEntity>> watchAllItems() => _local.watchAllItems();

  @override
  Future<List<CatalogItemEntity>> getAllItems() => _local.getAllItems();

  @override
  Future<CatalogItemEntity?> getItem(int itemId) => _local.getItem(itemId);

  @override
  Future<List<CatalogItemEntity>> search(String query) => _local.search(query);

  @override
  Future<List<SupplierPriceOfferEntity>> getSupplierOffersForItem(int itemId) =>
      _local.getSupplierOffersForItem(itemId);

  @override
  Future<List<PriceHistoryPoint>> getPriceHistoryForItem(int itemId) =>
      _local.getPriceHistoryForItem(itemId);
}
