import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payment_vouchers_table.dart';
import '../tables/purchase_invoices_table.dart';
import '../tables/suppliers_table.dart';

part 'vouchers_dao.g.dart';

@DriftAccessor(tables: [PaymentVouchers, Suppliers, PurchaseInvoices])
class VouchersDao extends DatabaseAccessor<AppDatabase>
    with _$VouchersDaoMixin {
  VouchersDao(super.db);

  Future<int> insertVoucher(PaymentVouchersCompanion companion) =>
      into(paymentVouchers).insert(companion);

  Future<PaymentVoucher?> getVoucher(int id) =>
      (select(paymentVouchers)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Stream<List<PaymentVoucher>> watchVouchersBySupplier(int supplierId) =>
      (select(paymentVouchers)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.voucherDate),
              (t) => OrderingTerm(expression: t.id),
            ]))
          .watch();

  Future<List<PaymentVoucher>> getVouchersBySupplier(int supplierId) =>
      (select(paymentVouchers)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.voucherDate),
              (t) => OrderingTerm(expression: t.id),
            ]))
          .get();

  Future<PaymentVoucher?> getLastVoucherForSupplier(int supplierId) =>
      (select(paymentVouchers)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.voucherDate,
                    mode: OrderingMode.desc,
                  ),
              (t) => OrderingTerm(
                    expression: t.id,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<void> deleteVoucher(int id) =>
      (delete(paymentVouchers)..where((t) => t.id.equals(id))).go();
}
