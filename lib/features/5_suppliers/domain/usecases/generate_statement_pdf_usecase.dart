import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../entities/balance_reconciliation_entity.dart';
import '../entities/supplier_entity.dart';
import '../entities/supplier_ledger_entry_entity.dart';

/// توليد كشف حساب المورد بصيغة PDF عربية (RTL) ومشاركته عبر واتساب.
class GenerateStatementPdfUseCase {
  const GenerateStatementPdfUseCase();

  static const String _fontAsset = 'assets/fonts/Cairo-Regular.ttf';
  static const String _boldFontAsset = 'assets/fonts/Cairo-Bold.ttf';

  Future<pw.Font> _loadRegularFont() async {
    try {
      return pw.Font.ttf(await rootBundle.load(_fontAsset));
    } catch (_) {
      return PdfGoogleFonts.cairoRegular();
    }
  }

  Future<pw.Font> _loadBoldFont(pw.Font fallback) async {
    try {
      return pw.Font.ttf(await rootBundle.load(_boldFontAsset));
    } catch (_) {
      try {
        return await PdfGoogleFonts.cairoBold();
      } catch (_) {
        return fallback;
      }
    }
  }

  Future<Uint8List> buildPdf({
    required SupplierEntity supplier,
    required List<SupplierLedgerEntryEntity> entries,
    required BalanceReconciliationEntity reconciliation,
  }) async {
    final regular = await _loadRegularFont();
    final bold = await _loadBoldFont(regular);

    final theme = pw.ThemeData.withFont(base: regular, bold: bold);
    final dateFormat = DateFormat('yyyy-MM-dd');

    // في مكتبة pdf، الأعمدة في TableHelper.fromTextArray تُرسم من اليسار (0) إلى اليمين (الأخير).
    // لذلك نعكس ترتيب الأعمدة ليكون العمود الأيمن هو "التاريخ" والعمود الأيسر هو "الرصيد التراكمي".
    final headers = <String>[
      'الرصيد التراكمي',
      'دائن (سداد)',
      'مدين (فواتير)',
      'البيان',
      'رقم الوثيقة',
      'النوع',
      'التاريخ',
    ];

    final dataRows = <List<String>>[
      for (final e in entries)
        [
          CurrencyFormatter.formatNumber(e.runningBalance),
          e.credit == 0 ? '—' : CurrencyFormatter.formatNumber(e.credit),
          e.debit == 0 ? '—' : CurrencyFormatter.formatNumber(e.debit),
          e.description,
          e.referenceNumber,
          _typeLabel(e.type),
          dateFormat.format(e.date),
        ],
    ];

    final totalDebit = entries
        .where((e) => e.type == LedgerEntryType.invoice)
        .fold<double>(0.0, (s, e) => s + e.debit);
    final totalCredit = entries
        .where((e) => e.type == LedgerEntryType.voucher)
        .fold<double>(0.0, (s, e) => s + e.credit);

    final doc = pw.Document(theme: theme);
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(24),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'كشف حساب المورد التفصيلي',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'تاريخ الإصدار: ${dateFormat.format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'المشتري (صاحب المحل): ${AppStrings.ownerName}',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.Text(
                'المورد: ${supplier.name}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (supplier.branchName != null &&
                  supplier.branchName!.trim().isNotEmpty)
                pw.Text(
                  'الفرع: ${supplier.branchName}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              if (supplier.analyticAccountNo != null &&
                  supplier.analyticAccountNo!.trim().isNotEmpty)
                pw.Text(
                  'الرقم التحليلي لدى المورد: ${supplier.analyticAccountNo}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              pw.Divider(),
            ],
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: dataRows,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellAlignment: pw.Alignment.centerRight,
            headerAlignment: pw.Alignment.centerRight,
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey500),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ملخص الحركة والمطابقة المالية:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'الرصيد الافتتاحي: ${CurrencyFormatter.formatNumber(supplier.openingBalance)} ${supplier.currency}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'إجمالي الفواتير الآجلة والجزئية (مدين): ${CurrencyFormatter.formatNumber(totalDebit)} ${supplier.currency}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'إجمالي سندات السداد (دائن): ${CurrencyFormatter.formatNumber(totalCredit)} ${supplier.currency}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Divider(),
                pw.Text(
                  'الرصيد الدفتري المحسوب حالياً: '
                  '${CurrencyFormatter.formatNumber(reconciliation.calculatedBalance)} ${supplier.currency}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                if (reconciliation.hasPrintedBalance)
                  pw.Text(
                    'آخر رصيد مطبوع في وثائق المورد: '
                    '${CurrencyFormatter.formatNumber(reconciliation.printedBalance!)} ${supplier.currency}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                pw.Text(
                  reconciliation.isMatched
                      ? 'حالة المطابقة: متطابق تماماً'
                      : 'حالة المطابقة: يوجد فرق رصيد بمقدار '
                          '${CurrencyFormatter.formatNumber(reconciliation.difference)} ${supplier.currency}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: reconciliation.isMatched
                        ? PdfColors.green700
                        : PdfColors.red700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  /// مشاركة PDF عبر نظام المشاركة (يمكن اختيار واتساب).
  Future<void> sharePdf({
    required Uint8List bytes,
    required String supplierName,
  }) async {
    final safeName = supplierName
        .trim()
        .replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), '_');
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'كشف_حساب_$safeName.pdf',
    );
  }

  String _typeLabel(LedgerEntryType type) {
    switch (type) {
      case LedgerEntryType.invoice:
        return 'فاتورة مشتريات';
      case LedgerEntryType.voucher:
        return 'سند سداد';
      case LedgerEntryType.opening:
        return 'رصيد افتتاحي';
    }
  }
}
