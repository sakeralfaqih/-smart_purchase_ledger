import '../entities/balance_reconciliation_entity.dart';
import '../repositories/suppliers_repository.dart';

/// القاعدة الخامسة: مقارنة الرصيد الدفتري بالرصيد المطبوع لدى المورد.
class ReconcileSupplierBalanceUseCase {
  const ReconcileSupplierBalanceUseCase(this._repository);
  final SuppliersRepository _repository;

  Future<BalanceReconciliationEntity> call(int supplierId) =>
      _repository.reconcileSupplier(supplierId);
}
