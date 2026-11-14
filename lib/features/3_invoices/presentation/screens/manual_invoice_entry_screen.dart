import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../2_ocr_scanner/domain/usecases/parse_item_pack_and_retail_usecase.dart';
import '../../../5_suppliers/domain/entities/supplier_entity.dart';
import '../../../5_suppliers/presentation/providers/suppliers_providers.dart';
import '../../domain/entities/invoice_line_entity.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import '../providers/invoices_providers.dart';

double _parseArabicDouble(String input) {
  const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  var normalized = input.trim().replaceAll(',', '');
  for (var i = 0; i < arabicDigits.length; i++) {
    normalized = normalized.replaceAll(arabicDigits[i], i.toString());
  }
  return double.tryParse(normalized) ?? 0.0;
}

class _ManualLine {
  _ManualLine()
      : nameController = TextEditingController(),
        unitController = TextEditingController(text: 'كرتون'),
        qtyController = TextEditingController(text: '1'),
        freeController = TextEditingController(text: '0'),
        priceController = TextEditingController();

  final TextEditingController nameController;
  final TextEditingController unitController;
  final TextEditingController qtyController;
  final TextEditingController freeController;
  final TextEditingController priceController;

  double get qty => _parseArabicDouble(qtyController.text);
  double get free => _parseArabicDouble(freeController.text);
  double get price => _parseArabicDouble(priceController.text);
  double get total => qty * price;

  void dispose() {
    nameController.dispose();
    unitController.dispose();
    qtyController.dispose();
    freeController.dispose();
    priceController.dispose();
  }
}

/// شاشة إدخال فاتورة مشتريات يدوياً (بدون مسح ضوئي).
class ManualInvoiceEntryScreen extends ConsumerStatefulWidget {
  const ManualInvoiceEntryScreen({
    super.key,
    this.initialSupplierId,
  });

  final int? initialSupplierId;

  @override
  ConsumerState<ManualInvoiceEntryScreen> createState() =>
      _ManualInvoiceEntryScreenState();
}

class _ManualInvoiceEntryScreenState
    extends ConsumerState<ManualInvoiceEntryScreen> {
  int? _supplierId;
  final _invoiceNumberController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _extraController = TextEditingController(text: '0');
  final _paidController = TextEditingController(text: '0');
  final _printedBalanceController = TextEditingController();
  DateTime _date = DateTime.now();
  String _paymentType = 'credit';
  final List<_ManualLine> _lines = [_ManualLine()];
  bool _saving = false;

  static const _packParser = ParseItemPackAndRetailUseCase();

  @override
  void initState() {
    super.initState();
    _supplierId = widget.initialSupplierId;
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _discountController.dispose();
    _extraController.dispose();
    _paidController.dispose();
    _printedBalanceController.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  double get _subtotal => _lines.fold(0.0, (s, l) => s + l.total);
  double get _discount => _parseArabicDouble(_discountController.text);
  double get _extra => _parseArabicDouble(_extraController.text);
  double get _netTotal => _subtotal - _discount + _extra;

  double get _effectivePaid {
    return switch (_paymentType) {
      'cash' => _netTotal,
      'partial' => _parseArabicDouble(_paidController.text).clamp(0.0, _netTotal),
      _ => 0.0,
    };
  }

  double get _remainingDebt =>
      (_netTotal - _effectivePaid).clamp(0.0, double.infinity);

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(allSuppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إدخال فاتورة يدوياً')),
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'أضف مورداً أولاً من شاشة الموردين قبل إدخال فاتورة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _buildHeader(suppliers),
              const SizedBox(height: 12),
              ..._lines.asMap().entries.map((e) => _buildLineCard(e.key)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => setState(() => _lines.add(_ManualLine())),
                icon: const Icon(Icons.add),
                label: const Text('إضافة بند'),
              ),
              const SizedBox(height: 12),
              _buildTotals(),
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
                label: const Text('حفظ الفاتورة'),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<SupplierEntity> suppliers) {
    final validSupplierId =
        suppliers.any((s) => s.id == _supplierId) ? _supplierId : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              initialValue: validSupplierId,
              decoration: const InputDecoration(labelText: AppStrings.supplier),
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
              controller: _invoiceNumberController,
              decoration:
                  const InputDecoration(labelText: 'رقم الفاتورة الورقية'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: AppStrings.invoiceDate,
                        suffixIcon: Icon(Icons.calendar_today, size: 18),
                      ),
                      child: Text(DateFormatter.display(_date)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'credit', label: Text(AppStrings.credit)),
                ButtonSegment(value: 'cash', label: Text(AppStrings.cash)),
                ButtonSegment(value: 'partial', label: Text(AppStrings.partial)),
              ],
              selected: {_paymentType},
              onSelectionChanged: (s) =>
                  setState(() => _paymentType = s.first),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineCard(int index) {
    final line = _lines[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'بند ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (_lines.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.priceUp,
                    ),
                    onPressed: () => setState(() {
                      _lines.removeAt(index).dispose();
                    }),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: line.nameController,
                    decoration:
                        const InputDecoration(labelText: AppStrings.itemName),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: line.unitController,
                    decoration:
                        const InputDecoration(labelText: AppStrings.unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: line.qtyController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: AppStrings.qty),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: line.freeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: AppStrings.freeQty),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: line.priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: AppStrings.unitPrice),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'الإجمالي: ${CurrencyFormatter.formatNumber(line.total)} ${AppStrings.currencySymbol}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotals() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _discountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: AppStrings.discount),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _extraController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: AppStrings.extraCharges,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (_paymentType == 'partial') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _paidController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'المبلغ المدفوع نقداً'),
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _printedBalanceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'الرصيد الحالي المطبوع في الفاتورة (اختياري للمطابقة)',
              ),
            ),
            const Divider(height: 20),
            _row(AppStrings.subtotal, _subtotal),
            _row(AppStrings.netTotal, _netTotal, bold: true),
            if (_paymentType != 'cash')
              _row('المتبقي (دين آجل للمورد)', _remainingDebt, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${CurrencyFormatter.formatNumber(value)} ${AppStrings.currencySymbol}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: bold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
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
    final validLines = _lines.where(
      (l) => l.nameController.text.trim().isNotEmpty && l.qty > 0,
    );
    if (validLines.isEmpty) {
      _snack('أضف بنداً واحداً على الأقل بكمية صحيحة');
      return;
    }

    setState(() => _saving = true);
    try {
      final lines = <InvoiceLineEntity>[];
      var i = 1;
      for (final l in validLines) {
        final rawName = l.nameController.text.trim();
        final parsed = _packParser(rawName);
        final qty = l.qty;
        final price = l.price;
        final lineTotal = l.total;
        final totalUnits = qty + l.free;
        final effective = totalUnits > 0 ? lineTotal / totalUnits : price;
        final singlePiece =
            (parsed.packSize != null && parsed.packSize! > 0)
                ? effective / parsed.packSize!
                : null;
        final unitName = l.unitController.text.trim().isEmpty
            ? 'كرتون'
            : l.unitController.text.trim();

        lines.add(
          InvoiceLineEntity(
            itemId: 0,
            lineNumber: i++,
            rawItemName: rawName,
            unitName: unitName,
            quantity: qty,
            freeQuantity: l.free,
            unitPrice: price,
            lineTotal: lineTotal,
            effectiveUnitCost: effective,
            singlePieceCost: singlePiece,
            extractedPackSize: parsed.packSize,
            extractedRetailPrice: parsed.retailPrice,
          ),
        );
      }

      final printedBalText = _printedBalanceController.text.trim();
      final printedCurrBalance = printedBalText.isEmpty
          ? null
          : _parseArabicDouble(printedBalText);

      final invoice = PurchaseInvoiceEntity(
        supplierId: _supplierId!,
        paperInvoiceNumber: _invoiceNumberController.text.trim().isEmpty
            ? 'يدوي-${DateTime.now().millisecondsSinceEpoch}'
            : _invoiceNumberController.text.trim(),
        invoiceDate: _date,
        paymentType: _paymentType,
        subtotal: _subtotal,
        discount: _discount,
        extraCharges: _extra,
        netTotal: _netTotal,
        paidAmount: _effectivePaid,
        remainingAmount: _remainingDebt,
        printedCurrBalance: printedCurrBalance,
        createdAt: DateTime.now(),
        lines: lines,
      );

      await ref.read(saveConfirmedInvoiceUseCaseProvider)(invoice);
      if (mounted) {
        _snack('تم حفظ الفاتورة بنجاح');
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
