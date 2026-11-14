import '../repositories/dashboard_repository.dart';

class GlobalInstantSearchUseCase {
  const GlobalInstantSearchUseCase(this._repository);

  final DashboardRepository _repository;

  Future<GlobalSearchResults> call(String query) =>
      _repository.instantSearch(query);
}
