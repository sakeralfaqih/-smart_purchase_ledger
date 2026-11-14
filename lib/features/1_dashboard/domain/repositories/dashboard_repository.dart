import '../entities/dashboard_summary_entity.dart';

abstract class DashboardRepository {
  /// تدفّق حيّ لملخص لوحة التحكم.
  Stream<DashboardSummary> watchSummary();

  /// بحث فوري شامل في الموردين والأصناف وأرقام الفواتير.
  Future<GlobalSearchResults> instantSearch(String query);
}

/// نتائج البحث الفوري الشامل (الموردون + الأصناف + الفواتير).
class GlobalSearchResults {
  const GlobalSearchResults({
    required this.suppliers,
    required this.items,
    this.invoices = const [],
  });

  final List<GlobalSearchHit> suppliers;
  final List<GlobalSearchHit> items;
  final List<GlobalSearchHit> invoices;

  bool get isEmpty =>
      suppliers.isEmpty && items.isEmpty && invoices.isEmpty;
}

class GlobalSearchHit {
  const GlobalSearchHit({
    required this.id,
    required this.title,
    this.subtitle,
  });

  final int id;
  final String title;
  final String? subtitle;
}
