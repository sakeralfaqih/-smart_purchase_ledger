import 'package:drift/drift.dart';

import '../../services/arabic_text_normalizer.dart';
import '../app_database.dart';
import '../tables/invoice_lines_table.dart';
import '../tables/items_table.dart';
import '../tables/purchase_invoices_table.dart';
import '../tables/supplier_items_table.dart';
import '../tables/suppliers_table.dart';

part 'catalog_dao.g.dart';

/// صف مقارنة سعر صنف لدى مورد.
class SupplierOfferRow {
  SupplierOfferRow(this.supplierItem, this.supplier);
  final SupplierItem supplierItem;
  final Supplier supplier;
}

/// صف تاريخ سعر صنف (من سطر فاتورة + الفاتورة + المورد).
class PriceHistoryRow {
  PriceHistoryRow(this.line, this.invoice, [this.supplier]);
  final InvoiceLine line;
  final PurchaseInvoice invoice;
  final Supplier? supplier;
}

@DriftAccessor(tables: [
  Items,
  SupplierItems,
  Suppliers,
  InvoiceLines,
  PurchaseInvoices,
])
class CatalogDao extends DatabaseAccessor<AppDatabase>
    with _$CatalogDaoMixin {
  CatalogDao(super.db);

  Stream<List<Item>> watchAllItems() =>
      (select(items)..orderBy([(t) => OrderingTerm(expression: t.canonicalName)]))
          .watch();

  Future<List<Item>> getAllItems() => select(items).get();

  Future<Item?> getItem(int id) =>
      (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Item?> findByNormalizedName(String normalized) =>
      (select(items)..where((t) => t.normalizedName.equals(normalized)))
          .getSingleOrNull();

  Future<List<Item>> search(String query) {
    final rawQ = '%${query.trim()}%';
    final normQ = '%${ArabicTextNormalizer.normalize(query)}%';
    return (select(items)
          ..where(
              (t) => t.canonicalName.like(rawQ) | t.normalizedName.like(normQ)))
        .get();
  }

  Future<int> insertItem(ItemsCompanion companion) =>
      into(items).insert(companion);

  /// تحديث أسعار الصنف مع الحفاظ على سعة العبوة وسعر البيع السابقين في حال عدم تمرير قيم جديدة.
  Future<void> updateItemPrices(
    int itemId, {
    required double lastPurchasePrice,
    required double lowestPurchasePrice,
    int? lowestSupplierId,
    int? packUnitsCount,
    double? suggestedRetailPrice,
  }) =>
      (update(items)..where((t) => t.id.equals(itemId))).write(
        ItemsCompanion(
          lastPurchasePrice: Value(lastPurchasePrice),
          lowestPurchasePrice: Value(lowestPurchasePrice),
          lowestSupplierId: lowestSupplierId != null
              ? Value(lowestSupplierId)
              : const Value.absent(),
          packUnitsCount: packUnitsCount != null
              ? Value(packUnitsCount)
              : const Value.absent(),
          suggestedRetailPrice: suggestedRetailPrice != null
              ? Value(suggestedRetailPrice)
              : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<SupplierItem?> getSupplierItemByCode(int supplierId, String code) =>
      (select(supplierItems)
            ..where((t) =>
                t.supplierId.equals(supplierId) &
                t.supplierItemCode.equals(code)))
          .getSingleOrNull();

  Future<SupplierItem?> getSupplierItemByName(int supplierId, String rawName) =>
      (select(supplierItems)
            ..where((t) =>
                t.supplierId.equals(supplierId) &
                t.rawOcrName.equals(rawName)))
          .getSingleOrNull();

  /// مراقبة كافة الأصناف المشتراة من مورد معين (مرتبة بأحدث تاريخ شراء).
  Stream<List<SupplierItem>> watchSupplierItemsBySupplier(int supplierId) =>
      (select(supplierItems)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.lastPurchaseDate,
                    mode: OrderingMode.desc,
                  ),
            ]))
          .watch();

  Future<int> upsertSupplierItem(SupplierItemsCompanion companion) async {
    final code = companion.supplierItemCode.present
        ? companion.supplierItemCode.value
        : null;
    SupplierItem? existing;
    if (code != null && code.isNotEmpty) {
      existing = await getSupplierItemByCode(
        companion.supplierId.value,
        code,
      );
    }
    existing ??= await getSupplierItemByName(
      companion.supplierId.value,
      companion.rawOcrName.value,
    );
    if (existing != null) {
      await (update(supplierItems)..where((t) => t.id.equals(existing!.id)))
          .write(companion);
      return existing.id;
    }
    return into(supplierItems).insert(companion);
  }

  /// كل عروض الأسعار لصنف معين لدى جميع الموردين مرتبة من الأرخص إلى الأغلى.
  Future<List<SupplierOfferRow>> getSupplierOffersForItem(int itemId) async {
    final query = select(supplierItems).join([
      innerJoin(suppliers, suppliers.id.equalsExp(supplierItems.supplierId)),
    ])
      ..where(supplierItems.itemId.equals(itemId))
      ..orderBy([OrderingTerm(expression: supplierItems.lastUnitPrice)]);
    final rows = await query.get();
    return rows
        .map((r) => SupplierOfferRow(
              r.readTable(supplierItems),
              r.readTable(suppliers),
            ))
        .toList();
  }

  /// تاريخ أسعار صنف عبر الزمن مع بيانات المورد (مرتب تصاعدياً بالتاريخ ثم برقم الفاتورة).
  Future<List<PriceHistoryRow>> getPriceHistoryForItem(int itemId) async {
    final query = select(invoiceLines).join([
      innerJoin(
        purchaseInvoices,
        purchaseInvoices.id.equalsExp(invoiceLines.invoiceId),
      ),
      leftOuterJoin(
        suppliers,
        suppliers.id.equalsExp(purchaseInvoices.supplierId),
      ),
    ])
      ..where(invoiceLines.itemId.equals(itemId))
      ..orderBy([
        OrderingTerm(expression: purchaseInvoices.invoiceDate),
        OrderingTerm(expression: purchaseInvoices.id),
      ]);
    final rows = await query.get();
    return rows
        .map((r) => PriceHistoryRow(
              r.readTable(invoiceLines),
              r.readTable(purchaseInvoices),
              r.readTableOrNull(suppliers),
            ))
        .toList();
  }
}
