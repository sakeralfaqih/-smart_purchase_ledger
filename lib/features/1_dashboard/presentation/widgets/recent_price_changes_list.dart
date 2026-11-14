import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

/// قائمة أحدث تنبيهات تغيّر الأسعار.
class RecentPriceChangesList extends StatelessWidget {
  const RecentPriceChangesList({
    super.key,
    required this.alerts,
    this.onItemTap,
  });

  final List<PriceChangeAlert> alerts;
  final void Function(PriceChangeAlert alert)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.accent, size: 20),
              SizedBox(width: 6),
              Text(
                AppStrings.recentPriceAlerts,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (alerts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'لا توجد تغيّرات سعرية حديثة',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          )
        else
          ...alerts.map(
            (a) => Card(
              child: ListTile(
                onTap: onItemTap == null ? null : () => onItemTap!(a),
                leading: CircleAvatar(
                  backgroundColor: (a.direction == PriceDirection.up
                          ? AppColors.priceUp
                          : a.direction == PriceDirection.down
                              ? AppColors.priceDown
                              : AppColors.priceSame)
                      .withValues(alpha: 0.12),
                  child: Icon(
                    a.direction == PriceDirection.up
                        ? Icons.arrow_upward
                        : a.direction == PriceDirection.down
                            ? Icons.arrow_downward
                            : Icons.drag_handle,
                    color: a.direction == PriceDirection.up
                        ? AppColors.priceUp
                        : a.direction == PriceDirection.down
                            ? AppColors.priceDown
                            : AppColors.priceSame,
                    size: 20,
                  ),
                ),
                title: Text(
                  a.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${a.supplierName} • ${CurrencyFormatter.formatNumber(a.previousPrice)} ← ${CurrencyFormatter.formatNumber(a.currentPrice)}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: PriceChangeBadge(
                  previousPrice: a.previousPrice,
                  currentPrice: a.currentPrice,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
