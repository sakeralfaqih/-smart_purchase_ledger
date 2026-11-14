import 'package:drift/drift.dart';

import 'suppliers_table.dart';

/// دليل الأصناف الموحد (Canonical Items).
@TableIndex(name: 'idx_items_normalized', columns: {#normalizedName})
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get canonicalName => text().unique()();

  /// الاسم بعد تطبيع الحروف العربية (للبحث السريع).
  TextColumn get normalizedName => text()();

  /// الوحدة الافتراضية: كرتون/دبة/كيس/تنكة/باكت/قطم.
  TextColumn get defaultUnit => text().withDefault(const Constant('كرتون'))();

  /// عدد الحبات/الوحدات الصغرى في العبوة.
  IntColumn get packUnitsCount => integer().nullable()();

  /// سعر البيع المقترح للمستهلك.
  RealColumn get suggestedRetailPrice => real().nullable()();

  RealColumn get lastPurchasePrice => real().nullable()();
  RealColumn get lowestPurchasePrice => real().nullable()();
  IntColumn get lowestSupplierId =>
      integer().nullable().references(Suppliers, #id)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
