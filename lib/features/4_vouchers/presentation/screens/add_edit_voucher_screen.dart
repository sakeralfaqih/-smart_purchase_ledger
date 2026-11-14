import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../5_suppliers/domain/entities/supplier_entity.dart';
import '../../../5_suppliers/presentation/providers/suppliers_providers.dart';
import '../../domain/entities/payment_voucher_entity.dart';
import '../providers/vouchers_providers.dart';

/// شاشة إضافة سند قبض/سداد جديد — يخصم المبلغ تلقائياً من مديونية المورد.
class AddEditVoucherScreen extends ConsumerStatefulWidget {
  const AddEditVoucherScreen({super.key, this.supplierId});

  final int? supplierId;

  @override
  ConsumerState<AddEditVoucherScreen> createState() =>
      _AddEditVoucherScreenState();
}

class _AddEditVoucherScreenState extends ConsumerState<AddEditVoucherScreen> {
  int? _supplierId;
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountWordsController = TextEditingController();
  final _noteController = TextEditingController();
  final _printedBalanceController = TextEditingController();
  DateTime _date = DateTime.now();
  String _method = 'cash';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _supplierId = widget.supplierId;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _amountController.dispose();
    _amountWordsController.dispose();
    _noteController.dispose();
    _printedBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(allSuppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('سند قبض / سداد')),
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'أضف مورداً أولاً من شاشة الموردين.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }

          final validSupplierId =
              suppliers.any((s) => s.id == _supplierId) ? _supplierId : null;
          SupplierEntity? selectedSupplier;
          if (validSupplierId != null) {
            for (final s in suppliers) {
              if (s.id == validSupplierId) {
                selectedSupplier = s;
                break;
              }
            }
          }

          final enteredAmount = CurrencyFormatter.parse(_amountController.text);
          final balanceBefore = selectedSupplier?.currentCalculatedBalance;
          final balanceAfter =
              balanceBefore != null ? balanceBefore - enteredAmount : null;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: validSupplierId,
                        decoration: const InputDecoration(
                          labelText: AppStrings.supplier,
                        ),
                        items: suppliers
                            .map((s) => DropdownMenuItem<int>(
                                  value: s.id,
                                  child: Text(s.name),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _supplierId = v),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _numberController,
                        decoration: const InputDecoration(
                          labelText: 'رقم السند الورقي',
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: AppStrings.invoiceDate,
                            suffixIcon: Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(DateFormatter.display(_date)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'المبلغ المسدد رقماً',
                          prefixIcon: Icon(Icons.payments_outlined),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountWordsController,
                        decoration: const InputDecoration(
                          labelText: 'المبلغ كتابةً (اختياري)',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _method,
                        decoration:
                            const InputDecoration(labelText: 'طريقة الدفع'),
                        items: const [
                          DropdownMenuItem(value: 'cash', child: Text('نقدي')),
                          DropdownMenuItem(
                            value: 'transfer',
                            child: Text('حوالة/بنكي'),
                          ),
                          DropdownMenuItem(
                            value: 'cheque',
                            child: Text('شيك'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _method = v ?? 'cash'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _printedBalanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'الرصيد المتبقي المطبوع في السند (اختياري)',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظة / بيان السند (مثال: لكم نقداً من الحساب)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'سيتم خصم هذا المبلغ تلقائياً من مديونية المورد وتحديث الرصيد المحسوب.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.95,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (balanceBefore != null) ...[
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الرصيد الحالي قبل السند:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${CurrencyFormatter.formatNumber(balanceBefore)} ${AppStrings.currencySymbol}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الرصيد المتبقي بعد السداد:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${CurrencyFormatter.formatNumber(balanceAfter!)} ${AppStrings.currencySymbol}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('حفظ السند'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_supplierId == null) {
      _snack('اختر المورد أولاً');
      return;
    }
    final amount = CurrencyFormatter.parse(_amountController.text);
    if (amount <= 0) {
      _snack('أدخل مبلغاً صحيحاً أكبر من صفر');
      return;
    }
    setState(() => _saving = true);
    try {
      final printed = _printedBalanceController.text.trim().isEmpty
          ? null
          : CurrencyFormatter.parse(_printedBalanceController.text);
      final words = _amountWordsController.text.trim().isEmpty
          ? null
          : _amountWordsController.text.trim();
      final voucher = PaymentVoucherEntity(
        supplierId: _supplierId!,
        paperVoucherNumber: _numberController.text.trim().isEmpty
            ? 'سند-${DateTime.now().millisecondsSinceEpoch}'
            : _numberController.text.trim(),
        voucherDate: _date,
        amount: amount,
        amountWords: words,
        paymentMethod: _method,
        statementNote: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        printedRemainingBalance: printed,
        createdAt: DateTime.now(),
      );
      await ref.read(savePaymentVoucherUseCaseProvider)(voucher);
      if (mounted) {
        _snack('تم حفظ السند وخصم المبلغ من المديونية');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) _snack('فشل الحفظ: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
