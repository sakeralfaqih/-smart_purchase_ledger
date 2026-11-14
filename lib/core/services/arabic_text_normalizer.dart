/// تطبيع الحروف العربية وخوارزميات المطابقة الضبابية للأصناف.
class ArabicTextNormalizer {
  ArabicTextNormalizer._();

  static final RegExp _diacritics = RegExp(
    r'[\u064B-\u0652\u0670\u0640]',
  );

  /// تطبيع النص: توحيد الألف/الهمزة، التاء المربوطة، الياء، علامات الضرب (×/*)، وإزالة التشكيل.
  static String normalize(String input) {
    var text = input.trim();
    text = text.replaceAll(_diacritics, '');
    // توحيد الألف (أ إ آ ٱ) إلى ا
    text = text.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    // التاء المربوطة والهاء
    text = text.replaceAll(RegExp(r'[ة]'), 'ه');
    // الياء والألف المقصورة
    text = text.replaceAll(RegExp(r'[ى]'), 'ي');
    // الأرقام العربية/الهندية إلى لاتينية
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      text = text.replaceAll(arabicDigits[i], '$i');
    }
    // توحيد علامات الضرب في العبوات (مثل 4*4 أو 48×100جم) إلى حرف x قبل إزالة الرموز
    text = text.replaceAll(RegExp(r'[×\*]'), 'x');
    // إزالة الرموز والعلامات الأخرى، والإبقاء على الحروف والأرقام والمسافات
    text = text.replaceAll(RegExp(r'[^\u0600-\u06FF0-9a-zA-Z\s]'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
    return text;
  }

  /// مسافة ليفنشتاين (عدد التعديلات).
  static int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final prev = List<int>.generate(b.length + 1, (i) => i);
    final curr = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
        final insertion = curr[j] + 1;
        final deletion = prev[j + 1] + 1;
        final substitution = prev[j] + cost;
        curr[j + 1] = _min3(insertion, deletion, substitution);
      }
      prev.setAll(0, curr);
    }
    return prev[b.length];
  }

  static int _min3(int a, int b, int c) {
    final m = a < b ? a : b;
    return m < c ? m : c;
  }

  /// نسبة تشابه 0..1 بعد التطبيع.
  static double similarity(String a, String b) {
    final na = normalize(a);
    final nb = normalize(b);
    if (na.isEmpty && nb.isEmpty) return 1.0;
    if (na.isEmpty || nb.isEmpty) return 0.0;
    if (na == nb) return 1.0;
    final distance = levenshtein(na, nb);
    final maxLen = na.length > nb.length ? na.length : nb.length;
    return 1.0 - (distance / maxLen);
  }

  /// أفضل مطابقة من قائمة مرشحين.
  static MatchResult? bestMatch(
    String query,
    List<String> candidates, {
    double threshold = 0.72,
  }) {
    MatchResult? best;
    for (var i = 0; i < candidates.length; i++) {
      final score = similarity(query, candidates[i]);
      if (best == null || score > best.score) {
        best = MatchResult(index: i, candidate: candidates[i], score: score);
      }
    }
    if (best == null || best.score < threshold) return null;
    return best;
  }
}

class MatchResult {
  MatchResult({
    required this.index,
    required this.candidate,
    required this.score,
  });
  final int index;
  final String candidate;
  final double score;

  bool get isConfident => score >= 0.9;
}
