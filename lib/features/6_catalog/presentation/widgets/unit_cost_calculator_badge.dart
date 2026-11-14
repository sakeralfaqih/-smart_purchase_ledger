import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/usecases/calculate_unit_cost_usecase.dart';

/// بطاقة صغيرة تعرض تفصيل تكلفة الوحدة الكبيرة والحبة الواحدة مع احتساب البونص.
class UnitCostCalculatorBadge extends StatelessWidget {
  const UnitCostCalculatorBadge({
    super.key,
    required this.breakdown,
    this.compact = false,
  });

  final UnitCostBreakdown breakdown;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              const Text(
                'تفصيل التكلفة الفعلية (شامل البونص)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              if (breakdown.hasBonus)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.priceDown.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'بونص +${CurrencyFormatter.formatNumber(breakdown.bonusUnits)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.priceDown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _row(
            'تكلفة العبوة الفعلية بعد البونص',
            '${CurrencyFormatter.formatNumber(breakdown.effectiveLargeUnitCost)} ريال',
            bold: true,
          ),
          const SizedBox(height: 4),
          _row(
            'تكلفة الحبة الواحدة (الشد: ${breakdown.packUnitsCount})',
            '${CurrencyFormatter.formatNumber(breakdown.singlePieceCost)} ريال',
            highlight: true,
          ),
          if (breakdown.hasBonus) ...[
            const SizedBox(height: 4),
            _row(
              'قيمة التوفير من البونص المجاني',
              '${CurrencyFormatter.formatNumber(breakdown.bonusValue)} ريال',
              color: AppColors.priceDown,
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool bold = false,
    bool highlight = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 14 : 12,
            fontWeight: bold || highlight ? FontWeight.bold : FontWeight.w500,
            color:
                color ?? (highlight ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
