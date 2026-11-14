import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../3_invoices/presentation/providers/invoices_providers.dart';
import '../../../4_vouchers/presentation/providers/vouchers_providers.dart';
import '../../data/datasources/suppliers_local_datasource.dart';
import '../../data/repositories/suppliers_repository_impl.dart';
import '../../domain/entities/balance_reconciliation_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/entities/supplier_ledger_entry_entity.dart';
import '../../domain/repositories/suppliers_repository.dart';
import '../../domain/usecases/generate_statement_pdf_usecase.dart';
import '../../domain/usecases/get_supplier_statement_usecase.dart';
import '../../domain/usecases/reconcile_supplier_balance_usecase.dart';

final suppliersLocalDataSourceProvider = Provider<SuppliersLocalDataSource>(
  (ref) => SuppliersLocalDataSource(
    ref.watch(suppliersDaoProvider),
    ref.watch(invoicesDaoProvider),
    ref.watch(vouchersDaoProvider),
  ),
);

final suppliersRepositoryProvider = Provider<SuppliersRepository>(
  (ref) => SuppliersRepositoryImpl(ref.watch(suppliersLocalDataSourceProvider)),
);

final getSupplierStatementUseCaseProvider =
    Provider<GetSupplierStatementUseCase>((ref) =>
        GetSupplierStatementUseCase(ref.watch(suppliersRepositoryProvider)));

final reconcileSupplierBalanceUseCaseProvider =
    Provider<ReconcileSupplierBalanceUseCase>((ref) =>
        ReconcileSupplierBalanceUseCase(
            ref.watch(suppliersRepositoryProvider)));

final generateStatementPdfUseCaseProvider =
    Provider<GenerateStatementPdfUseCase>(
        (ref) => const GenerateStatementPdfUseCase());

final allSuppliersProvider =
    StreamProvider.autoDispose<List<SupplierEntity>>((ref) {
  return ref.watch(suppliersRepositoryProvider).watchAllSuppliers();
});

final totalDebtProvider = StreamProvider.autoDispose<double>((ref) {
  return ref.watch(suppliersRepositoryProvider).watchTotalDebt();
});

final mismatchedSuppliersProvider =
    StreamProvider.autoDispose<List<SupplierEntity>>((ref) {
  return ref.watch(suppliersRepositoryProvider).watchMismatchedSuppliers();
});

final supplierProvider = StreamProvider.autoDispose
    .family<SupplierEntity?, int>((ref, supplierId) {
  return ref.watch(suppliersRepositoryProvider).watchSupplier(supplierId);
});

/// كشف حساب المورد التفاعلي: يعيد الحساب تلقائياً فور تغير بيانات المورد أو فواتيره أو سنداته.
final supplierStatementProvider = FutureProvider.autoDispose
    .family<List<SupplierLedgerEntryEntity>, int>((ref, supplierId) {
  ref.watch(supplierProvider(supplierId));
  ref.watch(invoicesBySupplierProvider(supplierId));
  ref.watch(vouchersBySupplierProvider(supplierId));
  return ref.watch(getSupplierStatementUseCaseProvider)(supplierId);
});

/// مطابقة رصيد المورد التفاعلية: تتحدث تلقائياً فور تغير الرصيد الدفتري أو المطبوع.
final supplierReconciliationProvider = FutureProvider.autoDispose
    .family<BalanceReconciliationEntity, int>((ref, supplierId) {
  ref.watch(supplierProvider(supplierId));
  ref.watch(invoicesBySupplierProvider(supplierId));
  ref.watch(vouchersBySupplierProvider(supplierId));
  return ref.watch(reconcileSupplierBalanceUseCaseProvider)(supplierId);
});

/// قائمة الأصناف المشتراة من هذا المورد مع آخر سعر وتاريخ شراء.
final supplierPurchasedItemsProvider = StreamProvider.autoDispose
    .family<List<SupplierItem>, int>((ref, supplierId) {
  return ref
      .watch(catalogDaoProvider)
      .watchSupplierItemsBySupplier(supplierId);
});
