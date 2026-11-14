import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../providers/ocr_review_controller.dart';
import '../widgets/editable_ocr_line_item_row.dart';
import '../widgets/interactive_invoice_image_viewer.dart';
import '../widgets/invoice_footer_totals_panel.dart';

/// شاشة المراجعة المنقسمة: 40% عارض الصورة / 60% النموذج القابل للتعديل.
class SplitScreenOcrReviewScreen extends ConsumerStatefulWidget {
  const SplitScreenOcrReviewScreen({
    super.key,
    required this.imagePaths,
    required this.hint,
  });

  final List<String> imagePaths;
  final DocType hint;

  @override
  ConsumerState<SplitScreenOcrReviewScreen> createState() =>
      _SplitScreenOcrReviewScreenState();
}

class _SplitScreenOcrReviewScreenState
    extends ConsumerState<SplitScreenOcrReviewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ocrReviewControllerProvider.notifier).start(
            imagePaths: widget.imagePaths,
            hint: widget.hint,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ocrReviewControllerProvider);
    final controller = ref.read(ocrReviewControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reviewTitle),
        actions: [
          if (state.isReady && !state.isVoucher)
            IconButton(
              tooltip: 'إضافة صنف يدوياً',
              onPressed: state.isSaving ? null : () => controller.addLine(),
              icon: const Icon(Icons.playlist_add),
            ),
          if (state.isReady)
            IconButton(
              tooltip: AppStrings.confirm,
              onPressed: state.isSaving ? null : () => _save(controller),
              icon: state.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
            ),
        ],
      ),
      body: _buildBody(state, controller),
    );
  }

  Widget _buildBody(OcrReviewState state, OcrReviewController controller) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('جارٍ تحليل الصور بواسطة الذكاء الاصطناعي...'),
          ],
        ),
      );
    }
    if (state.error != null && state.document == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.balanceMismatch,
                size: 56,
              ),
              const SizedBox(height: 12),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.start(
                      imagePaths: widget.imagePaths,
                      hint: widget.hint,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retry),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final doc = state.document;
    if (doc == null) return const SizedBox.shrink();

    final isWide = MediaQuery.of(context).size.width > 900;
    final imagePane = InteractiveInvoiceImageViewer(
      imagePaths: widget.imagePaths,
    );
    final formPane = _buildForm(doc, state, controller);

    if (isWide) {
      return Row(
        children: [
          Expanded(flex: 40, child: imagePane),
          Expanded(flex: 60, child: formPane),
        ],
      );
    }
    return Column(
      children: [
        Expanded(flex: 40, child: imagePane),
        Expanded(flex: 60, child: formPane),
      ],
    );
  }

  Widget _buildForm(
    ExtractedDocument doc,
    OcrReviewState state,
    OcrReviewController controller,
  ) {
    final isVoucher = doc.docType == DocType.receiptVoucher;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _HeaderCard(
            document: doc,
            onSupplierNameChanged: (name) => controller.updateHeader(
              supplier: doc.supplier.copyWith(name: name),
            ),
            onPaperNumberChanged: (v) =>
                controller.updateHeader(paperNumber: v),
            onDateChanged: (d) => controller.updateHeader(date: d),
            onDocTypeChanged: (t) => controller.updateHeader(docType: t),
          ),
          Expanded(
            child: isVoucher
                ? _VoucherPanel(
                    document: doc,
                    onVoucherChanged: ({
                      double? amount,
                      String? amountWords,
                      String? statementNote,
                      double? printedRemainingBalance,
                    }) =>
                        controller.updateVoucherDetails(
                      amount: amount,
                      amountWords: amountWords,
                      statementNote: statementNote,
                      printedRemainingBalance: printedRemainingBalance,
                    ),
                  )
                : ListView.builder(
                    itemCount: doc.lineItems.length,
                    itemBuilder: (context, i) => EditableOcrLineItemRow(
                      key: ValueKey<int>(doc.lineItems[i].lineNo),
                      line: doc.lineItems[i],
                      index: i,
                      onChanged: (line) => controller.updateLine(i, line),
                      onDelete: doc.lineItems.length > 1
                          ? () => controller.removeLine(i)
                          : null,
                    ),
                  ),
          ),
          if (!isVoucher)
            InvoiceFooterTotalsPanel(
              financial: doc.financial,
              validation: state.validation,
              paymentStatus: doc.paymentStatus,
              paidAmount: state.paidAmount,
              onFinancialChanged: controller.updateFinancial,
              onPaymentStatusChanged: (s) =>
                  controller.updateHeader(paymentStatus: s),
              onPaidAmountChanged: controller.setPaidAmount,
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isSaving ? null : () => _save(controller),
                  icon: const Icon(Icons.save),
                  label: Text(
                    isVoucher
                        ? 'اعتماد سند القبض وخصمه من المديونية'
                        : 'اعتماد الفاتورة وتحديث الأسعار',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save(OcrReviewController controller) async {
    final id = await controller.save();
    if (!mounted) return;
    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ بنجاح')),
      );
      Navigator.of(context).pop(true);
    } else {
      final err = ref.read(ocrReviewControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err ?? 'فشل الحفظ')),
      );
    }
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.document,
    required this.onSupplierNameChanged,
    required this.onPaperNumberChanged,
    required this.onDateChanged,
    required this.onDocTypeChanged,
  });

  final ExtractedDocument document;
  final ValueChanged<String> onSupplierNameChanged;
  final ValueChanged<String> onPaperNumberChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DocType> onDocTypeChanged;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: document.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVoucher = document.docType == DocType.receiptVoucher;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: document.supplier.name,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'اسم المورد',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    onChanged: onSupplierNameChanged,
                  ),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: Icon(
                    isVoucher ? Icons.receipt_long : Icons.shopping_cart,
                    size: 16,
                  ),
                  label: Text(
                    isVoucher ? 'سند قبض' : 'فاتورة مشتريات',
                    style: const TextStyle(fontSize: 11),
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onDocTypeChanged(
                    isVoucher
                        ? DocType.purchaseInvoice
                        : DocType.receiptVoucher,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: document.paperNumber,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'رقم الورقة',
                    ),
                    onChanged: onPaperNumberChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'التاريخ',
                        suffixIcon: Icon(Icons.calendar_today, size: 16),
                      ),
                      child: Text(DateFormatter.formatDate(document.date)),
                    ),
                  ),
                ),
              ],
            ),
            if (document.supplier.analyticCode != null &&
                document.supplier.analyticCode!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'الرقم التحليلي لدى المورد: ${document.supplier.analyticCode}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VoucherPanel extends StatelessWidget {
  const _VoucherPanel({
    required this.document,
    required this.onVoucherChanged,
  });

  final ExtractedDocument document;
  final void Function({
    double? amount,
    String? amountWords,
    String? statementNote,
    double? printedRemainingBalance,
  }) onVoucherChanged;

  static double _parseNum(String v) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var s = v.trim().replaceAll(',', '');
    for (var i = 0; i < arabicDigits.length; i++) {
      s = s.replaceAll(arabicDigits[i], i.toString());
    }
    return double.tryParse(s) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final v = document.voucherDetails;
    final currentAmount = (v?.amount ?? 0) > 0
        ? v!.amount
        : document.financial.netTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.payments_outlined, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'بيانات سند القبض / السداد (قابلة للتعديل)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue:
                    currentAmount > 0 ? currentAmount.toStringAsFixed(0) : '',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                decoration: const InputDecoration(
                  labelText: 'المبلغ المسدد رقماً (ريال)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                onChanged: (val) => onVoucherChanged(amount: _parseNum(val)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: v?.amountWords ?? '',
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'المبلغ كتابةً (كما في السند)',
                ),
                onChanged: (val) => onVoucherChanged(amountWords: val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: v?.statementNote ?? '',
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'البيان (مثال: لكم نقداً من الحساب)',
                ),
                onChanged: (val) => onVoucherChanged(statementNote: val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: document.financial.printedCurrentBalance != null
                    ? document.financial.printedCurrentBalance.toString()
                    : '',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'الرصيد المتبقي المطبوع في أسفل السند (إن وجد)',
                ),
                onChanged: (val) => onVoucherChanged(
                  printedRemainingBalance: _parseNum(val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
