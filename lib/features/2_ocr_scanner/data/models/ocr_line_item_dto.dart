import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/extracted_document_entity.dart';

/// تحويل سطر JSON القادم من Gemini إلى كيان، مع معالجة الأرقام العربية والقيم الصفرية الاختيارية.
class OcrLineItemDto {
  const OcrLineItemDto({
    required this.lineNo,
    required this.rawName,
    required this.cleanItemName,
    required this.unit,
    required this.qtyNum,
    required this.unitPrice,
    required this.lineTotal,
    this.supplierItemCode,
    this.qtyWords,
    this.freeQty = 0.0,
    this.extractedPackSize,
    this.extractedRetailPrice,
    this.mathVerified = true,
    this.confidenceScore = 1.0,
  });

  final int lineNo;
  final String? supplierItemCode;
  final String rawName;
  final String cleanItemName;
  final String unit;
  final double qtyNum;
  final String? qtyWords;
  final double freeQty;
  final double unitPrice;
  final double lineTotal;
  final int? extractedPackSize;
  final double? extractedRetailPrice;
  final bool mathVerified;
  final double confidenceScore;

  factory OcrLineItemDto.fromJson(Map<String, dynamic> json) {
    final rawName = _str(json['raw_name']) ?? '';
    final cleanName = _str(json['clean_item_name']) ?? rawName;
    final packSize = _positiveIntOrNull(json['extracted_pack_size']);
    final retailPrice = _positiveDoubleOrNull(json['extracted_retail_price']);

    return OcrLineItemDto(
      lineNo: _positiveIntOrNull(json['line_no']) ?? 1,
      supplierItemCode: _str(json['supplier_item_code']),
      rawName: rawName,
      cleanItemName: cleanName.isEmpty ? rawName : cleanName,
      unit: _str(json['unit']) ?? 'كرتون',
      qtyNum: _double(json['qty_num']) ?? 0.0,
      qtyWords: _str(json['qty_words']),
      freeQty: _double(json['free_qty']) ?? 0.0,
      unitPrice: _double(json['unit_price']) ?? 0.0,
      lineTotal: _double(json['line_total']) ?? 0.0,
      extractedPackSize: packSize,
      extractedRetailPrice: retailPrice,
      mathVerified: json['math_verified'] as bool? ?? true,
      confidenceScore: _double(json['confidence_score']) ?? 1.0,
    );
  }

  ExtractedLineItem toEntity() => ExtractedLineItem(
        lineNo: lineNo,
        supplierItemCode: supplierItemCode,
        rawName: rawName,
        cleanItemName: cleanItemName,
        unit: unit,
        qtyNum: qtyNum,
        qtyWords: qtyWords,
        freeQty: freeQty,
        unitPrice: unitPrice,
        lineTotal: lineTotal,
        extractedPackSize: extractedPackSize,
        extractedRetailPrice: extractedRetailPrice,
        mathVerified: mathVerified,
        confidenceScore: confidenceScore,
      );

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

  /// يتجاهل القيمة 0 التي يرجعها النموذج عندما لا تتوفر سعة عبوة في النص.
  static int? _positiveIntOrNull(dynamic v) {
    final d = _double(v);
    if (d == null || d <= 0) return null;
    return d.round();
  }

  /// يتجاهل القيمة 0.0 التي يرجعها النموذج عندما لا يتوفر سعر بيع مقترح في النص.
  static double? _positiveDoubleOrNull(dynamic v) {
    final d = _double(v);
    if (d == null || d <= 0) return null;
    return d;
  }
}
