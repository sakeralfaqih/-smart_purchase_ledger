import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/invoice_lines_table.dart';
import '../tables/items_table.dart';
import '../tables/purchase_invoices_table.dart';
import '../tables/supplier_items_table.dart';
import '../tables/suppliers_table.dart';

part 'invoices_dao.g.dart';

/// رأس فاتورة مع أسطرها.
class InvoiceWithLines {
  InvoiceWithLines(this.invoice, this.lines);
  final PurchaseInvoice invoice;
  final List<InvoiceLine> lines;
}

/// سطر فاتورة مع تاريخ فاتورته (للمقارنة الزمنية).
class DatedLine {
  DatedLine(this.line, this.invoiceDate);
  final InvoiceLine line;
  final DateTime invoiceDate;
}

@DriftAccessor(tables: [
  PurchaseInvoices,
  InvoiceLines,
  Items,
  Suppliers,
  SupplierItems,
])
class InvoicesDao extends DatabaseAccessor<AppDatabase>
    with _$InvoicesDaoMixin {
  InvoicesDao(super.db);

  Future<int> insertHeader(PurchaseInvoicesCompanion companion) =>
      into(purchaseInvoices).insert(companion);

  Future<int> insertLine(InvoiceLinesCompanion companion) =>
      into(invoiceLines).insert(companion);

  Future<PurchaseInvoice?> getInvoice(int id) =>
      (select(purchaseInvoices)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<InvoiceLine>> getLines(int invoiceId) =>
      (select(invoiceLines)
            ..where((t) => t.invoiceId.equals(invoiceId))
            ..orderBy([(t) => OrderingTerm(expression: t.lineNumber)]))
          .get();

  Future<InvoiceWithLines?> getInvoiceWithLines(int invoiceId) async {
    final invoice = await getInvoice(invoiceId);
    if (invoice == null) return null;
    final lines = await getLines(invoiceId);
    return InvoiceWithLines(invoice, lines);
  }

  Stream<List<PurchaseInvoice>> watchInvoicesBySupplier(int supplierId) =>
      (select(purchaseInvoices)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.invoiceDate),
              (t) => OrderingTerm(expression: t.id),
            ]))
          .watch();

  Future<List<PurchaseInvoice>> getInvoicesBySupplier(int supplierId) =>
      (select(purchaseInvoices)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.invoiceDate),
              (t) => OrderingTerm(expression: t.id),
            ]))
          .get();

  Stream<List<PurchaseInvoice>> watchRecentInvoices({int limit = 20}) =>
      (select(purchaseInvoices)
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  ),
              (t) => OrderingTerm(
                    expression: t.id,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(limit))
          .watch();

  Future<List<PurchaseInvoice>> getRecentInvoices({int limit = 20}) =>
      (select(purchaseInvoices)
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  ),
              (t) => OrderingTerm(
                    expression: t.id,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(limit))
          .get();

  /// آخر سطر شراء لصنف معين (الأحدث تاريخاً ثم الأحدث إدخالاً) — لأجل مقارنة السعر.
  Future<DatedLine?> getLastLineForItem(int itemId) async {
    final query = select(invoiceLines).join([
      innerJoin(
        purchaseInvoices,
        purchaseInvoices.id.equalsExp(invoiceLines.invoiceId),
      ),
    ])
      ..where(invoiceLines.itemId.equals(itemId))
      ..orderBy([
        OrderingTerm(
          expression: purchaseInvoices.invoiceDate,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(
          expression: purchaseInvoices.id,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return DatedLine(
      row.readTable(invoiceLines),
      row.readTable(purchaseInvoices).invoiceDate,
    );
  }

  Future<PurchaseInvoice?> getLastInvoiceForSupplier(int supplierId) =>
      (select(purchaseInvoices)
            ..where((t) => t.supplierId.equals(supplierId))
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.invoiceDate,
                    mode: OrderingMode.desc,
                  ),
              (t) => OrderingTerm(
                    expression: t.id,
                    mode: OrderingMode.desc,
                  ),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<void> deleteInvoice(int id) =>
      (delete(purchaseInvoices)..where((t) => t.id.equals(id))).go();
}
