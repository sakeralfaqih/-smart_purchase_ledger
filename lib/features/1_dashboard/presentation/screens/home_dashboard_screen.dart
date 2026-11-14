import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../2_ocr_scanner/domain/entities/extracted_document_entity.dart';
import '../../../2_ocr_scanner/presentation/ocr_launcher.dart';
import '../../../3_invoices/presentation/screens/invoice_details_screen.dart';
import '../../../5_suppliers/presentation/screens/supplier_ledger_screen.dart';
import '../../../5_suppliers/presentation/screens/suppliers_list_screen.dart';
import '../../../6_catalog/presentation/screens/item_suppliers_comparison_screen.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/balance_mismatch_alert_banner.dart';
import '../widgets/recent_price_changes_list.dart';
import '../widgets/total_debts_summary_card.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: () => ref.invalidate(dashboardSummaryProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardSummaryProvider),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(child: Text('تعذّر تحميل البيانات: $e')),
            ],
          ),
          data: (summary) => ListView(
            children: [
              // 1. شريط البحث الفوري الشامل (أصناف، موردين، أرقام فواتير)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.globalSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                ),
              ),

              if (_searchQuery.isNotEmpty)
                _GlobalSearchResultsPanel(
                  query: _searchQuery,
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              else ...[
                // 2. بطاقة ملخص الديون ومؤشرات الشهر
                TotalDebtsSummaryCard(
                  totalDebt: summary.totalDebt,
                  supplierCount: summary.supplierCount,
                  monthPurchases: summary.monthPurchases,
                  monthPayments: summary.monthPayments,
                ),

                // 3. لافتة تنبيه فروقات أرصدة الموردين (مربوطة بشاشة الموردين)
                BalanceMismatchAlertBanner(
                  count: summary.mismatchedSupplierCount,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SuppliersListScreen(),
                      ),
                    );
                  },
                ),

                // 4. أزرار التصوير السريع (فاتورة مشتريات / سند قبض)
                _QuickActions(),

                // 5. قائمة أحدث تنبيهات تغير الأسعار (مربوطة بشاشة مقارنة الموردين للصنف)
                RecentPriceChangesList(
                  alerts: summary.recentPriceChanges,
                  onItemTap: (alert) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ItemSuppliersComparisonScreen(
                          itemId: alert.itemId,
                        ),
                      ),
                    );
                  },
                ),

                // 6. أحدث الفواتير المسجلة
                _RecentInvoices(invoices: summary.recentInvoices),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// لوحة عرض نتائج البحث الفوري الشامل (موردون + أصناف + فواتير)
class _GlobalSearchResultsPanel extends ConsumerWidget {
  const _GlobalSearchResultsPanel({
    required this.query,
    required this.onClear,
  });

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(globalSearchProvider(query));

    return searchAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('خطأ أثناء البحث: $e'),
      ),
      data: (GlobalSearchResults results) {
        if (results.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'لا توجد نتائج مطابقة للبحث.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (results.suppliers.isNotEmpty) ...[
              const _SearchSectionHeader(
                title: 'الموردون المطابقون',
                icon: Icons.storefront_outlined,
              ),
              ...results.suppliers.map(
                (hit) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      hit.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: hit.subtitle != null ? Text(hit.subtitle!) : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              SupplierLedgerScreen(supplierId: hit.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            if (results.items.isNotEmpty) ...[
              const _SearchSectionHeader(
                title: 'الأصناف وذاكرة الأسعار',
                icon: Icons.inventory_2_outlined,
              ),
              ...results.items.map(
                (hit) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.price_change_outlined,
                      color: AppColors.accent,
                    ),
                    title: Text(
                      hit.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: hit.subtitle != null ? Text(hit.subtitle!) : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ItemSuppliersComparisonScreen(itemId: hit.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            if (results.invoices.isNotEmpty) ...[
              const _SearchSectionHeader(
                title: 'الفواتير المطابقة',
                icon: Icons.receipt_long_outlined,
              ),
              ...results.invoices.map(
                (hit) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_outlined,
                      color: AppColors.primaryDark,
                    ),
                    title: Text(
                      hit.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: hit.subtitle != null ? Text(hit.subtitle!) : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              InvoiceDetailsScreen(invoiceId: hit.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SearchSectionHeader extends StatelessWidget {
  const _SearchSectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              icon: Icons.document_scanner_outlined,
              label: AppStrings.scanPurchaseInvoice,
              color: AppColors.primary,
              onTap: () => OcrLauncher.scanAndReview(
                context,
                ref,
                hint: DocType.purchaseInvoice,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionCard(
              icon: Icons.receipt_outlined,
              label: AppStrings.scanReceiptVoucher,
              color: AppColors.accent,
              onTap: () => OcrLauncher.scanAndReview(
                context,
                ref,
                hint: DocType.receiptVoucher,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentInvoices extends StatelessWidget {
  const _RecentInvoices({required this.invoices});

  final List<RecentInvoiceSummary> invoices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: AppColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'أحدث الفواتير',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (invoices.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'لا توجد فواتير بعد — ابدأ بتصوير فاتورة مشتريات',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          )
        else
          ...invoices.map(
            (inv) => Card(
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        InvoiceDetailsScreen(invoiceId: inv.invoiceId),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.receipt,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  '${inv.supplierName} — فاتورة #${inv.paperInvoiceNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${inv.invoiceDate.year}/${inv.invoiceDate.month}/${inv.invoiceDate.day} • ${_paymentLabel(inv.paymentType)}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.formatNumber(inv.netTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    if (inv.hasMathWarning)
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 15,
                        color: AppColors.reviewYellowBorder,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _paymentLabel(String type) => switch (type) {
        'cash' => AppStrings.cash,
        'partial' => AppStrings.partial,
        _ => AppStrings.credit,
      };
}
