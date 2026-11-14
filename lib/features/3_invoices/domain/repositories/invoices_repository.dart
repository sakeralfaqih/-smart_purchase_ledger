import '../entities/purchase_invoice_entity.dart';

abstract class InvoicesRepository {
  /// حفظ ذري: الفاتورة + الأسطر + تحديث رصيد المورد + تحديث أسعار الأصناف.
  Future<int> saveConfirmedInvoice(PurchaseInvoiceEntity invoice);

  Future<PurchaseInvoiceEntity?> getInvoiceDetails(int invoiceId);

  Stream<List<PurchaseInvoiceEntity>> watchRecentInvoices({int limit});

  Stream<List<PurchaseInvoiceEntity>> watchInvoicesBySupplier(int supplierId);

  Future<List<PurchaseInvoiceEntity>> getInvoicesBySupplier(int supplierId);

  Future<void> deleteInvoice(int id);
}
