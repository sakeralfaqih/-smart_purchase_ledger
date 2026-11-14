import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/invoices_local_datasource.dart';
import '../../data/repositories/invoices_repository_impl.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../../domain/usecases/get_invoice_details_usecase.dart';
import '../../domain/usecases/save_confirmed_invoice_usecase.dart';

final invoicesLocalDataSourceProvider = Provider<InvoicesLocalDataSource>(
  (ref) => InvoicesLocalDataSource(
    ref.watch(appDatabaseProvider),
    ref.watch(invoicesDaoProvider),
    ref.watch(catalogDaoProvider),
    ref.watch(suppliersDaoProvider),
    ref.watch(vouchersDaoProvider),
  ),
);

final invoicesRepositoryProvider = Provider<InvoicesRepository>(
  (ref) => InvoicesRepositoryImpl(ref.watch(invoicesLocalDataSourceProvider)),
);

final saveConfirmedInvoiceUseCaseProvider =
    Provider<SaveConfirmedInvoiceUseCase>((ref) =>
        SaveConfirmedInvoiceUseCase(ref.watch(invoicesRepositoryProvider)));

final getInvoiceDetailsUseCaseProvider = Provider<GetInvoiceDetailsUseCase>(
    (ref) => GetInvoiceDetailsUseCase(ref.watch(invoicesRepositoryProvider)));

final recentInvoicesProvider =
    StreamProvider.autoDispose<List<PurchaseInvoiceEntity>>((ref) {
  return ref.watch(invoicesRepositoryProvider).watchRecentInvoices(limit: 30);
});

final invoicesBySupplierProvider = StreamProvider.autoDispose
    .family<List<PurchaseInvoiceEntity>, int>((ref, supplierId) {
  return ref
      .watch(invoicesRepositoryProvider)
      .watchInvoicesBySupplier(supplierId);
});

final invoiceDetailsProvider = FutureProvider.autoDispose
    .family<PurchaseInvoiceEntity?, int>((ref, invoiceId) {
  return ref.watch(getInvoiceDetailsUseCaseProvider)(invoiceId);
});
