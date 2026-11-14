import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../providers/catalog_providers.dart';
import '../widgets/supplier_price_ranking_card.dart';
import '../widgets/unit_cost_calculator_badge.dart';

/// شاشة مقارنة الموردين لصنف واحد + تاريخ تطوّر السعر + تفصيل تكلفة الحبة مع احتساب البونص الفعلي.
/// تقبل إما كيان الصنف مباشرة (item) أو معرّف الصنف (itemId) للتنقل السلس من الشاشة الرئيسية أو الكتالوج.
class ItemSuppliersComparisonScreen extends ConsumerWidget {
  const ItemSuppliersComparisonScreen({
    super.key,
    this.item,
    this.itemId,
  }) : assert(
          item != null || itemId != null,
          'يجب تمرير item أو itemId إلى ItemSuppliersComparisonScreen',
        );

  final CatalogItemEntity? item;
  final int? itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedId = item?.id ?? itemId!;
    final itemAsync = ref.watch(catalogItemByIdProvider(resolvedId));
    final currentItem = itemAsync.valueOrNull ?? item;

    if (currentItem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('مقارنة أسعار الصنف')),
        body: itemAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (_) => const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'الصنف غير موجود',
          ),
        ),
      );
    }

    final offersAsync = ref.watch(itemOffersProvider(resolvedId));
    final historyAsync = ref.watch(itemPriceHistoryProvider(resolvedId));
    final compareUseCase = ref.watch(compareSupplierPricesUseCaseProvider);
    final unitCostUseCase = ref.watch(calculateUnitCostUseCaseProvider);

    final historyPoints =
        historyAsync.valueOrNull ?? const <PriceHistoryPoint>[];
    final latestPoint = historyPoints.isNotEmpty ? historyPoints.last : null;

    final effectiveQty = (latestPoint != null && latestPoint.quantity > 0)
        ? latestPoint.quantity
        : 1.0;
    final effectiveFreeQty = latestPoint?.freeQuantity ?? 0.0;
    final effectiveLineTotal = latestPoint != null
        ? latestPoint.quantity * latestPoint.unitPrice
        : (currentItem.lastPurchasePrice ?? 0.0);

    return Scaffold(
      appBar: AppBar(title: Text(currentItem.canonicalName)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SummaryHeader(item: currentItem),
          const SizedBox(height: 12),
          if (currentItem.lastPurchasePrice != null)
            UnitCostCalculatorBadge(
              breakdown: unitCostUseCase(
                quantity: effectiveQty,
                lineTotal: effectiveLineTotal,
                packUnitsCount: currentItem.packUnitsCount ?? 1,
                freeQuantity: effectiveFreeQty,
              ),
            ),
          const SizedBox(height: 12),
          offersAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('خطأ: $e'),
            data: (offers) {
              final result = compareUseCase(
                itemId: resolvedId,
                itemName: currentItem.canonicalName,
                offers: offers,
              );
              return SupplierPriceRankingCard(result: result);
            },
          ),
          const SizedBox(height: 12),
          historyAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('خطأ: $e'),
            data: (points) => _PriceHistorySection(points: points),
          ),
        ],
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.item});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.debtGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.canonicalName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _stat('آخر سعر', item.lastPurchasePrice),
              _stat('أقل سعر', item.lowestPurchasePrice),
              _stat('سعر البيع', item.suggestedRetailPrice),
              _stat('تكلفة الحبة', item.singlePieceCost),
              if (item.profitPerPiece != null)
                _stat('ربح الحبة', item.profitPerPiece),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, double? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
        Text(
          value != null ? CurrencyFormatter.formatNumber(value) : '—',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _PriceHistorySection extends StatelessWidget {
  const _PriceHistorySection({required this.points});

  final List<PriceHistoryPoint> points;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.show_chart, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'تاريخ تطوّر السعر لدى الموردين',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (points.isEmpty)
              const EmptyState(
                icon: Icons.timeline,
                title: 'لا يوجد سجل أسعار بعد',
              )
            else
              ...points.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final prev = i > 0 ? points[i - 1].unitPrice : null;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.supplierName,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              [
                                DateFormatter.display(p.date),
                                if (p.quantity > 0)
                                  'الكمية: ${CurrencyFormatter.formatNumber(p.quantity)}',
                                if (p.freeQuantity > 0)
                                  'بونص: +${CurrencyFormatter.formatNumber(p.freeQuantity)}',
                              ].join(' • '),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.formatNumber(p.unitPrice),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (prev != null)
                            Text(
                              _deltaLabel(prev, p.unitPrice),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: p.unitPrice > prev
                                    ? AppColors.priceUp
                                    : (p.unitPrice < prev
                                        ? AppColors.priceDown
                                        : AppColors.priceSame),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _deltaLabel(double prev, double curr) {
    final diff = curr - prev;
    if (diff.abs() < 0.0001) return 'مطابق للسابق';
    final sign = diff > 0 ? '▲ +' : '▼ -';
    return '$sign${CurrencyFormatter.formatNumber(diff.abs())}';
  }
}
