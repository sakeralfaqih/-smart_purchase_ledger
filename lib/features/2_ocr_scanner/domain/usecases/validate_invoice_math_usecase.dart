import '../../../../core/services/arabic_text_normalizer.dart';
import '../entities/extracted_document_entity.dart';
import '../entities/validation_result_entity.dart';

/// نتيجة التحقق مع الوثيقة المصححة.
class ValidationOutcome {
  const ValidationOutcome({required this.document, required this.result});
  final ExtractedDocument document;
  final ValidationResult result;
}

/// القاعدة الثانية: التدقيق الرياضي الثلاثي ضد الأختام وشطب القلم.
///
/// 1) معادلة السطر: الكمية × سعر الوحدة == إجمالي السطر.
/// 2) معادلة إجمالي القطع: مجموع الكميات == عدد القطع المطبوع.
/// 3) معادلة صافي الفاتورة: الإجمالي - الخصم + الأعباء == الصافي.
class ValidateInvoiceMathUseCase {
  const ValidateInvoiceMathUseCase();

  static const double _absTol = 0.5;

  bool _approx(double a, double b) {
    final diff = (a - b).abs();
    final scale = (a.abs() > b.abs() ? a.abs() : b.abs()) * 0.001;
    return diff <= (_absTol + scale);
  }

  ValidationOutcome call(ExtractedDocument document) {
    if (document.docType == DocType.receiptVoucher) {
      return ValidationOutcome(
        document: document,
        result: ValidationResult(
          lineResults: const [],
          totalPiecesOk: true,
          netTotalOk: true,
          computedSubtotal: document.financial.subtotal,
          computedNetTotal: document.financial.netTotal,
          warnings: const [],
        ),
      );
    }

    final lineResults = <LineValidation>[];
    final correctedLines = <ExtractedLineItem>[];
    final warnings = <String>[];
    var computedSubtotal = 0.0;

    for (var i = 0; i < document.lineItems.length; i++) {
      final line = document.lineItems[i];
      final expected = line.qtyNum * line.unitPrice;
      final lineMathOk = _approx(expected, line.lineTotal);
      final parsedWords = parseArabicQuantity(line.qtyWords);

      double effectiveQty = line.qtyNum;
      double? suggestedQty;
      var needsReview = line.needsReview;

      if (!lineMathOk && line.unitPrice > 0 && line.lineTotal > 0) {
        suggestedQty = line.lineTotal / line.unitPrice;
        final isCleanHalfOrInt =
            ((suggestedQty * 2) - (suggestedQty * 2).round()).abs() < 0.02;

        // إذا طابقت الكمية المستنتجة من القسمة عمود "الكمية كتابةً" أو كانت رقماً صحيحاً/نصفاً
        if ((parsedWords != null && _approx(suggestedQty, parsedWords)) ||
            isCleanHalfOrInt) {
          effectiveQty = double.parse(suggestedQty.toStringAsFixed(2));
        }
        needsReview = true;
        warnings.add(
          'السطر ${line.lineNo}: تعارض بين الكمية×السعر والإجمالي — '
          'الكمية المستنتجة ${suggestedQty.toStringAsFixed(2)}',
        );
      }

      var qtyWordsMatch = true;
      if (parsedWords != null) {
        qtyWordsMatch = _approx(parsedWords, effectiveQty);
        if (!qtyWordsMatch) {
          needsReview = true;
          warnings.add(
            'السطر ${line.lineNo}: الكمية كتابةً (${line.qtyWords}) '
            'لا تطابق الكمية رقماً (${effectiveQty.toStringAsFixed(2)}).',
          );
        }
      }

      if (!lineMathOk || !qtyWordsMatch) {
        needsReview = true;
      }

      final totalUnits = effectiveQty + line.freeQty;
      final effectiveUnitCost =
          totalUnits > 0 ? line.lineTotal / totalUnits : line.unitPrice;
      final singlePieceCost =
          (line.extractedPackSize != null && line.extractedPackSize! > 0)
              ? effectiveUnitCost / line.extractedPackSize!
              : line.singlePieceCost;

      final corrected = line.copyWith(
        qtyNum: effectiveQty,
        effectiveUnitCost: effectiveUnitCost,
        singlePieceCost: singlePieceCost,
        mathVerified: lineMathOk,
        needsReview: needsReview,
      );
      correctedLines.add(corrected);
      computedSubtotal += corrected.lineTotal;

      lineResults.add(
        LineValidation(
          lineIndex: i,
          lineMathOk: lineMathOk,
          qtyWordsMatch: qtyWordsMatch,
          suggestedQty: suggestedQty,
          needsReview: needsReview,
          message: !lineMathOk
              ? 'تعارض رياضي: الكمية × السعر ≠ الإجمالي'
              : (!qtyWordsMatch ? 'الكمية كتابةً لا تطابق رقماً' : null),
        ),
      );
    }

    // 2) معادلة إجمالي القطع.
    var totalPiecesOk = true;
    final printedPieces = document.financial.totalPiecesCount;
    if (printedPieces != null && printedPieces > 0) {
      final sumQty = correctedLines.fold<double>(0.0, (s, l) => s + l.qtyNum);
      totalPiecesOk = _approx(sumQty, printedPieces);
      if (!totalPiecesOk) {
        warnings.add(
          'مجموع الكميات (${sumQty.toStringAsFixed(0)}) لا يطابق عدد القطع المطبوع (${printedPieces.toStringAsFixed(0)}).',
        );
      }
    }

    // 3) معادلة صافي الفاتورة.
    final computedNet = computedSubtotal -
        document.financial.discount +
        document.financial.extraCharges;
    var netTotalOk = true;
    if (document.financial.netTotal > 0) {
      netTotalOk = _approx(computedNet, document.financial.netTotal);
      if (!netTotalOk) {
        warnings.add(
          'الصافي المحسوب (${computedNet.toStringAsFixed(2)}) '
          'لا يطابق الصافي المطبوع (${document.financial.netTotal.toStringAsFixed(2)}).',
        );
      }
    }

    final correctedDoc = document.copyWith(lineItems: correctedLines);
    final result = ValidationResult(
      lineResults: lineResults,
      totalPiecesOk: totalPiecesOk,
      netTotalOk: netTotalOk,
      computedSubtotal: computedSubtotal,
      computedNetTotal: computedNet,
      warnings: warnings,
    );

    return ValidationOutcome(document: correctedDoc, result: result);
  }

  /// تحويل الكمية المكتوبة بالعربية إلى رقم بدقة (يدعم الأعداد المركبة 11-19 والعشرات 20-90 والعطف).
  static double? parseArabicQuantity(String? words) {
    if (words == null || words.trim().isEmpty) return null;
    var normalized = ArabicTextNormalizer.normalize(words);
    if (normalized.isEmpty) return null;

    // 1. إن وُجد رقم صريح داخل النص.
    final digitMatch = RegExp(r'\d+(?:\.\d+)?').firstMatch(normalized);
    if (digitMatch != null) {
      return double.tryParse(digitMatch.group(0)!);
    }

    // 2. فحص حالات المثنى الملتصق بالوحدة قبل حذف اسم الوحدة
    if (normalized.contains('كرتونين') ||
        normalized.contains('باكتين') ||
        normalized.contains('دبتين') ||
        normalized.contains('كيسين') ||
        normalized.contains('تنكتين')) {
      return 2.0;
    }

    // 3. فصل أسماء الوحدات الملتصقة (مثل "واحدكرتون" -> "واحد")
    normalized = normalized
        .replaceAll('كرتون', ' ')
        .replaceAll('باكت', ' ')
        .replaceAll('بواكت', ' ')
        .replaceAll('دبه', ' ')
        .replaceAll('كيس', ' ')
        .replaceAll('تنكه', ' ')
        .replaceAll('قطم', ' ')
        .replaceAll('حبه', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) return null;

    // 4. فحص الأعداد المركبة (11 إلى 19) أولاً قبل فحص المفردات!
    const teens = {
      'احد عشر': 11.0,
      'احدعشر': 11.0,
      'احدي عشر': 11.0,
      'اثنا عشر': 12.0,
      'اثناعشر': 12.0,
      'اثني عشر': 12.0,
      'اثنيعشر': 12.0,
      'درزن': 12.0,
      'ثلاثه عشر': 13.0,
      'ثلاث عشر': 13.0,
      'اربعه عشر': 14.0,
      'اربع عشر': 14.0,
      'خمسه عشر': 15.0,
      'خمس عشر': 15.0,
      'سته عشر': 16.0,
      'ست عشر': 16.0,
      'سبعه عشر': 17.0,
      'سبع عشر': 17.0,
      'ثمانيه عشر': 18.0,
      'ثماني عشر': 18.0,
      'تسعه عشر': 19.0,
      'تسع عشر': 19.0,
    };

    for (final entry in teens.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    // 5. تفكيك الكلمات لحساب الأعداد المفردة والعشرات والأعداد المعطوفة (مثل "خمسه و عشرون" = 25)
    const tokenValues = {
      'نصف': 0.5,
      'نص': 0.5,
      'واحد': 1.0,
      'واحده': 1.0,
      'اثنان': 2.0,
      'اثنين': 2.0,
      'اثنتان': 2.0,
      'اثنتين': 2.0,
      'ثلاثه': 3.0,
      'ثلاث': 3.0,
      'اربعه': 4.0,
      'اربع': 4.0,
      'خمسه': 5.0,
      'خمس': 5.0,
      'سته': 6.0,
      'ست': 6.0,
      'سبعه': 7.0,
      'سبع': 7.0,
      'ثمانيه': 8.0,
      'ثماني': 8.0,
      'ثمان': 8.0,
      'تسعه': 9.0,
      'تسع': 9.0,
      'عشره': 10.0,
      'عشر': 10.0,
      'عشرون': 20.0,
      'عشرين': 20.0,
      'ثلاثون': 30.0,
      'ثلاثين': 30.0,
      'اربعون': 40.0,
      'اربعين': 40.0,
      'خمسون': 50.0,
      'خمسين': 50.0,
      'ستون': 60.0,
      'ستين': 60.0,
      'سبعون': 70.0,
      'سبعين': 70.0,
      'ثمانون': 80.0,
      'ثمانين': 80.0,
      'تسعون': 90.0,
      'تسعين': 90.0,
      'مئه': 100.0,
      'مائه': 100.0,
      'مئتان': 200.0,
      'مائتين': 200.0,
    };

    final tokens = normalized.split(' ');
    var sum = 0.0;
    var matchedAny = false;

    for (var token in tokens) {
      if (token == 'و' || token.isEmpty) continue;
      if (token.startsWith('و') &&
          token.length > 2 &&
          tokenValues.containsKey(token.substring(1))) {
        token = token.substring(1);
      }
      final val = tokenValues[token];
      if (val != null) {
        sum += val;
        matchedAny = true;
      }
    }

    return matchedAny && sum > 0 ? sum : null;
  }
}
