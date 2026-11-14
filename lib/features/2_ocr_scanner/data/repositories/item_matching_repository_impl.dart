import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/catalog_dao.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../domain/repositories/item_matching_repository.dart';

class ItemMatchingRepositoryImpl implements ItemMatchingRepository {
  ItemMatchingRepositoryImpl(this._catalogDao);

  final CatalogDao _catalogDao;

  @override
  Future<List<ItemMatchCandidate>> getCandidates() async {
    final items = await _catalogDao.getAllItems();
    return items
        .map((i) => ItemMatchCandidate(
              itemId: i.id,
              canonicalName: i.canonicalName,
              normalizedName: i.normalizedName,
              packUnitsCount: i.packUnitsCount,
              suggestedRetailPrice: i.suggestedRetailPrice,
            ))
        .toList();
  }

  @override
  Future<ItemMatchCandidate?> findBySupplierCode(
    int supplierId,
    String code,
  ) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return null;
    final supplierItem =
        await _catalogDao.getSupplierItemByCode(supplierId, trimmed);
    if (supplierItem == null) return null;
    final item = await _catalogDao.getItem(supplierItem.itemId);
    if (item == null) return null;
    return ItemMatchCandidate(
      itemId: item.id,
      canonicalName: item.canonicalName,
      normalizedName: item.normalizedName,
      packUnitsCount: item.packUnitsCount,
      suggestedRetailPrice: item.suggestedRetailPrice,
    );
  }

  @override
  Future<double?> getLastUnitPrice(int itemId) async {
    final history = await _catalogDao.getPriceHistoryForItem(itemId);
    if (history.isNotEmpty) {
      return history.last.line.unitPrice;
    }
    final item = await _catalogDao.getItem(itemId);
    return item?.lastPurchasePrice;
  }

  @override
  Future<ItemMatchCandidate> ensureItemExists({
    required String canonicalName,
    required String defaultUnit,
    int? packUnitsCount,
    double? suggestedRetailPrice,
    double? initialPurchasePrice,
  }) async {
    final clean = canonicalName.trim().isEmpty
        ? 'صنف بدون اسم'
        : canonicalName.trim();
    final normalized = ArabicTextNormalizer.normalize(clean);

    final existing = await _catalogDao.findByNormalizedName(normalized);
    if (existing != null) {
      return ItemMatchCandidate(
        itemId: existing.id,
        canonicalName: existing.canonicalName,
        normalizedName: existing.normalizedName,
        packUnitsCount: existing.packUnitsCount ?? packUnitsCount,
        suggestedRetailPrice:
            existing.suggestedRetailPrice ?? suggestedRetailPrice,
      );
    }

    final newId = await _catalogDao.insertItem(
      ItemsCompanion.insert(
        canonicalName: clean,
        normalizedName: normalized,
        defaultUnit: Value(defaultUnit.trim().isEmpty ? 'كرتون' : defaultUnit),
        packUnitsCount: Value(packUnitsCount),
        suggestedRetailPrice: Value(suggestedRetailPrice),
        lastPurchasePrice: Value(initialPurchasePrice),
        lowestPurchasePrice: Value(initialPurchasePrice),
      ),
    );

    return ItemMatchCandidate(
      itemId: newId,
      canonicalName: clean,
      normalizedName: normalized,
      packUnitsCount: packUnitsCount,
      suggestedRetailPrice: suggestedRetailPrice,
    );
  }
}
