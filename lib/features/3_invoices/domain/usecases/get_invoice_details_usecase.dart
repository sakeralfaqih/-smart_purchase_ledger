import '../entities/purchase_invoice_entity.dart';
import '../repositories/invoices_repository.dart';

class GetInvoiceDetailsUseCase {
  const GetInvoiceDetailsUseCase(this._repository);
  final InvoicesRepository _repository;

  Future<PurchaseInvoiceEntity?> call(int invoiceId) =>
      _repository.getInvoiceDetails(invoiceId);
}
