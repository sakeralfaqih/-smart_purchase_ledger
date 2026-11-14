import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../providers/catalog_providers.dart';
import 'item_suppliers_comparison_screen.dart';

/// شاشة ذاكرة الأسعار / دليل الأصناف: بحث عربي ذكي + بطاقات الأصناف مع آخر سعر وتكلفة وربح الحبة.
class PriceMemoryCatalogScreen extends ConsumerStatefulWidget {
  const PriceMemoryCatalogScreen({super.key});

  @override
  ConsumerState<PriceMemoryCatalogScreen> createState() =>
      _PriceMemoryCatalogScreenState();
}

class _PriceMemoryCatalogScreenState
    extends ConsumerState<PriceMemoryCatalogScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(catalogItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.priceMemory),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن صنف بالاسم...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
        ),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (items) {
          final normQuery = ArabicTextNormalizer.normalize(_query);
          final filtered = _query.isEmpty
              ? items
              : items
                  .where((i) =>
                      i.canonicalName.contains(_query) ||
                      i.normalizedName.contains(normQuery))
                  .toList();
          if (filtered.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'لا توجد أصناف في ذاكرة الأسعار',
              subtitle:
                  'ستُبنى ذاكرة الأسعار تلقائياً بمجرد حفظ أول فاتورة مشتريات.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24, top: 6),
            itemCount: filtered.length,
            itemBuilder: (context, i) => _CatalogItemCard(item: filtered[i]),
          );
        },
      ),
    );
  }
}

class _CatalogItemCard extends ConsumerWidget {
  const _CatalogItemCard({required this.item});

  final CatalogItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPrice = item.lastPurchasePrice != null;
    final pack = item.packUnitsCount;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.id == null
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ItemSuppliersComparisonScreen(item: item),
                  ),
                ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.canonicalName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (pack != null && pack > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '×$pack حبة',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _metric(
                    'آخر سعر (${item.defaultUnit})',
                    hasPrice
                        ? CurrencyFormatter.formatNumber(item.lastPurchasePrice!)
                        : '—',
                    AppColors.textPrimary,
                  ),
                  _metric(
                    'أقل سعر مسجل',
                    item.lowestPurchasePrice != null
                        ? CurrencyFormatter.formatNumber(
                            item.lowestPurchasePrice!,
                          )
                        : '—',
                    AppColors.priceDown,
                  ),
                  if (item.singlePieceCost != null)
                    _metric(
                      'تكلفة الحبة',
                      CurrencyFormatter.formatNumber(item.singlePieceCost!),
                      AppColors.primary,
                    ),
                  if (item.suggestedRetailPrice != null)
                    _metric(
                      'سعر البيع المقترح',
                      CurrencyFormatter.formatNumber(
                        item.suggestedRetailPrice!,
                      ),
                      AppColors.accent,
                    ),
                  if (item.profitPerPiece != null)
                    _metric(
                      'ربح الحبة',
                      '${CurrencyFormatter.formatNumber(item.profitPerPiece!)} '
                      '(${item.profitMarginPercentage?.toStringAsFixed(0) ?? '0'}%)',
                      item.profitPerPiece! >= 0
                          ? AppColors.priceDown
                          : AppColors.priceUp,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'اضغط لعرض مقارنة الموردين وتاريخ الأسعار وحاسبة البونص',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
