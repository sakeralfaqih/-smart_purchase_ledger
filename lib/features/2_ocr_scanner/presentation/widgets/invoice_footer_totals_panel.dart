import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../../domain/entities/validation_result_entity.dart';

/// لوحة الإجماليات والتحقق الرياضي والأرصدة المطبوعة في أسفل شاشة المراجعة.
class InvoiceFooterTotalsPanel extends StatelessWidget {
  const InvoiceFooterTotalsPanel({
    super.key,
    required this.financial,
    required this.validation,
    required this.paymentStatus,
    required this.onFinancialChanged,
    required this.onPaymentStatusChanged,
    this.paidAmount = 0.0,
    this.onPaidAmountChanged,
  });

  final FinancialSummary financial;
  final ValidationResult? validation;
  final PaymentStatus paymentStatus;
  final ValueChanged<FinancialSummary> onFinancialChanged;
  final ValueChanged<PaymentStatus> onPaymentStatusChanged;
  final double paidAmount;
  final ValueChanged<double>? onPaidAmountChanged;

  @override
  Widget build(BuildContext context) {
    final effectivePaid = switch (paymentStatus) {
      PaymentStatus.cash => financial.netTotal,
      PaymentStatus.credit => 0.0,
      PaymentStatus.partial => paidAmount.clamp(0.0, financial.netTotal),
    };
    final remainingDebt = (financial.netTotal - effectivePaid).clamp(
      0.0,
      double.infinity,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _SyncedFooterNumField(
                  label: 'الخصم',
                  value: financial.discount,
                  onChanged: (v) => onFinancialChanged(
                    financial.copyWith(discount: v),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SyncedFooterNumField(
                  label: 'أعباء إضافية',
                  value: financial.extraCharges,
                  onChanged: (v) => onFinancialChanged(
                    financial.copyWith(extraCharges: v),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SyncedFooterNumField(
                  label: 'الرصيد الحالي المطبوع',
                  value: financial.printedCurrentBalance ?? 0.0,
                  onChanged: (v) => onFinancialChanged(
                    financial.copyWith(printedCurrentBalance: v),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedButton<PaymentStatus>(
            segments: const [
              ButtonSegment(value: PaymentStatus.credit, label: Text('آجل')),
              ButtonSegment(value: PaymentStatus.cash, label: Text('نقدي')),
              ButtonSegment(value: PaymentStatus.partial, label: Text('جزئي')),
            ],
            selected: {paymentStatus},
            onSelectionChanged: (s) => onPaymentStatusChanged(s.first),
          ),
          if (paymentStatus == PaymentStatus.partial) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _SyncedFooterNumField(
                    label: 'المبلغ المدفوع نقداً الآن',
                    value: paidAmount,
                    onChanged: (v) => onPaidAmountChanged?.call(v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'المتبقي آجل: ${CurrencyFormatter.formatNumber(remainingDebt)} ريال',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.balanceMismatch,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          _TotalRow(label: 'الإجمالي قبل الخصم', value: financial.subtotal),
          _TotalRow(
            label: 'الصافي النهائي',
            value: financial.netTotal,
            emphasize: true,
          ),
          if (paymentStatus != PaymentStatus.partial)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Text(
                    paymentStatus == PaymentStatus.cash
                        ? 'حالة السداد: مسددة نقداً بالكامل'
                        : 'المبلغ المرحّل لحساب المورد (دين آجل):',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (paymentStatus == PaymentStatus.credit)
                    Text(
                      '${CurrencyFormatter.formatNumber(remainingDebt)} ريال',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.balanceMismatch,
                      ),
                    ),
                ],
              ),
            ),
          if (validation != null && validation!.hasAnyWarning)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.reviewYellowBorder,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      validation!.warnings.join(' • '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: emphasize ? 15 : 13,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            '${CurrencyFormatter.formatNumber(value)} ريال',
            style: TextStyle(
              fontSize: emphasize ? 17 : 13,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
              color: emphasize ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncedFooterNumField extends StatefulWidget {
  const _SyncedFooterNumField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_SyncedFooterNumField> createState() => _SyncedFooterNumFieldState();
}

class _SyncedFooterNumFieldState extends State<_SyncedFooterNumField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  static String _formatValue(double v) {
    if (v == 0) return '';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
  }

  static double _parseArabicDouble(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var normalized = input.trim().replaceAll(',', '');
    for (var i = 0; i < arabicDigits.length; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], i.toString());
    }
    return double.tryParse(normalized) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _SyncedFooterNumField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) {
      final currentParsed = _parseArabicDouble(_controller.text);
      if ((currentParsed - widget.value).abs() > 0.005) {
        _controller.text = _formatValue(widget.value);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (v) => widget.onChanged(_parseArabicDouble(v)),
    );
  }
}
