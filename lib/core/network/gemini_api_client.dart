import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../constants/app_config.dart';
import '../constants/gemini_prompts.dart';
import '../errors/exceptions.dart';

/// إعداد الاتصال بـ Gemini 2.5 Flash Vision وإرجاع JSON خام ومنظف.
class GeminiApiClient {
  GeminiApiClient({String? apiKey})
      : _apiKey = (apiKey != null && apiKey.trim().isNotEmpty)
            ? apiKey.trim()
            : AppConfig.geminiApiKey.trim() {
    if (_apiKey.isNotEmpty) {
      _model = _buildModel(_apiKey);
    }
  }

  String _apiKey;
  GenerativeModel? _model;

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// تحديث مفتاح الـ API أثناء عمل التطبيق (من شاشة الإعدادات) دون الحاجة لإعادة البناء.
  void updateApiKey(String newApiKey) {
    _apiKey = newApiKey.trim();
    _model = _apiKey.isNotEmpty ? _buildModel(_apiKey) : null;
  }

  GenerativeModel _buildModel(String key) {
    return GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: key,
      systemInstruction: Content.system(GeminiPrompts.ocrSystemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.1,
      ),
    );
  }

  /// يرسل مجموعة صور (صفحات) ويعيد نص JSON منظفاً وجاهزاً للتحويل.
  Future<String> extractJsonFromImages(
    List<Uint8List> images, {
    String? extraInstruction,
  }) async {
    if (!hasApiKey || _model == null) {
      throw OcrException(
        'مفتاح Gemini API غير مضبوط. يرجى تمريره عبر --dart-define=GEMINI_API_KEY أو إدخاله من الإعدادات.',
      );
    }
    if (images.isEmpty) {
      throw OcrException('لا توجد صور لإرسالها إلى المحرك البصري.');
    }

    final instruction = extraInstruction ??
        (images.length > 1
            ? GeminiPrompts.multiPageInstruction
            : 'حلّل الوثيقة المرفقة وأرجع النتيجة بصيغة JSON فقط وفق المخطط المحدد.');

    final parts = <Part>[
      for (final image in images) DataPart('image/jpeg', image),
      TextPart(instruction),
    ];

    try {
      final response = await _model!.generateContent([
        Content.multi(parts),
      ]);
      final rawText = response.text;
      if (rawText == null || rawText.trim().isEmpty) {
        throw OcrException('لم يُرجع المحرك البصري أي محتوى.');
      }

      // تنظيف أي علامات Markdown قد يحيط بها النموذج نص الـ JSON
      final cleanedJson = rawText
          .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
          .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
          .replaceAll(RegExp(r'\s*```$', multiLine: true), '')
          .trim();

      return cleanedJson;
    } on GenerativeAIException catch (e) {
      throw OcrException('فشل الاتصال بـ Gemini: ${e.message}');
    } on OcrException {
      rethrow;
    } catch (e) {
      throw OcrException('خطأ غير متوقع أثناء التحليل البصري: $e');
    }
  }
}
