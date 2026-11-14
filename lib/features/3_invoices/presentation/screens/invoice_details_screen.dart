import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../../5_suppliers/presentation/providers/suppliers_providers.dart';
import '../../domain/entities/invoice_line_entity.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import '../providers/invoices_providers.dart';

/// شاشة تفاصيل فاتورة مشتريات محفوظة: البنود، الإجماليات، صور الصفحات، تنبيهات الرياضيات، والحذف الآمن.
class InvoiceDetailsScreen extends ConsumerWidget {
  const InvoiceDetailsScreen({super.key, required this.invoiceId});

  final int invoiceId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الفاتورة'),
        content: const Text(
          'هل أنت متأكد من حذف هذه الفاتورة؟ سيتم إعادة حساب رصيد المورد تلقائياً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.balanceMismatch,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await ref.read(invoicesRepositoryProvider).deleteInvoice(invoiceId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف الفاتورة وتحديث رصيد المورد')),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailsProvider(invoiceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الفاتورة'),
        actions: [
          if (invoiceAsync.valueOrNull != null)
            IconButton(
              tooltip: 'حذف الفاتورة',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, ref),
            ),
        ],
      ),
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (invoice) {
          if (invoice == null) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'الفاتورة غير موجودة',
            );
          }
          final supplierAsync = ref.watch(supplierProvider(invoice.supplierId));
          final supplierName =
              supplierAsync.maybeWhen(data: (s) => s?.name, orElse: () => '—');
          return _InvoiceDetailsBody(
            invoice: invoice,
            supplierName: supplierName ?? '—',
          );
        },
      ),
    );
  }
}

class _InvoiceDetailsBody extends StatelessWidget {
  const _InvoiceDetailsBody({
    required this.invoice,
    required this.supplierName,
  });

  final PurchaseInvoiceEntity invoice;
  final String supplierName;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _HeaderCard(invoice: invoice, supplierName: supplierName),
        if (invoice.hasMathWarning) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.reviewYellow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.reviewYellowBorder),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.reviewYellowBorder,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'هذه الفاتورة تحتوي على سطور بحاجة إلى مراجعة رياضية.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        _LinesCard(lines: invoice.lines),
        const SizedBox(height: 12),
        _TotalsCard(invoice: invoice),
        if (invoice.imagePaths.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ImagesCard(paths: invoice.imagePaths),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.invoice, required this.supplierName});

  final PurchaseInvoiceEntity invoice;
  final String supplierName;

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
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'فاتورة رقم ${invoice.paperInvoiceNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _statusChip(invoice.paymentType),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            supplierName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'التاريخ: ${DateFormatter.display(invoice.invoiceDate)}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String type) {
    final label = switch (type) {
      'cash' => AppStrings.cash,
      'partial' => AppStrings.partial,
      _ => AppStrings.credit,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.lines});

  final List<InvoiceLineEntity> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'البنود (${lines.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (lines.isEmpty)
              const Text(
                'لا توجد بنود',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              ...lines.map((l) => _LineRow(line: l)),
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line});

  final InvoiceLineEntity line;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: line.needsReview
            ? AppColors.reviewYellow
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: line.needsReview
              ? AppColors.reviewYellowBorder
              : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${line.lineNumber}. ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  line.rawItemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (line.previousUnitPrice != null)
                PriceChangeBadge(
                  previousPrice: line.previousUnitPrice!,
                  currentPrice: line.unitPrice,
                ),
              if (line.needsReview)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.flag, size: 14, color: AppColors.priceUp),
                ),
            ],
          ),
          if (line.quantityWords != null &&
              line.quantityWords!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                'الكمية كتابةً: ${line.quantityWords}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _kv(
                'الكمية',
                '${CurrencyFormatter.formatNumber(line.quantity)} ${line.unitName}',
              ),
              if (line.freeQuantity > 0)
                _kv(
                  'مجاني',
                  CurrencyFormatter.formatNumber(line.freeQuantity),
                  color: AppColors.priceDown,
                ),
              _kv(
                'سعر الوحدة',
                CurrencyFormatter.formatNumber(line.unitPrice),
              ),
              _kv(
                'الإجمالي',
                CurrencyFormatter.formatNumber(line.lineTotal),
                bold: true,
              ),
              if (line.singlePieceCost != null && line.singlePieceCost! > 0)
                _kv(
                  'تكلفة الحبة',
                  CurrencyFormatter.formatNumber(line.singlePieceCost!),
                  color: AppColors.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {bool bold = false, Color? color}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        children: [
          TextSpan(text: '$k: '),
          TextSpan(
            text: v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.invoice});

  final PurchaseInvoiceEntity invoice;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _totalRow(AppStrings.subtotal, invoice.subtotal),
            if (invoice.discount > 0)
              _totalRow(
                AppStrings.discount,
                -invoice.discount,
                color: AppColors.priceDown,
              ),
            if (invoice.extraCharges > 0)
              _totalRow(
                AppStrings.extraCharges,
                invoice.extraCharges,
                color: AppColors.priceUp,
              ),
            const Divider(),
            _totalRow(AppStrings.netTotal, invoice.netTotal, bold: true),
            if (invoice.paidAmount > 0)
              _totalRow(
                'المدفوع',
                invoice.paidAmount,
                color: AppColors.balanceMatch,
              ),
            _totalRow(
              'المتبقي (آجل)',
              invoice.remainingAmount,
              color: invoice.remainingAmount > 0
                  ? AppColors.debt
                  : AppColors.balanceMatch,
              bold: true,
            ),
            if (invoice.printedPrevBalance != null ||
                invoice.printedCurrBalance != null) ...[
              const Divider(),
              if (invoice.printedPrevBalance != null)
                _totalRow(
                  'الرصيد السابق المطبوع بالفاتورة',
                  invoice.printedPrevBalance!,
                ),
              if (invoice.printedCurrBalance != null)
                _totalRow(
                  'الرصيد الحالي المطبوع بالفاتورة',
                  invoice.printedCurrBalance!,
                  bold: true,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _totalRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${CurrencyFormatter.formatNumber(value)} ${AppStrings.currencySymbol}',
            style: TextStyle(
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagesCard extends StatelessWidget {
  const _ImagesCard({required this.paths});

  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'صور الصفحات (${paths.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: paths.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final file = File(paths[i]);
                  return GestureDetector(
                    onTap: () => _openFull(context, paths[i]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: file.existsSync()
                          ? Image.file(
                              file,
                              width: 90,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 90,
                              height: 120,
                              color: AppColors.background,
                              child: const Icon(
                                Icons.broken_image,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFull(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 5.0,
          child: Image.file(File(path)),
        ),
      ),
    );
  }
}
