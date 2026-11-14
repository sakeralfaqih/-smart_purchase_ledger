import '../entities/payment_voucher_entity.dart';

abstract class VouchersRepository {
  /// حفظ السند وخصم المبلغ من مديونية المورد (معاملة ذرية).
  Future<int> saveVoucher(PaymentVoucherEntity voucher);

  Stream<List<PaymentVoucherEntity>> watchVouchersBySupplier(int supplierId);

  Future<List<PaymentVoucherEntity>> getVouchersBySupplier(int supplierId);

  Future<void> deleteVoucher(int id);
}
