import 'package:flutter/material.dart';

/// ألوان النظام ودلالات التنبيه.
class AppColors {
  AppColors._();

  // الهوية البصرية الأساسية
  static const Color primary = Color(0xFF0E7C66); // أخضر تجاري هادئ
  static const Color primaryDark = Color(0xFF095447);
  static const Color accent = Color(0xFFF2A93B); // ذهبي

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // دلالات التنبيه
  static const Color reviewYellow = Color(0xFFFFF3C4); // سطر يحتاج مراجعة
  static const Color reviewYellowBorder = Color(0xFFF2C94C);

  static const Color priceUp = Color(0xFFD64545); // ارتفاع السعر (أحمر)
  static const Color priceDown = Color(0xFF2E9E5B); // انخفاض السعر (أخضر)
  static const Color priceSame = Color(0xFF8A8F98); // مطابق (رمادي)

  static const Color balanceMatch = Color(0xFF2E9E5B); // رصيد متطابق
  static const Color balanceMismatch = Color(0xFFD64545); // فرق رصيد

  static const Color debt = Color(0xFFB23A48);

  static const Color textPrimary = Color(0xFF1F2933);
  static const Color textSecondary = Color(0xFF616E7C);
  static const Color divider = Color(0xFFE4E7EB);

  // تدرّج بطاقات لوحة التحكم
  static const List<Color> debtGradient = [Color(0xFF0E7C66), Color(0xFF13A88A)];
  static const List<Color> alertGradient = [Color(0xFFD64545), Color(0xFFE07A5F)];
}
