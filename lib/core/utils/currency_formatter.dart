import 'package:intl/intl.dart';

/// تنسيق وتحليل المبالغ والكسور العشرية (مثل 1,527,388.87 YER) مع دعم الأرقام العربية.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _decimal = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compact = NumberFormat('#,##0', 'en_US');

  /// تنسيق كامل مع كسرين عشريين.
  static String format(num value, {String currency = 'YER'}) {
    final text = _decimal.format(value);
    return '$text $currency';
  }

  /// تنسيق بدون رمز العملة.
  static String formatNumber(num value) => _decimal.format(value);

  /// تنسيق مختصر بدون كسور.
  static String formatCompact(num value) => _compact.format(value);

  /// تنسيق مع رمز العملة العربي.
  static String formatYer(num value) => '${_decimal.format(value)} ريال';

  /// تحويل نص (قد يحتوي أرقاماً عربية أو فواصل آلاف أو رموز عملة) إلى رقم عشري دقيق.
  static double parse(String? text) {
    if (text == null || text.trim().isEmpty) return 0.0;
    var normalized = text.trim();

    // 1. تحويل الأرقام العربية/الهندية إلى أرقام لاتينية قبل التنظيف
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], '$i');
    }

    // 2. توحيد الفاصلة العشرية العربية وإشارة السالب قبل تطبيق RegExp
    normalized = normalized
        .replaceAll('٫', '.')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll(',', '')
        .replaceAll('٬', '');

    // 3. إزالة أي حروف أو رموز عملة متبقية
    final cleaned = normalized.replaceAll(RegExp(r'[^0-9\.\-]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// تنسيق فرق السعر مع إشارة (+ أو -).
  static String formatSigned(num value) {
    final prefix = value > 0 ? '+' : '';
    return '$prefix${_decimal.format(value)}';
  }
}
