import '../entities/purchase_invoice_entity.dart';
import '../repositories/invoices_repository.dart';

/// حفظ الفاتورة مع تطبيق قواعد الدفع الصارمة (آجل / نقدي / جزئي) على المبلغ المرحّل.
class SaveConfirmedInvoiceUseCase {
  const SaveConfirmedInvoiceUseCase(this._repository);

  final InvoicesRepository _repository;

  Future<int> call(PurchaseInvoiceEntity invoice) async {
    final net = invoice.netTotal;
    final double paid;
    final double remaining;

    switch (invoice.paymentType) {
      case 'cash':
        paid = net;
        remaining = 0.0;
        break;
      case 'partial':
        paid = invoice.paidAmount.clamp(0.0, net);
        remaining = net - paid;
        break;
      case 'credit':
      default:
        paid = 0.0;
        remaining = net;
        break;
    }

    final normalized = invoice.copyWith(
      paidAmount: paid,
      remainingAmount: remaining,
    );
    return _repository.saveConfirmedInvoice(normalized);
  }
}
