import '../entities/balance_reconciliation_entity.dart';
import '../entities/supplier_entity.dart';
import '../entities/supplier_ledger_entry_entity.dart';

abstract class SuppliersRepository {
  Stream<List<SupplierEntity>> watchAllSuppliers();
  Future<List<SupplierEntity>> getAllSuppliers();
  Future<SupplierEntity?> getSupplier(int id);
  Stream<SupplierEntity?> watchSupplier(int id);
  Future<int> createSupplier(SupplierEntity supplier);
  Future<void> updateSupplier(SupplierEntity supplier);
  Stream<double> watchTotalDebt();
  Stream<List<SupplierEntity>> watchMismatchedSuppliers();

  Future<List<SupplierLedgerEntryEntity>> getSupplierStatement(int supplierId);
  Future<BalanceReconciliationEntity> reconcileSupplier(int supplierId);
}
