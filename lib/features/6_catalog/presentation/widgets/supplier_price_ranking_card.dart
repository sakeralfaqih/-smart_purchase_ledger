import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/usecases/compare_supplier_prices_usecase.dart';

/// بطاقة تعرض ترتيب الموردين حسب سعر الصنف (من الأرخص إلى الأغلى) مع الفروق والنِسب.
class SupplierPriceRankingCard extends StatelessWidget {
  const SupplierPriceRankingCard({
    super.key,
    required this.result,
  });

  final SupplierPriceComparisonResult result;

  @override
  Widget build(BuildContext context) {
    if (result.rows.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'لا توجد عروض أسعار مسجّلة لهذا الصنف بعد.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.leaderboard_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ترتيب الموردين — ${result.itemName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _chip(
                  'أفضل سعر',
                  CurrencyFormatter.formatNumber(result.bestPrice),
                  AppColors.priceDown,
                ),
                _chip(
                  'المتوسط',
                  CurrencyFormatter.formatNumber(result.averagePrice),
                  AppColors.textSecondary,
                ),
                _chip(
                  'أعلى سعر',
                  CurrencyFormatter.formatNumber(result.worstPrice),
                  AppColors.priceUp,
                ),
                if (result.hasComparison)
                  _chip(
                    'الفارق',
                    CurrencyFormatter.formatNumber(result.spread),
                    AppColors.accent,
                  ),
              ],
            ),
            const Divider(height: 20),
            ...result.rows.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final row = entry.value;
              return _RankingRow(rank: rank, comparison: row);
            }),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.rank, required this.comparison});

  final int rank;
  final SupplierPriceComparison comparison;

  @override
  Widget build(BuildContext context) {
    final offer = comparison.offer;
    final isBest = comparison.isBest;
    final color = isBest
        ? AppColors.priceDown
        : (comparison.isAboveAverage
            ? AppColors.priceUp
            : AppColors.textSecondary);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isBest
            ? AppColors.priceDown.withValues(alpha: 0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isBest
              ? AppColors.priceDown.withValues(alpha: 0.35)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        offer.supplierName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (isBest) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.workspace_premium,
                        size: 14,
                        color: AppColors.priceDown,
                      ),
                    ],
                  ],
                ),
                if (offer.supplierItemCode != null ||
                    offer.lastPurchaseDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if (offer.supplierItemCode != null &&
                            offer.supplierItemCode!.isNotEmpty)
                          'كود: ${offer.supplierItemCode}',
                        if (offer.lastPurchaseDate != null)
                          'آخر شراء: ${DateFormatter.display(offer.lastPurchaseDate!)}',
                      ].join(' • '),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatNumber(offer.unitPrice),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
              if (!isBest)
                Text(
                  '+${CurrencyFormatter.formatNumber(comparison.differenceFromBest)} '
                  '(${comparison.percentageFromBest.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.priceUp,
                  ),
                )
              else
                const Text(
                  'الأرخص',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.priceDown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
