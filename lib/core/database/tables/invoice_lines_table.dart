import 'package:drift/drift.dart';

import 'items_table.dart';
import 'purchase_invoices_table.dart';

/// أسطر فاتورة المشتريات.
class InvoiceLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()
      .references(PurchaseInvoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemId =>
      integer().references(Items, #id, onDelete: KeyAction.restrict)();
  IntColumn get lineNumber => integer().withDefault(const Constant(1))();
  TextColumn get supplierItemCode => text().nullable()();
  TextColumn get rawItemName => text()();
  TextColumn get unitName => text().withDefault(const Constant('كرتون'))();
  RealColumn get quantity => real().withDefault(const Constant(0.0))();

  /// الكمية كتابةً (مثل: خمسة كرتون).
  TextColumn get quantityWords => text().nullable()();

  /// ك.المجانية / البونص.
  RealColumn get freeQuantity => real().withDefault(const Constant(0.0))();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get lineTotal => real().withDefault(const Constant(0.0))();

  /// تكلفة العبوة الفعلية بعد البونص.
  RealColumn get effectiveUnitCost => real().withDefault(const Constant(0.0))();

  /// تكلفة الحبة الواحدة.
  RealColumn get singlePieceCost => real().nullable()();
  RealColumn get previousUnitPrice => real().nullable()();

  /// فرق السعر عن آخر شراء.
  RealColumn get priceDiffAmount => real().withDefault(const Constant(0.0))();
  BoolColumn get needsReview => boolean().withDefault(const Constant(false))();
}
