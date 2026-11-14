import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../3_invoices/presentation/screens/manual_invoice_entry_screen.dart';
import '../../../4_vouchers/presentation/screens/add_edit_voucher_screen.dart';
import '../../domain/entities/supplier_entity.dart';
import '../providers/suppliers_providers.dart';
import '../widgets/ledger_timeline_table.dart';
import '../widgets/reconciliation_status_card.dart';

/// شاشة كشف حساب المورد التفصيلي والأصناف المشتراة منه ومطابقة الرصيد وتصدير PDF.
class SupplierLedgerScreen extends ConsumerStatefulWidget {
  const SupplierLedgerScreen({super.key, required this.supplierId});

  final int supplierId;

  @override
  ConsumerState<SupplierLedgerScreen> createState() =>
      _SupplierLedgerScreenState();
}

class _SupplierLedgerScreenState extends ConsumerState<SupplierLedgerScreen> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final supplierAsync = ref.watch(supplierProvider(widget.supplierId));
    final statementAsync =
        ref.watch(supplierStatementProvider(widget.supplierId));
    final reconcileAsync =
        ref.watch(supplierReconciliationProvider(widget.supplierId));
    final purchasedItemsAsync =
        ref.watch(supplierPurchasedItemsProvider(widget.supplierId));

    final supplier = supplierAsync.valueOrNull;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(supplier?.name ?? AppStrings.supplierLedger),
          actions: [
            if (supplier != null)
              IconButton(
                tooltip: 'تعديل بيانات المورد والرصيد الافتتاحي',
                onPressed: () => _showEditSupplierDialog(context, supplier),
                icon: const Icon(Icons.edit_outlined),
              ),
            IconButton(
              tooltip: AppStrings.exportStatementPdf,
              onPressed: _exporting ? null : _exportPdf,
              icon: _exporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.receipt_long, size: 18),
                text: 'كشف الحساب التفصيلي',
              ),
              Tab(
                icon: Icon(Icons.inventory_2_outlined, size: 18),
                text: 'الأصناف المشتراة',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // التبويب الأول: كشف الحساب التفصيلي ومطابقة الرصيد
            RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(supplierStatementProvider(widget.supplierId));
                ref.invalidate(
                  supplierReconciliationProvider(widget.supplierId),
                );
              },
              child: ListView(
                children: [
                  if (supplier != null)
                    _SupplierHeader(
                      name: supplier.name,
                      branch: supplier.branchName,
                      analytic: supplier.analyticAccountNo,
                      balance: supplier.currentCalculatedBalance,
                    ),
                  if (reconcileAsync.valueOrNull != null)
                    ReconciliationStatusCard(
                      reconciliation: reconcileAsync.valueOrNull!,
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'سجل الحركات الزمني (اضغط على أي فاتورة أو سند للتفاصيل والصورة)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (statementAsync.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (statementAsync.hasError)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('خطأ: ${statementAsync.error}'),
                    )
                  else
                    LedgerTimelineTable(
                      entries: statementAsync.valueOrNull ?? [],
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // التبويب الثاني: الأصناف المشتراة من هذا المورد
            purchasedItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'لم يتم تسجيل أي أصناف مشتراة من هذا المورد بعد.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.local_offer_outlined,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          item.rawOcrName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        subtitle: Text(
                          [
                            if (item.supplierItemCode != null &&
                                item.supplierItemCode!.isNotEmpty)
                              'كود الصنف: ${item.supplierItemCode}',
                            if (item.defaultUnitName != null &&
                                item.defaultUnitName!.isNotEmpty)
                              'الوحدة: ${item.defaultUnitName}',
                            'آخر شراء: ${DateFormatter.formatDate(item.lastPurchaseDate)}',
                          ].join(' • '),
                          style: const TextStyle(fontSize: 11.5),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.formatNumber(
                                item.lastUnitPrice,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              'آخر سعر',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AddEditVoucherScreen(
                          supplierId: widget.supplierId,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.payments_outlined, size: 18),
                    label: const Text('تسجيل سند سداد'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ManualInvoiceEntryScreen(
                          initialSupplierId: widget.supplierId,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.post_add, size: 18),
                    label: const Text('فاتورة يدوية'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditSupplierDialog(
    BuildContext context,
    SupplierEntity supplier,
  ) async {
    final nameCtrl = TextEditingController(text: supplier.name);
    final branchCtrl = TextEditingController(text: supplier.branchName ?? '');
    final analyticCtrl =
        TextEditingController(text: supplier.analyticAccountNo ?? '');
    final openingCtrl = TextEditingController(
      text: supplier.openingBalance.toStringAsFixed(0),
    );
    final printedCtrl = TextEditingController(
      text: supplier.lastPrintedSupplierBalance?.toString() ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل بيانات المورد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم المورد'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: branchCtrl,
                decoration: const InputDecoration(labelText: 'الفرع (اختياري)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: analyticCtrl,
                decoration: const InputDecoration(labelText: 'الرقم التحليلي'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: openingCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'الرصيد الافتتاحي',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: printedCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'آخر رصيد مطبوع لدى المورد (اختياري)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              if (newName.isEmpty) return;
              final opening = CurrencyFormatter.parse(openingCtrl.text);
              final printedText = printedCtrl.text.trim();
              final printed = printedText.isEmpty
                  ? null
                  : CurrencyFormatter.parse(printedText);

              final updated = supplier.copyWith(
                name: newName,
                branchName: branchCtrl.text.trim().isEmpty
                    ? null
                    : branchCtrl.text.trim(),
                analyticAccountNo: analyticCtrl.text.trim().isEmpty
                    ? null
                    : analyticCtrl.text.trim(),
                openingBalance: opening,
                lastPrintedSupplierBalance: printed,
              );
              await ref
                  .read(suppliersRepositoryProvider)
                  .updateSupplier(updated);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    final supplier = ref.read(supplierProvider(widget.supplierId)).valueOrNull;
    final entries =
        ref.read(supplierStatementProvider(widget.supplierId)).valueOrNull;
    final reconciliation =
        ref.read(supplierReconciliationProvider(widget.supplierId)).valueOrNull;
    if (supplier == null || entries == null || reconciliation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البيانات غير جاهزة بعد')),
      );
      return;
    }
    setState(() => _exporting = true);
    try {
      final useCase = ref.read(generateStatementPdfUseCaseProvider);
      final bytes = await useCase.buildPdf(
        supplier: supplier,
        entries: entries,
        reconciliation: reconciliation,
      );
      await useCase.sharePdf(bytes: bytes, supplierName: supplier.name);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذّر تصدير PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _SupplierHeader extends StatelessWidget {
  const _SupplierHeader({
    required this.name,
    this.branch,
    required this.analytic,
    required this.balance,
  });

  final String name;
  final String? branch;
  final String? analytic;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.debtGradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.store, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                if (branch != null && branch!.trim().isNotEmpty)
                  Text(
                    'الفرع: $branch',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                if (analytic != null && analytic!.trim().isNotEmpty)
                  Text(
                    'رقم تحليلي: $analytic',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الرصيد المستحق',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Text(
                CurrencyFormatter.formatNumber(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
