/// نتيجة حساب تكلفة الوحدة بعد احتساب الكميات المجانية/البونص.
class UnitCostBreakdown {
  const UnitCostBreakdown({
    required this.quantity,
    required this.freeQuantity,
    required this.lineTotal,
    required this.packUnitsCount,
    required this.effectiveLargeUnitCost,
    required this.singlePieceCost,
    required this.bonusUnits,
    required this.bonusValue,
  });

  final double quantity;
  final double freeQuantity;
  final double lineTotal;
  final int packUnitsCount;

  /// تكلفة الوحدة الكبيرة الفعلية بعد البونص = إجمالي السطر ÷ (الكمية + المجاني).
  final double effectiveLargeUnitCost;

  /// تكلفة الحبة الواحدة = تكلفة الوحدة الكبيرة ÷ عدد الحبات في الكرتون.
  final double singlePieceCost;

  /// عدد الوحدات المجانية الإضافية.
  final double bonusUnits;

  /// القيمة المالية للبونص (كم كانت ستكلّف لو اشتُريت).
  final double bonusValue;

  bool get hasBonus => freeQuantity > 0;
}

/// حساب تكلفة الحبة الواحدة مع مراعاة الكميات المجانية (البونص).
///
/// القاعدة: تكلفة الوحدة الكبيرة الفعلية = إجمالي قيمة السطر ÷ (الكمية المشتراة + الكمية المجانية).
/// ثم تكلفة الحبة = تكلفة الوحدة الكبيرة الفعلية ÷ عدد الحبات داخل الكرتون.
class CalculateUnitCostUseCase {
  const CalculateUnitCostUseCase();

  UnitCostBreakdown call({
    required double quantity,
    required double lineTotal,
    int packUnitsCount = 1,
    double freeQuantity = 0,
  }) {
    final safePack = packUnitsCount <= 0 ? 1 : packUnitsCount;
    final paidUnits = quantity <= 0 ? 1 : quantity;
    final totalUnits = paidUnits + (freeQuantity < 0 ? 0 : freeQuantity);
    final effectiveLargeUnitCost = lineTotal / totalUnits;
    final singlePieceCost = effectiveLargeUnitCost / safePack;
    final bonusUnits = freeQuantity < 0 ? 0 : freeQuantity;
    final bonusValue = bonusUnits * effectiveLargeUnitCost;
    return UnitCostBreakdown(
      quantity: quantity,
      freeQuantity: freeQuantity,
      lineTotal: lineTotal,
      packUnitsCount: safePack,
      effectiveLargeUnitCost: effectiveLargeUnitCost,
      singlePieceCost: singlePieceCost,
      bonusUnits: bonusUnits,
      bonusValue: bonusValue,
    );
  }
}
