import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/invoices_dao.dart';
import '../../../../core/database/daos/suppliers_dao.dart';
import '../../../../core/database/daos/vouchers_dao.dart';
import '../../domain/entities/payment_voucher_entity.dart';

class VouchersLocalDataSource {
  VouchersLocalDataSource(
    this._db,
    this._vouchersDao,
    this._suppliersDao,
    this._invoicesDao,
  );

  final AppDatabase _db;
  final VouchersDao _vouchersDao;
  final SuppliersDao _suppliersDao;
  // ignore: unused_field
  final InvoicesDao _invoicesDao;

  /// حفظ سند القبض وتحديث مديونية المورد والرصيد المطبوع داخل معاملة ذرية واحدة.
  Future<int> saveVoucherTransaction(PaymentVoucherEntity voucher) {
    return _db.transaction(() async {
      final id = await _vouchersDao.insertVoucher(
        PaymentVouchersCompanion.insert(
          supplierId: voucher.supplierId,
          linkedInvoiceId: Value(voucher.linkedInvoiceId),
          paperVoucherNumber: voucher.paperVoucherNumber,
          voucherDate: voucher.voucherDate,
          currency: Value(voucher.currency),
          amount: Value(voucher.amount),
          amountWords: Value(voucher.amountWords),
          paymentMethod: Value(voucher.paymentMethod),
          statementNote: Value(voucher.statementNote),
          printedRemainingBalance: Value(voucher.printedRemainingBalance),
          imagePath: Value(voucher.imagePath),
          createdAt: Value(voucher.createdAt),
        ),
      );

      // إعادة حساب الرصيد الدفتري للمورد من واقع الفواتير المعتمدة والسندات
      await _suppliersDao.recalculateAndSaveSupplierBalance(voucher.supplierId);

      // تحديث الرصيد المطبوع للمورد بشرط ألا يكون تاريخ السند أقدم من آخر وثيقة مسجلة
      if (voucher.printedRemainingBalance != null) {
        final supplier = await _suppliersDao.getSupplier(voucher.supplierId);
        final lastDocDate = supplier?.lastBalanceDocDate;
        if (lastDocDate == null || !voucher.voucherDate.isBefore(lastDocDate)) {
          await _suppliersDao.updatePrintedBalance(
            voucher.supplierId,
            voucher.printedRemainingBalance!,
            voucher.voucherDate,
          );
        }
      }

      return id;
    });
  }

  Stream<List<PaymentVoucherEntity>> watchBySupplier(int supplierId) =>
      _vouchersDao
          .watchVouchersBySupplier(supplierId)
          .map((list) => list.map(_map).toList());

  Future<List<PaymentVoucherEntity>> getBySupplier(int supplierId) async {
    final list = await _vouchersDao.getVouchersBySupplier(supplierId);
    return list.map(_map).toList();
  }

  PaymentVoucherEntity _map(PaymentVoucher v) => PaymentVoucherEntity(
        id: v.id,
        supplierId: v.supplierId,
        linkedInvoiceId: v.linkedInvoiceId,
        paperVoucherNumber: v.paperVoucherNumber,
        voucherDate: v.voucherDate,
        currency: v.currency,
        amount: v.amount,
        amountWords: v.amountWords,
        paymentMethod: v.paymentMethod,
        statementNote: v.statementNote,
        printedRemainingBalance: v.printedRemainingBalance,
        imagePath: v.imagePath,
        createdAt: v.createdAt,
      );

  /// حذف السند وإعادة حساب مديونية المورد فوراً داخل معاملة ذرية.
  Future<void> deleteVoucher(int id) {
    return _db.transaction(() async {
      final existing = await _vouchersDao.getVoucher(id);
      await _vouchersDao.deleteVoucher(id);
      if (existing != null) {
        await _suppliersDao.recalculateAndSaveSupplierBalance(
          existing.supplierId,
        );
      }
    });
  }
}
