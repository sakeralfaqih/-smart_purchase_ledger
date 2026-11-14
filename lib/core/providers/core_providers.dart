import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_config.dart';
import '../database/app_database.dart';
import '../database/daos/catalog_dao.dart';
import '../database/daos/invoices_dao.dart';
import '../database/daos/suppliers_dao.dart';
import '../database/daos/vouchers_dao.dart';
import '../network/gemini_api_client.dart';
import '../network/network_info.dart';
import '../services/document_scanner_service.dart';
import '../services/image_compression_service.dart';

/// قاعدة البيانات المركزية — نسخة واحدة لكل التطبيق.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final suppliersDaoProvider = Provider<SuppliersDao>(
  (ref) => ref.watch(appDatabaseProvider).suppliersDao,
);

final catalogDaoProvider = Provider<CatalogDao>(
  (ref) => ref.watch(appDatabaseProvider).catalogDao,
);

final invoicesDaoProvider = Provider<InvoicesDao>(
  (ref) => ref.watch(appDatabaseProvider).invoicesDao,
);

final vouchersDaoProvider = Provider<VouchersDao>(
  (ref) => ref.watch(appDatabaseProvider).vouchersDao,
);

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(),
);

/// مزود مفتاح Gemini API القابل للتحديث ديناميكياً من شاشة الإعدادات.
final geminiApiKeyStateProvider = StateProvider<String>(
  (ref) => AppConfig.geminiApiKey,
);

final geminiApiClientProvider = Provider<GeminiApiClient>((ref) {
  final apiKey = ref.watch(geminiApiKeyStateProvider);
  return GeminiApiClient(apiKey: apiKey);
});

final documentScannerServiceProvider = Provider<DocumentScannerService>(
  (ref) => DocumentScannerService(),
);

final imageCompressionServiceProvider = Provider<ImageCompressionService>(
  (ref) => ImageCompressionService(),
);
