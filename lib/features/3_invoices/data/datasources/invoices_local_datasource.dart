import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/catalog_dao.dart';
import '../../../../core/database/daos/invoices_dao.dart';
import '../../../../core/database/daos/suppliers_dao.dart';
import '../../../../core/database/daos/vouchers_dao.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../domain/entities/invoice_line_entity.dart';
import '../../domain/entities/purchase_invoice_entity.dart';

class InvoicesLocalDataSource {
  InvoicesLocalDataSource(
    this._db,
    this._invoicesDao,
    this._catalogDao,
    this._suppliersDao,
    this._vouchersDao,
  );

  final AppDatabase _db;
  final InvoicesDao _invoicesDao;
  final CatalogDao _catalogDao;
  final SuppliersDao _suppliersDao;
  // ignore: unused_field
  final VouchersDao _vouchersDao;

  /// حفظ ذري للفاتورة وأسطرها وذاكرة الأسعار ورصيد المورد في معاملة واحدة.
  Future<int> saveInvoiceTransaction(PurchaseInvoiceEntity invoice) {
    return _db.transaction(() async {
      final invoiceId = await _invoicesDao.insertHeader(
        PurchaseInvoicesCompanion.insert(
          supplierId: invoice.supplierId,
          paperInvoiceNumber: invoice.paperInvoiceNumber,
          invoiceDate: invoice.invoiceDate,
          currency: Value(invoice.currency),
          paymentType: Value(invoice.paymentType),
          subtotal: Value(invoice.subtotal),
          discount: Value(invoice.discount),
          extraCharges: Value(invoice.extraCharges),
          netTotal: Value(invoice.netTotal),
          paidAmount: Value(invoice.paidAmount),
          remainingAmount: Value(invoice.remainingAmount),
          printedTotalQty: Value(invoice.printedTotalQty),
          printedPrevBalance: Value(invoice.printedPrevBalance),
          printedCurrBalance: Value(invoice.printedCurrBalance),
          imagePathsJson: Value(jsonEncode(invoice.imagePaths)),
          hasMathWarning: Value(invoice.hasMathWarning),
          status: Value(invoice.status),
          createdAt: Value(invoice.createdAt),
        ),
      );

      for (final line in invoice.lines) {
        final itemId = await _resolveItemId(invoice.supplierId, line);

        // جلب آخر سطر شراء سابق لهذا الصنف (إن وجد قبل هذه الفاتورة) لضمان حساب فرق السعر حتى في الإدخال اليدوي
        double? prevPrice = line.previousUnitPrice;
        double priceDiff = line.priceDiffAmount;
        if (prevPrice == null) {
          final lastDatedLine = await _invoicesDao.getLastLineForItem(itemId);
          if (lastDatedLine != null) {
            prevPrice = lastDatedLine.line.unitPrice;
            priceDiff = line.unitPrice - prevPrice;
          }
        }

        await _invoicesDao.insertLine(
          InvoiceLinesCompanion.insert(
            invoiceId: invoiceId,
            itemId: itemId,
            lineNumber: Value(line.lineNumber),
            supplierItemCode: Value(line.supplierItemCode),
            rawItemName: line.rawItemName,
            unitName: Value(line.unitName),
            quantity: Value(line.quantity),
            quantityWords: Value(line.quantityWords),
            freeQuantity: Value(line.freeQuantity),
            unitPrice: Value(line.unitPrice),
            lineTotal: Value(line.lineTotal),
            effectiveUnitCost: Value(line.effectiveUnitCost),
            singlePieceCost: Value(line.singlePieceCost),
            previousUnitPrice: Value(prevPrice),
            priceDiffAmount: Value(priceDiff),
            needsReview: Value(line.needsReview),
          ),
        );

        await _updateItemMemory(itemId, invoice.supplierId, line);
        await _catalogDao.upsertSupplierItem(
          SupplierItemsCompanion.insert(
            supplierId: invoice.supplierId,
            itemId: itemId,
            supplierItemCode: Value(line.supplierItemCode),
            rawOcrName: line.rawItemName,
            defaultUnitName: Value(line.unitName),
            lastUnitPrice: Value(line.unitPrice),
            lastPurchaseDate: Value(invoice.invoiceDate),
          ),
        );
      }

      // إعادة حساب الرصيد الدفتري للمورد من واقع الفواتير المعتمدة والسندات
      await _suppliersDao.recalculateAndSaveSupplierBalance(invoice.supplierId);

      // تحديث آخر رصيد مطبوع للمورد بشرط ألا تكون الفاتورة أقدم من آخر وثيقة مسجلة
      if (invoice.printedCurrBalance != null) {
        final supplier = await _suppliersDao.getSupplier(invoice.supplierId);
        final lastDocDate = supplier?.lastBalanceDocDate;
        if (lastDocDate == null || !invoice.invoiceDate.isBefore(lastDocDate)) {
          await _suppliersDao.updatePrintedBalance(
            invoice.supplierId,
            invoice.printedCurrBalance!,
            invoice.invoiceDate,
          );
        }
      }

      return invoiceId;
    });
  }

  Future<int> _resolveItemId(
    int supplierId,
    InvoiceLineEntity line,
  ) async {
    if (line.itemId > 0) {
      final existing = await _catalogDao.getItem(line.itemId);
      if (existing != null) return line.itemId;
    }

    final normalized = ArabicTextNormalizer.normalize(line.rawItemName);
    final byNorm = await _catalogDao.findByNormalizedName(normalized);
    if (byNorm != null) return byNorm.id;

    final packUnits = _derivePackUnits(line);
    try {
      return await _catalogDao.insertItem(
        ItemsCompanion.insert(
          canonicalName: line.rawItemName.trim(),
          normalizedName: normalized,
          defaultUnit: Value(line.unitName),
          packUnitsCount: Value(packUnits),
          suggestedRetailPrice: Value(line.extractedRetailPrice),
          lastPurchasePrice: Value(line.unitPrice),
          lowestPurchasePrice: Value(line.unitPrice),
          lowestSupplierId: Value(supplierId),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      final fallback = await _catalogDao.findByNormalizedName(normalized);
      if (fallback != null) return fallback.id;
      rethrow;
    }
  }

  int? _derivePackUnits(InvoiceLineEntity line) {
    if (line.extractedPackSize != null && line.extractedPackSize! > 0) {
      return line.extractedPackSize;
    }
    final single = line.singlePieceCost;
    if (single != null && single > 0 && line.effectiveUnitCost > 0) {
      final units = (line.effectiveUnitCost / single).round();
      return units > 0 ? units : null;
    }
    return null;
  }

  Future<void> _updateItemMemory(
    int itemId,
    int supplierId,
    InvoiceLineEntity line,
  ) async {
    final item = await _catalogDao.getItem(itemId);
    if (item == null) return;

    final newPrice = line.unitPrice;
    final currentLowest = item.lowestPurchasePrice;
    final isNewLowest =
        currentLowest == null || newPrice < currentLowest - 0.0001;

    final packUnits = _derivePackUnits(line) ?? item.packUnitsCount;
    final retail = line.extractedRetailPrice ?? item.suggestedRetailPrice;

    await _catalogDao.updateItemPrices(
      itemId,
      lastPurchasePrice: newPrice,
      lowestPurchasePrice: isNewLowest ? newPrice : currentLowest,
      lowestSupplierId: isNewLowest ? supplierId : item.lowestSupplierId,
      packUnitsCount: packUnits,
      suggestedRetailPrice: retail,
    );
  }

  Future<PurchaseInvoiceEntity?> getInvoiceDetails(int invoiceId) async {
    final result = await _invoicesDao.getInvoiceWithLines(invoiceId);
    if (result == null) return null;
    final inv = result.invoice;
    return PurchaseInvoiceEntity(
      id: inv.id,
      supplierId: inv.supplierId,
      paperInvoiceNumber: inv.paperInvoiceNumber,
      invoiceDate: inv.invoiceDate,
      currency: inv.currency,
      paymentType: inv.paymentType,
      subtotal: inv.subtotal,
      discount: inv.discount,
      extraCharges: inv.extraCharges,
      netTotal: inv.netTotal,
      paidAmount: inv.paidAmount,
      remainingAmount: inv.remainingAmount,
      printedTotalQty: inv.printedTotalQty,
      printedPrevBalance: inv.printedPrevBalance,
      printedCurrBalance: inv.printedCurrBalance,
      imagePaths: _decodePaths(inv.imagePathsJson),
      hasMathWarning: inv.hasMathWarning,
      status: inv.status,
      createdAt: inv.createdAt,
      lines: result.lines
          .map((l) => InvoiceLineEntity(
                id: l.id,
                invoiceId: l.invoiceId,
                itemId: l.itemId,
                lineNumber: l.lineNumber,
                supplierItemCode: l.supplierItemCode,
                rawItemName: l.rawItemName,
                unitName: l.unitName,
                quantity: l.quantity,
                quantityWords: l.quantityWords,
                freeQuantity: l.freeQuantity,
                unitPrice: l.unitPrice,
                lineTotal: l.lineTotal,
                effectiveUnitCost: l.effectiveUnitCost,
                singlePieceCost: l.singlePieceCost,
                previousUnitPrice: l.previousUnitPrice,
                priceDiffAmount: l.priceDiffAmount,
                needsReview: l.needsReview,
              ))
          .toList(),
    );
  }

  Future<List<PurchaseInvoiceEntity>> getInvoicesBySupplier(
    int supplierId,
  ) async {
    final invoices = await _invoicesDao.getInvoicesBySupplier(supplierId);
    return invoices.map(_mapHeader).toList();
  }

  Future<List<PurchaseInvoiceEntity>> getRecentInvoices({int limit = 20}) async {
    final invoices = await _invoicesDao.getRecentInvoices(limit: limit);
    return invoices.map(_mapHeader).toList();
  }

  Stream<List<PurchaseInvoiceEntity>> watchRecentInvoices({int limit = 20}) =>
      _invoicesDao
          .watchRecentInvoices(limit: limit)
          .map((list) => list.map(_mapHeader).toList());

  Stream<List<PurchaseInvoiceEntity>> watchInvoicesBySupplier(
    int supplierId,
  ) =>
      _invoicesDao
          .watchInvoicesBySupplier(supplierId)
          .map((list) => list.map(_mapHeader).toList());

  PurchaseInvoiceEntity _mapHeader(PurchaseInvoice invoice) =>
      PurchaseInvoiceEntity(
        id: invoice.id,
        supplierId: invoice.supplierId,
        paperInvoiceNumber: invoice.paperInvoiceNumber,
        invoiceDate: invoice.invoiceDate,
        currency: invoice.currency,
        paymentType: invoice.paymentType,
        subtotal: invoice.subtotal,
        discount: invoice.discount,
        extraCharges: invoice.extraCharges,
        netTotal: invoice.netTotal,
        paidAmount: invoice.paidAmount,
        remainingAmount: invoice.remainingAmount,
        printedTotalQty: invoice.printedTotalQty,
        printedPrevBalance: invoice.printedPrevBalance,
        printedCurrBalance: invoice.printedCurrBalance,
        imagePaths: _decodePaths(invoice.imagePathsJson),
        hasMathWarning: invoice.hasMathWarning,
        status: invoice.status,
        createdAt: invoice.createdAt,
      );

  List<String> _decodePaths(String json) {
    try {
      return (jsonDecode(json) as List).map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  /// حذف الفاتورة وإعادة حساب الرصيد الدفتري للمورد فوراً داخل معاملة ذرية.
  Future<void> deleteInvoice(int id) {
    return _db.transaction(() async {
      final existing = await _invoicesDao.getInvoice(id);
      await _invoicesDao.deleteInvoice(id);
      if (existing != null) {
        await _suppliersDao.recalculateAndSaveSupplierBalance(
          existing.supplierId,
        );
      }
    });
  }
}
