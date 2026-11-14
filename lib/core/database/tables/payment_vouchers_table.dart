import 'package:drift/drift.dart';

import 'purchase_invoices_table.dart';
import 'suppliers_table.dart';

/// سندات القبض/السداد المستلمة من الموردين.
class PaymentVouchers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId =>
      integer().references(Suppliers, #id, onDelete: KeyAction.restrict)();
  IntColumn get linkedInvoiceId => integer()
      .nullable()
      .references(PurchaseInvoices, #id, onDelete: KeyAction.setNull)();

  /// رقم السند الورقي.
  TextColumn get paperVoucherNumber => text()();
  DateTimeColumn get voucherDate => dateTime()();
  TextColumn get currency => text().withDefault(const Constant('YER'))();
  RealColumn get amount => real().withDefault(const Constant(0.0))();

  /// المبلغ كتابةً.
  TextColumn get amountWords => text().nullable()();

  /// نقداً / حوالة.
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();

  /// البيان مثل: لكم نقداً من الحساب.
  TextColumn get statementNote => text().nullable()();

  /// الرصيد المتبقي المطبوع في السند.
  RealColumn get printedRemainingBalance => real().nullable()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
