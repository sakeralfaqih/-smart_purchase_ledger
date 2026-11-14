import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/currency_formatter.dart';

/// شارة تُظهر اتجاه تغيّر السعر:
/// - ★ أزرق إذا كان الصنف جديداً (previousPrice == null أو <= 0)
/// - ▲ أحمر للارتفاع (مع القيمة والنسبة المئوية)
/// - ▼ أخضر للانخفاض (مع القيمة والنسبة المئوية)
/// - = رمادي للمطابقة
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({
    super.key,
    required this.previousPrice,
    required this.currentPrice,
    this.showPercentage = true,
  });

  final double? previousPrice;
  final double currentPrice;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final prev = previousPrice;

    // حالة الصنف الجديد الذي لم يُشترَ من قبل
    if (prev == null || prev <= 0.0001) {
      const newColor = Color(0xFF1D4ED8);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: newColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: newColor.withOpacity(0.35)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fiber_new_outlined, size: 13, color: newColor),
            SizedBox(width: 3),
            Text(
              'صنف جديد',
              style: TextStyle(
                color: newColor,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final diff = currentPrice - prev;
    final pct = (diff.abs() / prev) * 100.0;
    final pctText =
        showPercentage && pct >= 0.1 ? ' (${pct.toStringAsFixed(1)}%)' : '';

    late final Color color;
    late final IconData icon;
    late final String label;

    if (diff > 0.01) {
      color = AppColors.priceUp;
      icon = Icons.arrow_upward;
      label = '+${CurrencyFormatter.formatNumber(diff)}$pctText';
    } else if (diff < -0.01) {
      color = AppColors.priceDown;
      icon = Icons.arrow_downward;
      label = '-${CurrencyFormatter.formatNumber(diff.abs())}$pctText';
    } else {
      color = AppColors.priceSame;
      icon = Icons.drag_handle;
      label = 'مطابق';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
