import 'package:drift/drift.dart';

import 'items_table.dart';
import 'suppliers_table.dart';

/// قاموس ربط أصناف المورد بالصنف القياسي.
@TableIndex(name: 'idx_supplier_items_code', columns: {#supplierItemCode})
class SupplierItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId =>
      integer().references(Suppliers, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemId =>
      integer().references(Items, #id, onDelete: KeyAction.cascade)();

  /// رقم الصنف لدى المورد (مثل 001180).
  TextColumn get supplierItemCode => text().nullable()();

  /// الاسم كما يطبع في فاتورة المورد.
  TextColumn get rawOcrName => text()();
  TextColumn get defaultUnitName => text().nullable()();
  RealColumn get lastUnitPrice => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastPurchaseDate => dateTime().nullable()();
}
