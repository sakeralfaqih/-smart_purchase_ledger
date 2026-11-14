import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../../domain/repositories/ocr_scanner_repository.dart';
import '../datasources/gemini_vision_remote_datasource.dart';
import '../datasources/offline_ocr_queue_local_datasource.dart';

class OcrScannerRepositoryImpl implements OcrScannerRepository {
  OcrScannerRepositoryImpl(
    this._remote,
    this._queue,
    this._network,
  );

  final GeminiVisionRemoteDataSource _remote;
  final OfflineOcrQueueLocalDataSource _queue;
  final NetworkInfo _network;

  @override
  Future<ExtractedDocument> extractDocument({
    required List<String> imagePaths,
    DocType? hint,
  }) async {
    if (!await _network.isConnected) {
      throw NetworkException(
        'لا يوجد اتصال بالإنترنت — تم حفظ الصور في طابور الانتظار.',
      );
    }
    final dto = await _remote.extract(imagePaths, hint: hint);
    return dto.toEntity(imagePaths: imagePaths);
  }

  @override
  Future<void> enqueueForOffline({
    required List<String> imagePaths,
    DocType? hint,
  }) =>
      _queue.enqueue(imagePaths, hint: hint?.name);

  @override
  Future<int> pendingCount() => _queue.count();

  @override
  Future<List<String>> processPendingQueue() async {
    final items = await _queue.list();
    final processed = <String>[];
    for (var i = items.length - 1; i >= 0; i--) {
      final item = items[i];
      try {
        if (!await _network.isConnected) break;
        await _remote.extract(
          item.imagePaths,
          hint: _hintFromString(item.hint),
        );
        processed.addAll(item.imagePaths);
        await _queue.removeAt(i);
      } catch (_) {
        // يبقى في الطابور للمحاولة لاحقاً.
      }
    }
    return processed;
  }

  DocType? _hintFromString(String? value) {
    if (value == null) return null;
    return value == DocType.receiptVoucher.name
        ? DocType.receiptVoucher
        : DocType.purchaseInvoice;
  }
}
