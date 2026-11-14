import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../3_invoices/presentation/screens/invoice_details_screen.dart';
import '../../../4_vouchers/presentation/providers/vouchers_providers.dart';
import '../../domain/entities/supplier_ledger_entry_entity.dart';

/// جدول كشف الحساب الزمني التفاعلي مع الرصيد التراكمي ومعاينة الوثائق.
class LedgerTimelineTable extends ConsumerWidget {
  const LedgerTimelineTable({super.key, required this.entries});

  final List<SupplierLedgerEntryEntity> entries;

  void _onRowTap(
    BuildContext context,
    WidgetRef ref,
    SupplierLedgerEntryEntity entry,
  ) {
    if (entry.type == LedgerEntryType.invoice && entry.documentId != null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => InvoiceDetailsScreen(invoiceId: entry.documentId!),
        ),
      );
      return;
    }

    if (entry.type == LedgerEntryType.voucher) {
      _showVoucherDetailsDialog(context, ref, entry);
    }
  }

  Future<void> _showVoucherDetailsDialog(
    BuildContext context,
    WidgetRef ref,
    SupplierLedgerEntryEntity entry,
  ) async {
    final hasImage =
        entry.imagePath != null && File(entry.imagePath!).existsSync();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('سند قبض رقم ${entry.referenceNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('التاريخ: ${DateFormatter.formatDate(entry.date)}'),
              const SizedBox(height: 6),
              Text(
                'المبلغ المسدد: ${CurrencyFormatter.formatNumber(entry.credit)} ${AppStrings.currencySymbol}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.balanceMatch,
                ),
              ),
              const SizedBox(height: 6),
              Text('البيان: ${entry.description}'),
              const SizedBox(height: 6),
              Text(
                'الرصيد التراكمي بعد السند: ${CurrencyFormatter.formatNumber(entry.runningBalance)} ${AppStrings.currencySymbol}',
              ),
              if (hasImage) ...[
                const SizedBox(height: 12),
                const Text(
                  'صورة السند:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 220,
                    width: 280,
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 5.0,
                      child: Image.file(
                        File(entry.imagePath!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (entry.documentId != null)
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.balanceMismatch,
              ),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('حذف السند'),
              onPressed: () async {
                await ref
                    .read(vouchersRepositoryProvider)
                    .deleteVoucher(entry.documentId!);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حذف السند وإعادة حساب رصيد المورد'),
                    ),
                  );
                }
              },
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'لا توجد حركات على هذا المورد بعد',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                _HeaderCell('التاريخ', flex: 3),
                _HeaderCell('البيان والمرجع', flex: 5),
                _HeaderCell('مدين', flex: 3),
                _HeaderCell('دائن', flex: 3),
                _HeaderCell('الرصيد', flex: 3),
              ],
            ),
          ),
          ...entries.asMap().entries.map((e) {
            final entry = e.value;
            final isEven = e.key.isEven;
            final isInteractive = entry.type != LedgerEntryType.opening;
            final hasAttachment = entry.imagePath != null &&
                entry.imagePath!.trim().isNotEmpty;

            return InkWell(
              onTap: isInteractive
                  ? () => _onRowTap(context, ref, entry)
                  : null,
              child: Container(
                color: isEven ? Colors.white : AppColors.background,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BodyCell(
                      '${entry.date.year}/${entry.date.month}/${entry.date.day}',
                      flex: 3,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.description,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (entry.referenceNumber != '—')
                            Row(
                              children: [
                                Text(
                                  'رقم: ${entry.referenceNumber}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (hasAttachment) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.image_outlined,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                    _BodyCell(
                      entry.debit > 0
                          ? CurrencyFormatter.formatNumber(entry.debit)
                          : '—',
                      flex: 3,
                      color: AppColors.debt,
                    ),
                    _BodyCell(
                      entry.credit > 0
                          ? CurrencyFormatter.formatNumber(entry.credit)
                          : '—',
                      flex: 3,
                      color: AppColors.balanceMatch,
                    ),
                    _BodyCell(
                      CurrencyFormatter.formatNumber(entry.runningBalance),
                      flex: 3,
                      bold: true,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {required this.flex});
  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: flex,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(
    this.text, {
    required this.flex,
    this.color,
    this.bold = false,
  });
  final String text;
  final int flex;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: flex,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: color ?? AppColors.textPrimary,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
}
