import '../../domain/entities/payment_voucher_entity.dart';
import '../../domain/repositories/vouchers_repository.dart';
import '../datasources/vouchers_local_datasource.dart';

class VouchersRepositoryImpl implements VouchersRepository {
  VouchersRepositoryImpl(this._local);

  final VouchersLocalDataSource _local;

  @override
  Future<int> saveVoucher(PaymentVoucherEntity voucher) =>
      _local.saveVoucherTransaction(voucher);

  @override
  Stream<List<PaymentVoucherEntity>> watchVouchersBySupplier(int supplierId) =>
      _local.watchBySupplier(supplierId);

  @override
  Future<List<PaymentVoucherEntity>> getVouchersBySupplier(int supplierId) =>
      _local.getBySupplier(supplierId);

  @override
  Future<void> deleteVoucher(int id) => _local.deleteVoucher(id);
}
