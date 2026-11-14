import 'package:intl/intl.dart';

/// تنسيق وتحليل التواريخ (يدعم صيغ ISO وصيغ الفواتير العربية DD/MM/YYYY والأرقام الهندية).
class DateFormatter {
  DateFormatter._();

  static final DateFormat _iso = DateFormat('yyyy-MM-dd', 'en_US');
  static final DateFormat _display = DateFormat('yyyy-MM-dd', 'en_US');
  static final DateFormat _dateTime = DateFormat('yyyy-MM-dd HH:mm', 'en_US');
  static final DateFormat _monthYear = DateFormat('yyyy-MM', 'en_US');

  static String toIso(DateTime date) => _iso.format(date);

  static String display(DateTime date) => _display.format(date);

  static String displayDateTime(DateTime date) => _dateTime.format(date);

  static String monthYear(DateTime date) => _monthYear.format(date);

  /// يحول النص إلى تاريخ مع دعم الأرقام العربية (٢٠/٠٩/٢٠٢٦) وصيغ DD/MM/YYYY و YYYY-MM-DD.
  static DateTime? tryParse(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    var cleaned = _normalizeDigits(text.trim());

    // 1. محاولة التحليل القياسي (YYYY-MM-DD)
    final direct = DateTime.tryParse(cleaned);
    if (direct != null) return direct;

    // 2. دعم صيغ الفواتير الورقية الشائعة: DD/MM/YYYY أو DD-MM-YYYY أو YYYY/MM/DD
    final parts = cleaned.split(RegExp(r'[/\-\.]'));
    if (parts.length == 3) {
      final p0 = int.tryParse(parts[0].trim());
      final p1 = int.tryParse(parts[1].trim());
      final p2 = int.tryParse(parts[2].trim());

      if (p0 != null && p1 != null && p2 != null) {
        // إذا كان الجزء الأول هو السنة (YYYY/MM/DD)
        if (p0 > 1900 && p1 >= 1 && p1 <= 12 && p2 >= 1 && p2 <= 31) {
          return DateTime(p0, p1, p2);
        }
        // إذا كان الجزء الأخير هو السنة (DD/MM/YYYY كما في فاتورة حسن الفقيه والزريقي)
        if (p2 > 1900 && p1 >= 1 && p1 <= 12 && p0 >= 1 && p0 <= 31) {
          return DateTime(p2, p1, p0);
        }
      }
    }

    return null;
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String _normalizeDigits(String input) {
    var out = input;
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      out = out.replaceAll(arabicDigits[i], '$i');
    }
    return out;
  }
}
