import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/extracted_document_entity.dart';
import 'ocr_line_item_dto.dart';

/// تحويل JSON القادم من Gemini إلى كيان الوثيقة مع دعم تواريخ الفواتير العربية DD/MM/YYYY.
class OcrDocumentDto {
  const OcrDocumentDto({
    required this.docType,
    required this.paperNumber,
    required this.date,
    required this.currency,
    required this.paymentStatus,
    required this.supplier,
    required this.lineItems,
    required this.financial,
    this.voucherDetails,
  });

  final DocType docType;
  final String paperNumber;
  final DateTime date;
  final String currency;
  final PaymentStatus paymentStatus;
  final SupplierInfo supplier;
  final List<OcrLineItemDto> lineItems;
  final VoucherDetails? voucherDetails;
  final FinancialSummary financial;

  factory OcrDocumentDto.fromJson(Map<String, dynamic> json) {
    final supplierJson =
        (json['supplier_info'] as Map?)?.cast<String, dynamic>() ?? {};
    final financialJson =
        (json['financial_summary'] as Map?)?.cast<String, dynamic>() ?? {};
    final voucherJson = json['voucher_details'] as Map?;
    final linesJson = (json['line_items'] as List?) ?? [];

    return OcrDocumentDto(
      docType: _parseDocType(json['doc_type']),
      paperNumber: _str(json['paper_number']) ?? '',
      date: _parseDate(json['date']),
      currency: _str(json['currency']) ?? 'YER',
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      supplier: SupplierInfo(
        name: _str(supplierJson['supplier_name']) ?? 'مورد غير معروف',
        branchName: _str(supplierJson['branch_name']),
        phones: ((supplierJson['phones'] as List?) ?? [])
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
            .toList(),
        analyticCode: _str(supplierJson['customer_analytic_code']),
      ),
      lineItems: linesJson
          .whereType<Map>()
          .map((e) => OcrLineItemDto.fromJson(e.cast<String, dynamic>()))
          .toList(),
      voucherDetails: voucherJson == null
          ? null
          : VoucherDetails(
              amount: _double(voucherJson['amount']) ?? 0.0,
              amountWords: _str(voucherJson['amount_words']),
              statementNote: _str(voucherJson['statement_note']),
            ),
      financial: FinancialSummary(
        // إذا أرجع النموذج 0 لعدد القطع، نعتبره غير مطبوع في الفاتورة (null) لمنع الإنذارات الكاذبة
        totalPiecesCount:
            _positiveDoubleOrNull(financialJson['total_pieces_count']),
        subtotal: _double(financialJson['subtotal']) ?? 0.0,
        discount: _double(financialJson['discount']) ?? 0.0,
        extraCharges: _double(financialJson['extra_charges']) ?? 0.0,
        netTotal: _double(financialJson['net_total']) ?? 0.0,
        printedPreviousBalance:
            _nullableBalance(financialJson['printed_previous_balance']),
        printedCurrentBalance:
            _nullableBalance(financialJson['printed_current_balance']),
      ),
    );
  }

  ExtractedDocument toEntity({List<String> imagePaths = const []}) =>
      ExtractedDocument(
        docType: docType,
        paperNumber: paperNumber,
        date: date,
        currency: currency,
        paymentStatus: paymentStatus,
        supplier: supplier,
        lineItems: lineItems.map((e) => e.toEntity()).toList(),
        voucherDetails: voucherDetails,
        financial: financial,
        imagePaths: imagePaths,
      );

  static DocType _parseDocType(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    if (s.contains('receipt') ||
        s.contains('voucher') ||
        s.contains('سند') ||
        s.contains('قبض')) {
      return DocType.receiptVoucher;
    }
    return DocType.purchaseInvoice;
  }

  static PaymentStatus _parsePaymentStatus(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    if (s.contains('cash') || s.contains('نقد')) return PaymentStatus.cash;
    if (s.contains('partial') || s.contains('جزئ')) {
      return PaymentStatus.partial;
    }
    return PaymentStatus.credit;
  }

  static DateTime _parseDate(dynamic v) {
    final raw = _str(v);
    return DateFormatter.tryParse(raw) ?? DateTime.now();
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;
    return s;
  }

  static double? _double(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;
    return CurrencyFormatter.parse(s);
  }

  static double? _positiveDoubleOrNull(dynamic v) {
    final d = _double(v);
    if (d == null || d <= 0) return null;
    return d;
  }

  static double? _nullableBalance(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;
    return _double(v);
  }
}
