import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/balance_reconciliation_entity.dart';

/// بطاقة مطابقة الرصيد المحسوب مقابل الرصيد المطبوع لدى المورد.
class ReconciliationStatusCard extends StatelessWidget {
  const ReconciliationStatusCard({super.key, required this.reconciliation});

  final BalanceReconciliationEntity reconciliation;

  @override
  Widget build(BuildContext context) {
    final matched = reconciliation.isMatched;
    final color = matched ? AppColors.balanceMatch : AppColors.balanceMismatch;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  matched ? Icons.verified : Icons.gpp_maybe,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    matched
                        ? AppStrings.balanceMatched
                        : AppStrings.balanceMismatch,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (reconciliation.printedDocDate != null)
                  Text(
                    'آخر وثيقة: ${DateFormatter.formatDate(reconciliation.printedDocDate!)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _BalanceBox(
                    label: 'الرصيد المحسوب بالتطبيق',
                    value: reconciliation.calculatedBalance,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BalanceBox(
                    label: 'الرصيد المطبوع لدى المورد',
                    value: reconciliation.printedBalance,
                    color: color,
                  ),
                ),
              ],
            ),
            if (!matched) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.balanceMismatch.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.balanceMismatch.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'تنبيه عدم تطابق: رصيد المورد المطبوع يختلف عن الرصيد المحسوب في التطبيق بفارق قدره '
                  '${CurrencyFormatter.formatSigned(reconciliation.difference)} ${AppStrings.currencySymbol}',
                  style: const TextStyle(
                    color: AppColors.balanceMismatch,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BalanceBox extends StatelessWidget {
  const _BalanceBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value == null ? 'غير متوفر' : CurrencyFormatter.formatNumber(value!),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
