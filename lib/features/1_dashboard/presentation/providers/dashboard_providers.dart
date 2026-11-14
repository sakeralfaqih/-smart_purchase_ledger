import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/dashboard_local_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/global_instant_search_usecase.dart';

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>(
  (ref) => DashboardLocalDataSource(
    ref.watch(appDatabaseProvider),
    ref.watch(suppliersDaoProvider),
    ref.watch(invoicesDaoProvider),
    ref.watch(catalogDaoProvider),
  ),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(ref.watch(dashboardLocalDataSourceProvider)),
);

final getDashboardSummaryUseCaseProvider =
    Provider<GetDashboardSummaryUseCase>((ref) =>
        GetDashboardSummaryUseCase(ref.watch(dashboardRepositoryProvider)));

final globalInstantSearchUseCaseProvider =
    Provider<GlobalInstantSearchUseCase>((ref) =>
        GlobalInstantSearchUseCase(ref.watch(dashboardRepositoryProvider)));

final dashboardSummaryProvider =
    StreamProvider.autoDispose<DashboardSummary>((ref) {
  return ref.watch(getDashboardSummaryUseCaseProvider)();
});

final globalSearchProvider =
    FutureProvider.autoDispose.family<GlobalSearchResults, String>(
        (ref, query) {
  return ref.watch(globalInstantSearchUseCaseProvider)(query);
});
