import '../entities/supplier_price_offer_entity.dart';

/// صف مقارنة سعر مورّد مقابل أفضل سعر متاح.
class SupplierPriceComparison {
  const SupplierPriceComparison({
    required this.offer,
    required this.differenceFromBest,
    required this.percentageFromBest,
    required this.isBest,
    required this.isAboveAverage,
  });

  final SupplierPriceOfferEntity offer;

  /// الفرق المطلق عن أفضل سعر (موجب = أغلى).
  final double differenceFromBest;

  /// نسبة الزيادة عن أفضل سعر (٪).
  final double percentageFromBest;

  final bool isBest;
  final bool isAboveAverage;
}

/// نتيجة مقارنة أسعار صنف بين الموردين.
class SupplierPriceComparisonResult {
  const SupplierPriceComparisonResult({
    required this.itemId,
    required this.itemName,
    required this.rows,
    required this.bestPrice,
    required this.averagePrice,
    required this.worstPrice,
  });

  final int itemId;
  final String itemName;
  final List<SupplierPriceComparison> rows;
  final double bestPrice;
  final double averagePrice;
  final double worstPrice;

  bool get hasComparison => rows.length > 1;
  double get spread => worstPrice - bestPrice;
}

/// مقارنة أسعار صنف واحد بين كل الموردين وترتيبهم من الأرخص للأغلى.
class CompareSupplierPricesUseCase {
  const CompareSupplierPricesUseCase();

  SupplierPriceComparisonResult call({
    required int itemId,
    required String itemName,
    required List<SupplierPriceOfferEntity> offers,
  }) {
    if (offers.isEmpty) {
      return SupplierPriceComparisonResult(
        itemId: itemId,
        itemName: itemName,
        rows: const [],
        bestPrice: 0,
        averagePrice: 0,
        worstPrice: 0,
      );
    }

    final sorted = [...offers]..sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    final best = sorted.first.unitPrice;
    final worst = sorted.last.unitPrice;
    final sum = sorted.fold<double>(0, (acc, o) => acc + o.unitPrice);
    final average = sum / sorted.length;

    final rows = <SupplierPriceComparison>[];
    for (final offer in sorted) {
      final diff = offer.unitPrice - best;
      final pct = best == 0 ? 0.0 : (diff / best) * 100;
      rows.add(
        SupplierPriceComparison(
          offer: offer,
          differenceFromBest: diff,
          percentageFromBest: pct,
          isBest: diff.abs() < 0.0001,
          isAboveAverage: offer.unitPrice > average,
        ),
      );
    }

    return SupplierPriceComparisonResult(
      itemId: itemId,
      itemName: itemName,
      rows: rows,
      bestPrice: best,
      averagePrice: average,
      worstPrice: worst,
    );
  }
}
