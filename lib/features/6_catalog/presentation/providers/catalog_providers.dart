import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/catalog_local_datasource.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/entities/supplier_price_offer_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/usecases/calculate_unit_cost_usecase.dart';
import '../../domain/usecases/compare_supplier_prices_usecase.dart';

final catalogLocalDataSourceProvider = Provider<CatalogLocalDataSource>(
  (ref) => CatalogLocalDataSource(ref.watch(catalogDaoProvider)),
);

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepositoryImpl(ref.watch(catalogLocalDataSourceProvider)),
);

final calculateUnitCostUseCaseProvider = Provider<CalculateUnitCostUseCase>(
    (ref) => const CalculateUnitCostUseCase());

final compareSupplierPricesUseCaseProvider =
    Provider<CompareSupplierPricesUseCase>(
        (ref) => const CompareSupplierPricesUseCase());

final catalogItemsProvider =
    StreamProvider.autoDispose<List<CatalogItemEntity>>((ref) {
  return ref.watch(catalogRepositoryProvider).watchAllItems();
});

/// جلب صنف واحد بمعرّفه (يتحدث تلقائياً مع تغير جدول الأصناف).
final catalogItemByIdProvider = FutureProvider.autoDispose
    .family<CatalogItemEntity?, int>((ref, itemId) {
  ref.watch(catalogItemsProvider);
  return ref.watch(catalogRepositoryProvider).getItem(itemId);
});

final catalogSearchProvider =
    FutureProvider.autoDispose.family<List<CatalogItemEntity>, String>(
        (ref, query) {
  ref.watch(catalogItemsProvider);
  if (query.trim().isEmpty) {
    return ref.watch(catalogRepositoryProvider).getAllItems();
  }
  return ref.watch(catalogRepositoryProvider).search(query);
});

/// عروض أسعار الموردين لصنف معين (تتحدث تلقائياً عند تغير بيانات الأصناف والفواتير).
final itemOffersProvider = FutureProvider.autoDispose
    .family<List<SupplierPriceOfferEntity>, int>((ref, itemId) {
  ref.watch(catalogItemsProvider);
  return ref.watch(catalogRepositoryProvider).getSupplierOffersForItem(itemId);
});

/// السجل التاريخي لتغير سعر الصنف عبر الزمن (يتحدث تلقائياً).
final itemPriceHistoryProvider = FutureProvider.autoDispose
    .family<List<PriceHistoryPoint>, int>((ref, itemId) {
  ref.watch(catalogItemsProvider);
  return ref.watch(catalogRepositoryProvider).getPriceHistoryForItem(itemId);
});
