import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/supplier_entity.dart';
import '../providers/suppliers_providers.dart';
import 'supplier_ledger_screen.dart';

class SuppliersListScreen extends ConsumerStatefulWidget {
  const SuppliersListScreen({super.key});

  @override
  ConsumerState<SuppliersListScreen> createState() =>
      _SuppliersListScreenState();
}

class _SuppliersListScreenState extends ConsumerState<SuppliersListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(allSuppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.suppliers)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSupplier(context),
        icon: const Icon(Icons.add),
        label: const Text('مورد جديد'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث باسم المورد أو الرقم التحليلي...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: suppliersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (suppliers) {
                final normalizedQuery = ArabicTextNormalizer.normalize(_query);
                final filtered = _query.isEmpty
                    ? suppliers
                    : suppliers.where((s) {
                        final normName = ArabicTextNormalizer.normalize(s.name);
                        final normBranch = ArabicTextNormalizer.normalize(
                          s.branchName ?? '',
                        );
                        final analytic = s.analyticAccountNo ?? '';
                        return normName.contains(normalizedQuery) ||
                            normBranch.contains(normalizedQuery) ||
                            analytic.contains(_query);
                      }).toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا يوجد موردون مطابقون',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) =>
                      _SupplierTile(supplier: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddSupplier(BuildContext context) async {
    final nameController = TextEditingController();
    final branchController = TextEditingController();
    final analyticController = TextEditingController();
    final openingController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إضافة مورد جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المورد'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: branchController,
                decoration: const InputDecoration(
                  labelText: 'الفرع / العنوان (اختياري)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: analyticController,
                decoration: const InputDecoration(
                  labelText: 'الرقم التحليلي لدى المورد (اختياري)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: openingController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'الرصيد الافتتاحي (ريال)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final opening = CurrencyFormatter.parse(openingController.text);
              await ref.read(suppliersRepositoryProvider).createSupplier(
                    SupplierEntity(
                      name: name,
                      branchName: branchController.text.trim().isEmpty
                          ? null
                          : branchController.text.trim(),
                      analyticAccountNo: analyticController.text.trim().isEmpty
                          ? null
                          : analyticController.text.trim(),
                      openingBalance: opening,
                      currentCalculatedBalance: opening,
                      createdAt: DateTime.now(),
                    ),
                  );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}

class _SupplierTile extends StatelessWidget {
  const _SupplierTile({required this.supplier});

  final SupplierEntity supplier;

  @override
  Widget build(BuildContext context) {
    final mismatch = supplier.hasBalanceMismatch;
    final trimmedName = supplier.name.trim();
    final firstChar =
        trimmedName.isEmpty ? 'م' : trimmedName.characters.first;

    return Card(
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SupplierLedgerScreen(supplierId: supplier.id!),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            firstChar,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                supplier.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (mismatch)
              const Tooltip(
                message: 'يوجد فرق بين الرصيد المحسوب والرصيد المطبوع',
                child: Icon(
                  Icons.gpp_maybe,
                  color: AppColors.balanceMismatch,
                  size: 18,
                ),
              )
            else if (supplier.lastPrintedSupplierBalance != null)
              const Tooltip(
                message: 'الرصيد متطابق مع آخر وثيقة للمورد',
                child: Icon(
                  Icons.verified,
                  color: AppColors.balanceMatch,
                  size: 17,
                ),
              ),
          ],
        ),
        subtitle: Text(
          [
            if (supplier.branchName != null &&
                supplier.branchName!.trim().isNotEmpty)
              supplier.branchName!,
            if (supplier.analyticAccountNo != null &&
                supplier.analyticAccountNo!.trim().isNotEmpty)
              'رقم تحليلي: ${supplier.analyticAccountNo}'
            else
              'بدون رقم تحليلي',
          ].join(' • '),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.formatNumber(supplier.currentCalculatedBalance),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: supplier.currentCalculatedBalance > 0
                    ? AppColors.debt
                    : AppColors.balanceMatch,
              ),
            ),
            const Text(
              'الرصيد',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
