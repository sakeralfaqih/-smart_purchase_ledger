import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/catalog_dao.dart';
import 'daos/invoices_dao.dart';
import 'daos/suppliers_dao.dart';
import 'daos/vouchers_dao.dart';
import 'tables/invoice_lines_table.dart';
import 'tables/items_table.dart';
import 'tables/payment_vouchers_table.dart';
import 'tables/purchase_invoices_table.dart';
import 'tables/supplier_items_table.dart';
import 'tables/suppliers_table.dart';

part 'app_database.g.dart';

/// قاعدة البيانات العلائقية المركزية (Drift / SQLite).
@DriftDatabase(
  tables: [
    Suppliers,
    Items,
    SupplierItems,
    PurchaseInvoices,
    InvoiceLines,
    PaymentVouchers,
  ],
  daos: [SuppliersDao, CatalogDao, InvoicesDao, VouchersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// للاختبارات: تمرير QueryExecutor مخصص (NativeDatabase.memory()).
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'hisab_almawrid');
}
