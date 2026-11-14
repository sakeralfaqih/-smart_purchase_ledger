import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../../../core/constants/gemini_prompts.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/gemini_api_client.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../models/ocr_document_dto.dart';

/// الاتصال المباشر بـ Gemini Vision وتحويل الرد إلى DTO.
class GeminiVisionRemoteDataSource {
  GeminiVisionRemoteDataSource(this._client);

  final GeminiApiClient _client;

  Future<OcrDocumentDto> extract(
    List<String> imagePaths, {
    DocType? hint,
  }) async {
    final images = <Uint8List>[];
    for (final path in imagePaths) {
      final file = File(path);
      if (!await file.exists()) {
        throw OcrException('صورة غير موجودة: $path');
      }
      images.add(await file.readAsBytes());
    }

    final instruction = hint == DocType.receiptVoucher
        ? 'الوثيقة سند قبض/سداد. ${GeminiPrompts.multiPageInstruction}'
        : GeminiPrompts.multiPageInstruction;

    final raw = await _client.extractJsonFromImages(
      images,
      extraInstruction: instruction,
    );

    final map = _decodeJson(raw);
    return OcrDocumentDto.fromJson(map);
  }

  Map<String, dynamic> _decodeJson(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
    }
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
      throw OcrException('صيغة JSON غير متوقعة من المحرك البصري.');
    } catch (e) {
      throw OcrException('تعذّر تحليل JSON القادم من Gemini: $e');
    }
  }
}
