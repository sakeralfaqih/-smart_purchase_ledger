import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/price_change_badge.dart';
import '../../domain/entities/extracted_document_entity.dart';

/// صف صنف قابل للتعديل مع تلوين أصفر عند الحاجة للمراجعة وتحديث تلقائي للإجمالي.
class EditableOcrLineItemRow extends StatelessWidget {
  const EditableOcrLineItemRow({
    super.key,
    required this.line,
    required this.index,
    required this.onChanged,
    this.onDelete,
  });

  final ExtractedLineItem line;
  final int index;
  final ValueChanged<ExtractedLineItem> onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final highlight = line.needsReview || !line.mathVerified;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight ? AppColors.reviewYellow : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.reviewYellowBorder : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: _SyncedTextField(
                  label: 'اسم الصنف',
                  value: line.cleanItemName.isNotEmpty
                      ? line.cleanItemName
                      : line.rawName,
                  onChanged: (v) => onChanged(
                    line.copyWith(cleanItemName: v, rawName: v),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 1,
                child: _SyncedTextField(
                  label: 'الوحدة',
                  value: line.unit,
                  onChanged: (v) => onChanged(line.copyWith(unit: v)),
                ),
              ),
              if (line.supplierItemCode != null &&
                  line.supplierItemCode!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Chip(
                    label: Text(
                      line.supplierItemCode!,
                      style: const TextStyle(fontSize: 10),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'حذف السطر',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.balanceMismatch,
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
          if (line.qtyWords != null && line.qtyWords!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 34),
              child: Text(
                'الكمية كتابةً بالفاتورة: ${line.qtyWords}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SyncedNumField(
                  label: 'الكمية',
                  value: line.qtyNum,
                  onChanged: (v) {
                    final newTotal =
                        line.unitPrice > 0 ? v * line.unitPrice : line.lineTotal;
                    onChanged(line.copyWith(qtyNum: v, lineTotal: newTotal));
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SyncedNumField(
                  label: 'مجانية',
                  value: line.freeQty,
                  onChanged: (v) => onChanged(line.copyWith(freeQty: v)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SyncedNumField(
                  label: 'سعر الوحدة',
                  value: line.unitPrice,
                  onChanged: (v) {
                    final newTotal =
                        line.qtyNum > 0 ? line.qtyNum * v : line.lineTotal;
                    onChanged(line.copyWith(unitPrice: v, lineTotal: newTotal));
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SyncedNumField(
                  label: 'الإجمالي',
                  value: line.lineTotal,
                  onChanged: (v) => onChanged(line.copyWith(lineTotal: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (line.singlePieceCost != null && line.singlePieceCost! > 0)
                Text(
                  'تكلفة الحبة: ${CurrencyFormatter.formatNumber(line.singlePieceCost!)} ريال',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              if (line.extractedPackSize != null && line.extractedPackSize! > 0)
                Text(
                  'الشد: ${line.extractedPackSize} حبة',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (line.extractedRetailPrice != null &&
                  line.extractedRetailPrice! > 0)
                Text(
                  'البيع المقترح: ${CurrencyFormatter.formatNumber(line.extractedRetailPrice!)} ريال',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (line.previousUnitPrice != null)
                PriceChangeBadge(
                  previousPrice: line.previousUnitPrice!,
                  currentPrice: line.unitPrice,
                ),
              if (highlight)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: AppColors.reviewYellowBorder,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'يحتاج مراجعة',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.reviewYellowBorder,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SyncedTextField extends StatefulWidget {
  const _SyncedTextField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<_SyncedTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _SyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
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
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: widget.onChanged,
    );
  }
}

class _SyncedNumField extends StatefulWidget {
  const _SyncedNumField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_SyncedNumField> createState() => _SyncedNumFieldState();
}

class _SyncedNumFieldState extends State<_SyncedNumField> {
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
  void didUpdateWidget(covariant _SyncedNumField oldWidget) {
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
