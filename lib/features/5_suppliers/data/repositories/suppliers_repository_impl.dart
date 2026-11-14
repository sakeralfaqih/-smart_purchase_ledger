import '../../domain/entities/balance_reconciliation_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/entities/supplier_ledger_entry_entity.dart';
import '../../domain/repositories/suppliers_repository.dart';
import '../datasources/suppliers_local_datasource.dart';

class SuppliersRepositoryImpl implements SuppliersRepository {
  SuppliersRepositoryImpl(this._local);

  final SuppliersLocalDataSource _local;

  @override
  Stream<List<SupplierEntity>> watchAllSuppliers() => _local.watchAll();

  @override
  Future<List<SupplierEntity>> getAllSuppliers() => _local.getAll();

  @override
  Future<SupplierEntity?> getSupplier(int id) => _local.get(id);

  @override
  Stream<SupplierEntity?> watchSupplier(int id) => _local.watch(id);

  @override
  Future<int> createSupplier(SupplierEntity supplier) => _local.create(supplier);

  @override
  Future<void> updateSupplier(SupplierEntity supplier) => _local.update(supplier);

  @override
  Stream<double> watchTotalDebt() => _local.watchTotalDebt();

  @override
  Stream<List<SupplierEntity>> watchMismatchedSuppliers() =>
      _local.watchMismatched();

  @override
  Future<List<SupplierLedgerEntryEntity>> getSupplierStatement(
    int supplierId,
  ) =>
      _local.getStatement(supplierId);

  @override
  Future<BalanceReconciliationEntity> reconcileSupplier(int supplierId) =>
      _local.reconcile(supplierId);
}
