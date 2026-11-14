import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/catalog_dao.dart';
import '../../../../core/database/daos/invoices_dao.dart';
import '../../../../core/database/daos/suppliers_dao.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// مصدر بيانات لوحة التحكم: يدمج عدّة تدفّقات حيّة في ملخّص واحد ويدعم البحث الفوري الشامل.
class DashboardLocalDataSource {
  DashboardLocalDataSource(
    this._db,
    this._suppliersDao,
    this._invoicesDao,
    this._catalogDao,
  );

  final AppDatabase _db;
  final SuppliersDao _suppliersDao;
  final InvoicesDao _invoicesDao;
  final CatalogDao _catalogDao;

  Stream<DashboardSummary> watchSummary() {
    return _combine<DashboardSummary>(
      [
        _suppliersDao.watchAllSuppliers(),
        _invoicesDao.watchRecentInvoices(limit: 10),
        _watchPriceChanges(),
        _watchMonthPurchases(),
        _watchMonthPayments(),
      ],
      (values) {
        final suppliers = values[0] as List<Supplier>;
        final recent = values[1] as List<PurchaseInvoice>;
        final alerts = values[2] as List<PriceChangeAlert>;
        final monthPurchases = values[3] as double;
        final monthPayments = values[4] as double;

        final nameById = {for (final s in suppliers) s.id: s.name};
        final totalDebt = suppliers.fold<double>(
          0,
          (acc, s) => acc + s.currentCalculatedBalance,
        );
        final mismatched = suppliers.where((s) {
          final printed = s.lastPrintedSupplierBalance;
          if (printed == null) return false;
          return (s.currentCalculatedBalance - printed).abs() > 0.01;
        }).length;

        final recentSummaries = recent
            .map(
              (inv) => RecentInvoiceSummary(
                invoiceId: inv.id,
                supplierId: inv.supplierId,
                supplierName: nameById[inv.supplierId] ?? 'مورد',
                paperInvoiceNumber: inv.paperInvoiceNumber,
                invoiceDate: inv.invoiceDate,
                netTotal: inv.netTotal,
                paymentType: inv.paymentType,
                hasMathWarning: inv.hasMathWarning,
              ),
            )
            .toList();

        return DashboardSummary(
          totalDebt: totalDebt,
          supplierCount: suppliers.length,
          mismatchedSupplierCount: mismatched,
          recentPriceChanges: alerts,
          recentInvoices: recentSummaries,
          monthPurchases: monthPurchases,
          monthPayments: monthPayments,
        );
      },
    );
  }

  /// بحث فوري شامل في (الموردين + الأصناف بالتطبيع العربي + أرقام الفواتير الورقية).
  Future<GlobalSearchResults> instantSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      return const GlobalSearchResults(
        suppliers: [],
        items: [],
        invoices: [],
      );
    }

    final normalizedQuery = ArabicTextNormalizer.normalize(q);

    // 1. البحث في الموردين (الاسم، الفرع، أو الرقم التحليلي)
    final allSuppliers = await _suppliersDao.getAllSuppliers();
    final matchedSuppliers = allSuppliers.where((s) {
      final normName = ArabicTextNormalizer.normalize(s.name);
      final normBranch = ArabicTextNormalizer.normalize(s.branchName ?? '');
      final code = (s.analyticAccountNo ?? '').toLowerCase();
      return normName.contains(normalizedQuery) ||
          normBranch.contains(normalizedQuery) ||
          s.name.contains(q) ||
          code.contains(q.toLowerCase());
    }).toList();

    // 2. البحث في الأصناف بالاسم القياسي أو المطبع
    final items = await _catalogDao.search(
      normalizedQuery.isNotEmpty ? normalizedQuery : q,
    );

    // 3. البحث في الفواتير برقم الفاتورة الورقية
    final invoiceQuery = _db.select(_db.purchaseInvoices).join([
      innerJoin(
        _db.suppliers,
        _db.suppliers.id.equalsExp(_db.purchaseInvoices.supplierId),
      ),
    ])
      ..where(_db.purchaseInvoices.paperInvoiceNumber.like('%$q%'))
      ..orderBy([
        OrderingTerm(
          expression: _db.purchaseInvoices.invoiceDate,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(15);

    final invoiceRows = await invoiceQuery.get();

    return GlobalSearchResults(
      suppliers: matchedSuppliers
          .map(
            (s) => GlobalSearchHit(
              id: s.id,
              title: s.name,
              subtitle: s.analyticAccountNo != null
                  ? 'حساب تحليلي: ${s.analyticAccountNo} • الرصيد: ${CurrencyFormatter.formatNumber(s.currentCalculatedBalance)}'
                  : 'الرصيد: ${CurrencyFormatter.formatNumber(s.currentCalculatedBalance)}',
            ),
          )
          .toList(),
      items: items
          .map(
            (i) => GlobalSearchHit(
              id: i.id,
              title: i.canonicalName,
              subtitle: i.lastPurchasePrice != null
                  ? '${i.defaultUnit} • آخر سعر: ${CurrencyFormatter.formatNumber(i.lastPurchasePrice!)}'
                  : i.defaultUnit,
            ),
          )
          .toList(),
      invoices: invoiceRows.map((row) {
        final inv = row.readTable(_db.purchaseInvoices);
        final sup = row.readTable(_db.suppliers);
        return GlobalSearchHit(
          id: inv.id,
          title: 'فاتورة رقم #${inv.paperInvoiceNumber} — ${sup.name}',
          subtitle:
              'الصافي: ${CurrencyFormatter.formatNumber(inv.netTotal)} ريال',
        );
      }).toList(),
    );
  }

  Stream<List<PriceChangeAlert>> _watchPriceChanges() {
    final query = _db.select(_db.invoiceLines).join([
      innerJoin(
        _db.purchaseInvoices,
        _db.purchaseInvoices.id.equalsExp(_db.invoiceLines.invoiceId),
      ),
      innerJoin(_db.items, _db.items.id.equalsExp(_db.invoiceLines.itemId)),
      innerJoin(
        _db.suppliers,
        _db.suppliers.id.equalsExp(_db.purchaseInvoices.supplierId),
      ),
    ])
      ..where(_db.invoiceLines.priceDiffAmount.isNotValue(0))
      ..orderBy([
        OrderingTerm(
          expression: _db.purchaseInvoices.invoiceDate,
          mode: OrderingMode.desc,
        ),
        OrderingTerm(
          expression: _db.purchaseInvoices.id,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(10);

    return query.watch().map((rows) {
      return rows.map((r) {
        final line = r.readTable(_db.invoiceLines);
        final inv = r.readTable(_db.purchaseInvoices);
        final item = r.readTable(_db.items);
        final sup = r.readTable(_db.suppliers);
        return PriceChangeAlert(
          itemId: item.id,
          itemName: item.canonicalName,
          supplierId: sup.id,
          supplierName: sup.name,
          previousPrice: line.previousUnitPrice ?? line.unitPrice,
          currentPrice: line.unitPrice,
          changeDate: inv.invoiceDate,
        );
      }).toList();
    });
  }

  Stream<double> _watchMonthPurchases() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return _db
        .customSelect(
          "SELECT COALESCE(SUM(net_total), 0.0) AS total "
          "FROM purchase_invoices WHERE invoice_date >= ? AND status = 'confirmed'",
          variables: [Variable.withDateTime(start)],
          readsFrom: {_db.purchaseInvoices},
        )
        .watchSingle()
        .map((row) => (row.read<num?>('total') ?? 0.0).toDouble());
  }

  Stream<double> _watchMonthPayments() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return _db
        .customSelect(
          'SELECT COALESCE(SUM(amount), 0.0) AS total '
          'FROM payment_vouchers WHERE voucher_date >= ?',
          variables: [Variable.withDateTime(start)],
          readsFrom: {_db.paymentVouchers},
        )
        .watchSingle()
        .map((row) => (row.read<num?>('total') ?? 0.0).toDouble());
  }

  /// يدمج عدّة تدفّقات ويصدر قيمة مركّبة بعد توفّر أول قيمة من كل تدفّق مع تمرير الأخطاء بأمان.
  Stream<T> _combine<T>(
    List<Stream<dynamic>> streams,
    T Function(List<dynamic> values) build,
  ) {
    late StreamController<T> controller;
    final latest = List<dynamic>.filled(streams.length, null);
    final ready = List<bool>.filled(streams.length, false);
    final subs = <StreamSubscription<dynamic>>[];

    controller = StreamController<T>(
      onListen: () {
        for (var i = 0; i < streams.length; i++) {
          final idx = i;
          subs.add(
            streams[i].listen(
              (data) {
                latest[idx] = data;
                ready[idx] = true;
                if (ready.every((r) => r) && !controller.isClosed) {
                  controller.add(build(List<dynamic>.from(latest)));
                }
              },
              onError: (Object error, StackTrace stackTrace) {
                if (!controller.isClosed) {
                  controller.addError(error, stackTrace);
                }
              },
            ),
          );
        }
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
      },
    );
    return controller.stream;
  }
}
