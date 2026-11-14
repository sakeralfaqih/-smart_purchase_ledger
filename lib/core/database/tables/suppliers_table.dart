import 'package:drift/drift.dart';

/// جدول الموردين والأرصدة والرقم التحليلي.
class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get branchName => text().nullable()();

  /// الرقم التحليلي / رقم حساب العميل لدى المورد (مثل 13007).
  TextColumn get analyticAccountNo => text().nullable()();

  /// مصفوفة أرقام الهواتف بصيغة JSON.
  TextColumn get phonesJson => text().withDefault(const Constant('[]'))();

  /// مسميات المورد البديلة للـ OCR بصيغة JSON.
  TextColumn get ocrAliasesJson => text().withDefault(const Constant('[]'))();

  TextColumn get currency => text().withDefault(const Constant('YER'))();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get currentCalculatedBalance =>
      real().withDefault(const Constant(0.0))();

  /// آخر رصيد مطبوع في وثيقة المورد.
  RealColumn get lastPrintedSupplierBalance => real().nullable()();
  DateTimeColumn get lastBalanceDocDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
