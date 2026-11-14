import 'package:drift/drift.dart';

import 'suppliers_table.dart';

/// رأس فواتير المشتريات.
class PurchaseInvoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId =>
      integer().references(Suppliers, #id, onDelete: KeyAction.restrict)();

  /// رقم الفاتورة الورقية.
  TextColumn get paperInvoiceNumber => text()();
  DateTimeColumn get invoiceDate => dateTime()();
  TextColumn get currency => text().withDefault(const Constant('YER'))();

  /// 'credit' آجل / 'cash' نقدي / 'partial' جزئي.
  TextColumn get paymentType => text().withDefault(const Constant('credit'))();

  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get discount => real().withDefault(const Constant(0.0))();

  /// الأعباء / المصاريف الإضافية.
  RealColumn get extraCharges => real().withDefault(const Constant(0.0))();
  RealColumn get netTotal => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();

  /// المبلغ المرحل كدين.
  RealColumn get remainingAmount => real().withDefault(const Constant(0.0))();

  /// عدد القطع المطبوع في التذييل.
  RealColumn get printedTotalQty => real().nullable()();

  /// الرصيد السابق المطبوع.
  RealColumn get printedPrevBalance => real().nullable()();

  /// الرصيد الحالي المطبوع.
  RealColumn get printedCurrBalance => real().nullable()();

  /// مسارات صور صفحات الفاتورة بصيغة JSON.
  TextColumn get imagePathsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get hasMathWarning =>
      boolean().withDefault(const Constant(false))();

  /// 'confirmed' / 'draft_offline'.
  TextColumn get status => text().withDefault(const Constant('confirmed'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
