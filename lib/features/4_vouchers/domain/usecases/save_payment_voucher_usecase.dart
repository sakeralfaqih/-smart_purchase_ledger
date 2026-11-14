import '../entities/payment_voucher_entity.dart';
import '../repositories/vouchers_repository.dart';

/// حفظ سند القبض وخصم المبلغ من مديونية المورد.
class SavePaymentVoucherUseCase {
  const SavePaymentVoucherUseCase(this._repository);

  final VouchersRepository _repository;

  Future<int> call(PaymentVoucherEntity voucher) {
    if (voucher.amount <= 0) {
      throw ArgumentError('قيمة السند يجب أن تكون أكبر من صفر.');
    }
    return _repository.saveVoucher(voucher);
  }
}
