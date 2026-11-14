import '../../../../core/services/arabic_text_normalizer.dart';

/// نتيجة تفكيك اسم الصنف المركب.
class ParsedItemName {
  const ParsedItemName({
    required this.cleanName,
    this.packSize,
    this.retailPrice,
  });

  final String cleanName;
  final int? packSize;
  final double? retailPrice;
}

/// استخراج (×30حبه) و(البيع 100ريال) من نص اسم الصنف.
///
/// القاعدة الثالثة: تفكيك اسم الصنف وحساب تكلفة الحبة الواحدة.
class ParseItemPackAndRetailUseCase {
  const ParseItemPackAndRetailUseCase();

  // عدد الحبات الصريح: "30 حبه"، "48 حبة"، "12 باكت"، "4 قطم".
  static final RegExp _packWithUnit = RegExp(
    r'(\d+)\s*(?:حبه|حبة|حبات|باكت|قطعه|قطعة|وحدات|قطم)',
    unicode: true,
  );

  // صيغة 48×100جم أو 24*400 جرام (الرقم الأول يمثل عدد الحبات في الكرتون).
  static final RegExp _packBeforeWeight = RegExp(
    r'(\d+)\s*[x×*]\s*\d+\s*(?:جم|جرام|غ|مل|لتر|كيلو)',
    unicode: true,
  );

  // صيغة ×30 أو x30 أو *30.
  static final RegExp _packWithX = RegExp(
    r'[x×*]\s*(\d+)',
    unicode: true,
  );

  // سعر البيع المقترح: "البيع 100 ريال" أو "(البيع) 100ريال" أو "البيع(50ريال)".
  static final RegExp _retail = RegExp(
    r'البيع\s*[\(\)\[\]]*\s*(\d+(?:[.,]\d+)?)',
    unicode: true,
  );

  ParsedItemName call(String rawName) {
    final normalizedDigits = _normalizeArabicDigits(rawName);

    final retailMatch = _retail.firstMatch(normalizedDigits);
    final retailPrice = retailMatch != null
        ? double.tryParse(retailMatch.group(1)!.replaceAll(',', '.'))
        : null;

    int? packSize;
    final packUnitMatch = _packWithUnit.firstMatch(normalizedDigits);
    if (packUnitMatch != null) {
      packSize = int.tryParse(packUnitMatch.group(1)!);
    }
    if (packSize == null) {
      final weightMatch = _packBeforeWeight.firstMatch(normalizedDigits);
      if (weightMatch != null) {
        packSize = int.tryParse(weightMatch.group(1)!);
      }
    }
    if (packSize == null) {
      final packXMatch = _packWithX.firstMatch(normalizedDigits);
      if (packXMatch != null) {
        final candidate = int.tryParse(packXMatch.group(1)!);
        if (candidate != null && candidate > 1 && candidate <= 500) {
          packSize = candidate;
        }
      }
    }

    return ParsedItemName(
      cleanName: _buildCleanName(normalizedDigits),
      packSize: (packSize != null && packSize > 0) ? packSize : null,
      retailPrice:
          (retailPrice != null && retailPrice > 0) ? retailPrice : null,
    );
  }

  String _buildCleanName(String rawName) {
    var name = rawName;
    // إزالة مقطع سعر البيع مثل "(البيع 100 ريال)" أو "( البيع ) 100ريال".
    name = name.replaceAll(
      RegExp(
        r'[\(\[]?\s*البيع\s*[\)\]]?\s*\d*\s*(?:ريال|ر\.?ي)?\s*[\)\]]?',
        unicode: true,
      ),
      ' ',
    );
    // إزالة الأقواس الفارغة والرموز الزائدة.
    name = name.replaceAll(RegExp(r'[\(\)\[\]]'), ' ');
    name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (name.isEmpty) {
      return ArabicTextNormalizer.normalize(rawName);
    }
    return name;
  }

  String _normalizeArabicDigits(String input) {
    var out = input;
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      out = out.replaceAll(arabicDigits[i], '$i');
    }
    return out;
  }
}
