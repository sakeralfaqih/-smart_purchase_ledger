import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_local_datasource.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  InvoicesRepositoryImpl(this._local);

  final InvoicesLocalDataSource _local;

  @override
  Future<int> saveConfirmedInvoice(PurchaseInvoiceEntity invoice) =>
      _local.saveInvoiceTransaction(invoice);

  @override
  Future<PurchaseInvoiceEntity?> getInvoiceDetails(int invoiceId) =>
      _local.getInvoiceDetails(invoiceId);

  @override
  Stream<List<PurchaseInvoiceEntity>> watchRecentInvoices({int limit = 20}) =>
      _local.watchRecentInvoices(limit: limit);

  @override
  Stream<List<PurchaseInvoiceEntity>> watchInvoicesBySupplier(
    int supplierId,
  ) =>
      _local.watchInvoicesBySupplier(supplierId);

  @override
  Future<List<PurchaseInvoiceEntity>> getInvoicesBySupplier(
    int supplierId,
  ) =>
      _local.getInvoicesBySupplier(supplierId);

  @override
  Future<void> deleteInvoice(int id) => _local.deleteInvoice(id);
}
