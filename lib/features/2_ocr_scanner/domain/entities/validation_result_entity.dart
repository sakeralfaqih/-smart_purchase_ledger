/// نتيجة التحقق الرياضي لسطر واحد.
class LineValidation {
  const LineValidation({
    required this.lineIndex,
    required this.lineMathOk,
    required this.qtyWordsMatch,
    this.suggestedQty,
    this.message,
    this.needsReview = false,
  });

  final int lineIndex;
  final bool lineMathOk;
  final bool qtyWordsMatch;
  final double? suggestedQty;
  final String? message;
  final bool needsReview;

  bool get isOk => lineMathOk && qtyWordsMatch && !needsReview;
}

/// نتيجة التدقيق الرياضي الثلاثي الكاملة.
class ValidationResult {
  const ValidationResult({
    required this.lineResults,
    required this.totalPiecesOk,
    required this.netTotalOk,
    this.computedSubtotal = 0.0,
    this.computedNetTotal = 0.0,
    this.warnings = const [],
  });

  final List<LineValidation> lineResults;
  final bool totalPiecesOk;
  final bool netTotalOk;
  final double computedSubtotal;
  final double computedNetTotal;
  final List<String> warnings;

  bool get allLinesOk => lineResults.every((l) => l.isOk);
  bool get hasAnyWarning =>
      !allLinesOk || !totalPiecesOk || !netTotalOk || warnings.isNotEmpty;

  int get reviewCount => lineResults.where((l) => l.needsReview).length;
}
