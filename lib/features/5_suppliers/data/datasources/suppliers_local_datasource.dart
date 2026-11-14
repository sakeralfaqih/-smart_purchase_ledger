import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/invoices_dao.dart';
import '../../../../core/database/daos/suppliers_dao.dart';
import '../../../../core/database/daos/vouchers_dao.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/balance_reconciliation_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/entities/supplier_ledger_entry_entity.dart';

class SuppliersLocalDataSource {
  SuppliersLocalDataSource(
    this._suppliersDao,
    this._invoicesDao,
    this._vouchersDao,
  );

  final SuppliersDao _suppliersDao;
  final InvoicesDao _invoicesDao;
  final VouchersDao _vouchersDao;

  Stream<List<SupplierEntity>> watchAll() =>
      _suppliersDao.watchAllSuppliers().map((l) => l.map(_map).toList());

  Future<List<SupplierEntity>> getAll() async {
    final list = await _suppliersDao.getAllSuppliers();
    return list.map(_map).toList();
  }

  Future<SupplierEntity?> get(int id) async {
    final s = await _suppliersDao.getSupplier(id);
    return s == null ? null : _map(s);
  }

  Stream<SupplierEntity?> watch(int id) =>
      _suppliersDao.watchSupplier(id).map((s) => s == null ? null : _map(s));

  Future<int> create(SupplierEntity supplier) async {
    final initialCalculated = supplier.currentCalculatedBalance != 0.0
        ? supplier.currentCalculatedBalance
        : supplier.openingBalance;

    final id = await _suppliersDao.insertSupplier(
      SuppliersCompanion.insert(
        name: supplier.name.trim(),
        branchName: Value(supplier.branchName),
        analyticAccountNo: Value(supplier.analyticAccountNo),
        phonesJson: Value(jsonEncode(supplier.phones)),
        ocrAliasesJson: Value(jsonEncode(supplier.ocrAliases)),
        currency: Value(supplier.currency),
        openingBalance: Value(supplier.openingBalance),
        currentCalculatedBalance: Value(initialCalculated),
        lastPrintedSupplierBalance: Value(supplier.lastPrintedSupplierBalance),
        lastBalanceDocDate: Value(supplier.lastBalanceDocDate),
        notes: Value(supplier.notes),
        createdAt: Value(supplier.createdAt),
      ),
    );
    await _suppliersDao.recalculateAndSaveSupplierBalance(id);
    return id;
  }

  Future<void> update(SupplierEntity supplier) async {
    if (supplier.id == null) return;
    await _suppliersDao.updateSupplier(
      SuppliersCompanion(
        id: Value(supplier.id!),
        name: Value(supplier.name.trim()),
        branchName: Value(supplier.branchName),
        analyticAccountNo: Value(supplier.analyticAccountNo),
        phonesJson: Value(jsonEncode(supplier.phones)),
        ocrAliasesJson: Value(jsonEncode(supplier.ocrAliases)),
        currency: Value(supplier.currency),
        openingBalance: Value(supplier.openingBalance),
        currentCalculatedBalance: Value(supplier.currentCalculatedBalance),
        lastPrintedSupplierBalance: Value(supplier.lastPrintedSupplierBalance),
        lastBalanceDocDate: Value(supplier.lastBalanceDocDate),
        notes: Value(supplier.notes),
        createdAt: Value(supplier.createdAt),
      ),
    );
    // إعادة حساب الرصيد الدفتري فوراً في حال تم تعديل الرصيد الافتتاحي
    await _suppliersDao.recalculateAndSaveSupplierBalance(supplier.id!);
  }

  Stream<double> watchTotalDebt() => _suppliersDao.watchTotalDebt();

  Stream<List<SupplierEntity>> watchMismatched() =>
      _suppliersDao.watchMismatchedSuppliers().map((l) => l.map(_map).toList());

  Future<List<SupplierLedgerEntryEntity>> getStatement(int supplierId) async {
    final supplier = await _suppliersDao.getSupplier(supplierId);
    if (supplier == null) return [];

    final allInvoices = await _invoicesDao.getInvoicesBySupplier(supplierId);
    final confirmedInvoices =
        allInvoices.where((inv) => inv.status == 'confirmed').toList();
    final vouchers = await _vouchersDao.getVouchersBySupplier(supplierId);

    final entries = <SupplierLedgerEntryEntity>[];
    var running = supplier.openingBalance;

    entries.add(
      SupplierLedgerEntryEntity(
        date: supplier.createdAt,
        type: LedgerEntryType.opening,
        referenceNumber: '—',
        description: 'الرصيد الافتتاحي',
        debit: supplier.openingBalance,
        credit: 0.0,
        runningBalance: running,
      ),
    );

    // دمج الحركات وترتيبها زمنياً (وفي حال تساوي التاريخ، الفاتورة تسبق سند السداد).
    final movements = <_Movement>[
      for (final inv in confirmedInvoices)
        _Movement(
          date: inv.invoiceDate,
          debit: inv.remainingAmount,
          credit: 0.0,
          type: LedgerEntryType.invoice,
          reference: inv.paperInvoiceNumber,
          description: _invoiceDescription(inv),
          documentId: inv.id,
          imagePath: _firstImage(inv.imagePathsJson),
        ),
      for (final v in vouchers)
        _Movement(
          date: v.voucherDate,
          debit: 0.0,
          credit: v.amount,
          type: LedgerEntryType.voucher,
          reference: v.paperVoucherNumber,
          description: (v.statementNote != null &&
                  v.statementNote!.trim().isNotEmpty)
              ? v.statementNote!
              : 'سندقبض / سداد دفعة',
          documentId: v.id,
          imagePath: v.imagePath,
        ),
    ]..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        if (a.type != b.type) {
          return a.type == LedgerEntryType.invoice ? -1 : 1;
        }
        return (a.documentId ?? 0).compareTo(b.documentId ?? 0);
      });

    for (final m in movements) {
      running += m.debit - m.credit;
      entries.add(
        SupplierLedgerEntryEntity(
          date: m.date,
          type: m.type,
          referenceNumber: m.reference,
          description: m.description,
          debit: m.debit,
          credit: m.credit,
          runningBalance: running,
          documentId: m.documentId,
          imagePath: m.imagePath,
        ),
      );
    }

    return entries;
  }

  String _invoiceDescription(PurchaseInvoice inv) {
    switch (inv.paymentType) {
      case 'cash':
        return 'فاتورة مشتريات (نقداً - مسددة بالكامل)';
      case 'partial':
        return 'فاتورة مشتريات (جزئي - الصافي: ${CurrencyFormatter.formatNumber(inv.netTotal)}، المدفوع: ${CurrencyFormatter.formatNumber(inv.paidAmount)})';
      case 'credit':
      default:
        return 'فاتورة مشتريات (آجل)';
    }
  }

  Future<BalanceReconciliationEntity> reconcile(int supplierId) async {
    final supplier = await _suppliersDao.getSupplier(supplierId);
    if (supplier == null) {
      return BalanceReconciliationEntity(
        supplierId: supplierId,
        supplierName: 'غير معروف',
        calculatedBalance: 0.0,
      );
    }
    return BalanceReconciliationEntity(
      supplierId: supplierId,
      supplierName: supplier.name,
      calculatedBalance: supplier.currentCalculatedBalance,
      printedBalance: supplier.lastPrintedSupplierBalance,
      printedDocDate: supplier.lastBalanceDocDate,
    );
  }

  String? _firstImage(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list.isEmpty ? null : list.first.toString();
    } catch (_) {
      return null;
    }
  }

  SupplierEntity _map(Supplier s) => SupplierEntity(
        id: s.id,
        name: s.name,
        branchName: s.branchName,
        analyticAccountNo: s.analyticAccountNo,
        phones: _decodeList(s.phonesJson),
        ocrAliases: _decodeList(s.ocrAliasesJson),
        currency: s.currency,
        openingBalance: s.openingBalance,
        currentCalculatedBalance: s.currentCalculatedBalance,
        lastPrintedSupplierBalance: s.lastPrintedSupplierBalance,
        lastBalanceDocDate: s.lastBalanceDocDate,
        notes: s.notes,
        createdAt: s.createdAt,
      );

  List<String> _decodeList(String json) {
    try {
      return (jsonDecode(json) as List).map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}

class _Movement {
  _Movement({
    required this.date,
    required this.debit,
    required this.credit,
    required this.type,
    required this.reference,
    required this.description,
    this.documentId,
    this.imagePath,
  });
  final DateTime date;
  final double debit;
  final double credit;
  final LedgerEntryType type;
  final String reference;
  final String description;
  final int? documentId;
  final String? imagePath;
}
