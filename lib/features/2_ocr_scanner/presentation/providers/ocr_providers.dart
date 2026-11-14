import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/gemini_vision_remote_datasource.dart';
import '../../data/datasources/offline_ocr_queue_local_datasource.dart';
import '../../data/repositories/item_matching_repository_impl.dart';
import '../../data/repositories/ocr_scanner_repository_impl.dart';
import '../../data/repositories/supplier_resolver_impl.dart';
import '../../domain/repositories/item_matching_repository.dart';
import '../../domain/repositories/ocr_scanner_repository.dart';
import '../../domain/repositories/supplier_resolver.dart';
import '../../domain/usecases/match_extracted_items_usecase.dart';
import '../../domain/usecases/parse_item_pack_and_retail_usecase.dart';
import '../../domain/usecases/scan_and_extract_document_usecase.dart';
import '../../domain/usecases/validate_invoice_math_usecase.dart';

final geminiVisionRemoteProvider = Provider<GeminiVisionRemoteDataSource>(
  (ref) => GeminiVisionRemoteDataSource(ref.watch(geminiApiClientProvider)),
);

final offlineOcrQueueProvider = Provider<OfflineOcrQueueLocalDataSource>(
  (ref) => OfflineOcrQueueLocalDataSource(),
);

final ocrScannerRepositoryProvider = Provider<OcrScannerRepository>(
  (ref) => OcrScannerRepositoryImpl(
    ref.watch(geminiVisionRemoteProvider),
    ref.watch(offlineOcrQueueProvider),
    ref.watch(networkInfoProvider),
  ),
);

final supplierResolverProvider = Provider<SupplierResolver>(
  (ref) => SupplierResolverImpl(ref.watch(suppliersDaoProvider)),
);

final itemMatchingRepositoryProvider = Provider<ItemMatchingRepository>(
  (ref) => ItemMatchingRepositoryImpl(ref.watch(catalogDaoProvider)),
);

final validateInvoiceMathUseCaseProvider =
    Provider<ValidateInvoiceMathUseCase>(
  (ref) => const ValidateInvoiceMathUseCase(),
);

final parseItemPackAndRetailUseCaseProvider =
    Provider<ParseItemPackAndRetailUseCase>(
  (ref) => const ParseItemPackAndRetailUseCase(),
);

final matchExtractedItemsUseCaseProvider =
    Provider<MatchExtractedItemsUseCase>(
  (ref) => MatchExtractedItemsUseCase(
    ref.watch(itemMatchingRepositoryProvider),
    ref.watch(parseItemPackAndRetailUseCaseProvider),
  ),
);

final scanAndExtractDocumentUseCaseProvider =
    Provider<ScanAndExtractDocumentUseCase>(
  (ref) => ScanAndExtractDocumentUseCase(
    ref.watch(ocrScannerRepositoryProvider),
    ref.watch(supplierResolverProvider),
    ref.watch(validateInvoiceMathUseCaseProvider),
    ref.watch(matchExtractedItemsUseCaseProvider),
  ),
);
