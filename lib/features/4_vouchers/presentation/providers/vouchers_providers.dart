import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/vouchers_local_datasource.dart';
import '../../data/repositories/vouchers_repository_impl.dart';
import '../../domain/entities/payment_voucher_entity.dart';
import '../../domain/repositories/vouchers_repository.dart';
import '../../domain/usecases/save_payment_voucher_usecase.dart';

final vouchersLocalDataSourceProvider = Provider<VouchersLocalDataSource>(
  (ref) => VouchersLocalDataSource(
    ref.watch(appDatabaseProvider),
    ref.watch(vouchersDaoProvider),
    ref.watch(suppliersDaoProvider),
    ref.watch(invoicesDaoProvider),
  ),
);

final vouchersRepositoryProvider = Provider<VouchersRepository>(
  (ref) => VouchersRepositoryImpl(ref.watch(vouchersLocalDataSourceProvider)),
);

final savePaymentVoucherUseCaseProvider = Provider<SavePaymentVoucherUseCase>(
    (ref) => SavePaymentVoucherUseCase(ref.watch(vouchersRepositoryProvider)));

final vouchersBySupplierProvider = StreamProvider.autoDispose
    .family<List<PaymentVoucherEntity>, int>((ref, supplierId) {
  return ref
      .watch(vouchersRepositoryProvider)
      .watchVouchersBySupplier(supplierId);
});
