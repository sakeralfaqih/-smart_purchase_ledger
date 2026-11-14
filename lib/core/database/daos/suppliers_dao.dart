import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payment_vouchers_table.dart';
import '../tables/purchase_invoices_table.dart';
import '../tables/suppliers_table.dart';

part 'suppliers_dao.g.dart';

@DriftAccessor(tables: [Suppliers, PurchaseInvoices, PaymentVouchers])
class SuppliersDao extends DatabaseAccessor<AppDatabase>
    with _$SuppliersDaoMixin {
  SuppliersDao(super.db);

  Stream<List<Supplier>> watchAllSuppliers() =>
      (select(suppliers)..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .watch();

  Future<List<Supplier>> getAllSuppliers() => select(suppliers).get();

  Stream<Supplier?> watchSupplier(int id) =>
      (select(suppliers)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<Supplier?> getSupplier(int id) =>
      (select(suppliers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertSupplier(SuppliersCompanion companion) =>
      into(suppliers).insert(companion);

  Future<bool> updateSupplier(SuppliersCompanion companion) =>
      update(suppliers).replace(companion);

  Future<void> updateCalculatedBalance(int id, double balance) =>
      (update(suppliers)..where((t) => t.id.equals(id))).write(
        SuppliersCompanion(currentCalculatedBalance: Value(balance)),
      );

  Future<void> updatePrintedBalance(
    int id,
    double balance,
    DateTime docDate,
  ) =>
      (update(suppliers)..where((t) => t.id.equals(id))).write(
        SuppliersCompanion(
          lastPrintedSupplierBalance: Value(balance),
          lastBalanceDocDate: Value(docDate),
        ),
      );

  /// إعادة حساب الرصيد الدفتري للمورد من واقع الرصيد الافتتاحي والفواتير المعتمدة وسندات السداد.
  Future<double> recalculateAndSaveSupplierBalance(int supplierId) async {
    final supplier = await getSupplier(supplierId);
    if (supplier == null) return 0.0;

    final invRows = await (select(purchaseInvoices)
          ..where((t) =>
              t.supplierId.equals(supplierId) &
              t.status.equals('confirmed')))
        .get();

    final voucherRows = await (select(paymentVouchers)
          ..where((t) => t.supplierId.equals(supplierId)))
        .get();

    final totalRemainingInvoices =
        invRows.fold<double>(0.0, (sum, inv) => sum + inv.remainingAmount);
    final totalPaidVouchers =
        voucherRows.fold<double>(0.0, (sum, v) => sum + v.amount);

    final newBalance =
        supplier.openingBalance + totalRemainingInvoices - totalPaidVouchers;

    await updateCalculatedBalance(supplierId, newBalance);
    return newBalance;
  }

  Stream<double> watchTotalDebt() {
    final query = selectOnly(suppliers)
      ..addColumns([suppliers.currentCalculatedBalance.sum()]);
    return query.watchSingle().map(
          (row) =>
              row.read(suppliers.currentCalculatedBalance.sum()) ?? 0.0,
        );
  }

  /// الموردون الذين يختلف رصيدهم الدفتري عن آخر رصيد مطبوع.
  Stream<List<Supplier>> watchMismatchedSuppliers() {
    return watchAllSuppliers().map(
      (list) => list.where((s) {
        final printed = s.lastPrintedSupplierBalance;
        if (printed == null) return false;
        return (printed - s.currentCalculatedBalance).abs() > 0.01;
      }).toList(),
    );
  }

  Future<Supplier?> findByNameExact(String name) {
    final trimmed = name.trim();
    return (select(suppliers)
          ..where((t) => t.name.lower().equals(trimmed.toLowerCase())))
        .getSingleOrNull();
  }

  Future<List<Supplier>> search(String query) {
    final q = '%${query.trim()}%';
    return (select(suppliers)
          ..where((t) => t.name.like(q) | t.branchName.like(q)))
        .get();
  }
}
