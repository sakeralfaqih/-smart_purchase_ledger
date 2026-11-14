import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._local);

  final DashboardLocalDataSource _local;

  @override
  Stream<DashboardSummary> watchSummary() => _local.watchSummary();

  @override
  Future<GlobalSearchResults> instantSearch(String query) =>
      _local.instantSearch(query);
}
