import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/entities/extracted_document_entity.dart';
import 'screens/split_screen_ocr_review_screen.dart';

/// يفتح الماسح الضوئي، يضغط الصور، ثم ينتقل إلى شاشة المراجعة.
class OcrLauncher {
  OcrLauncher._();

  static Future<void> scanAndReview(
    BuildContext context,
    WidgetRef ref, {
    required DocType hint,
  }) async {
    final scanner = ref.read(documentScannerServiceProvider);
    final compressor = ref.read(imageCompressionServiceProvider);

    List<String> rawPaths;
    try {
      // فتح كاميرا الماسح الضوئي أولاً دون نافذة تحميل خلفية تعيق الإغلاق
      rawPaths = await scanner.scanDocument(
        pageLimit: hint == DocType.purchaseInvoice ? 10 : 2,
      );
    } on OcrException catch (e) {
      // إذا ألغى المستخدم التصوير (لم يلتقط أي صفحة)، نخرج بهدوء دون رسالة خطأ
      if (e.message.contains('لم يتم التقاط')) {
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
      return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.retry}: $e')),
        );
      }
      return;
    }

    if (rawPaths.isEmpty || !context.mounted) return;

    // عرض مؤشر التحميل فقط أثناء ضغط الصور وحفظها في الأرشيف
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final compressed = await compressor.compressAll(rawPaths);
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SplitScreenOcrReviewScreen(
            imagePaths: compressed,
            hint: hint,
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.retry}: $e')),
        );
      }
    }
  }
}
