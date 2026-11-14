import '../entities/supplier_ledger_entry_entity.dart';
import '../repositories/suppliers_repository.dart';

class GetSupplierStatementUseCase {
  const GetSupplierStatementUseCase(this._repository);
  final SuppliersRepository _repository;

  Future<List<SupplierLedgerEntryEntity>> call(int supplierId) =>
      _repository.getSupplierStatement(supplierId);
}
