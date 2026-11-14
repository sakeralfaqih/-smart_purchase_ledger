class SupplierEntity {
  const SupplierEntity({
    this.id,
    required this.name,
    this.branchName,
    this.analyticAccountNo,
    this.phones = const [],
    this.ocrAliases = const [],
    this.currency = 'YER',
    this.openingBalance = 0.0,
    this.currentCalculatedBalance = 0.0,
    this.lastPrintedSupplierBalance,
    this.lastBalanceDocDate,
    this.notes,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String? branchName;
  final String? analyticAccountNo;
  final List<String> phones;
  final List<String> ocrAliases;
  final String currency;
  final double openingBalance;
  final double currentCalculatedBalance;
  final double? lastPrintedSupplierBalance;
  final DateTime? lastBalanceDocDate;
  final String? notes;
  final DateTime createdAt;

  bool get hasBalanceMismatch {
    final printed = lastPrintedSupplierBalance;
    if (printed == null) return false;
    return (printed - currentCalculatedBalance).abs() > 0.01;
  }

  double get balanceDifference =>
      (lastPrintedSupplierBalance ?? currentCalculatedBalance) -
      currentCalculatedBalance;

  SupplierEntity copyWith({
    int? id,
    String? name,
    String? branchName,
    String? analyticAccountNo,
    List<String>? phones,
    List<String>? ocrAliases,
    String? currency,
    double? openingBalance,
    double? currentCalculatedBalance,
    double? lastPrintedSupplierBalance,
    DateTime? lastBalanceDocDate,
    String? notes,
    DateTime? createdAt,
  }) =>
      SupplierEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        branchName: branchName ?? this.branchName,
        analyticAccountNo: analyticAccountNo ?? this.analyticAccountNo,
        phones: phones ?? this.phones,
        ocrAliases: ocrAliases ?? this.ocrAliases,
        currency: currency ?? this.currency,
        openingBalance: openingBalance ?? this.openingBalance,
        currentCalculatedBalance:
            currentCalculatedBalance ?? this.currentCalculatedBalance,
        lastPrintedSupplierBalance:
            lastPrintedSupplierBalance ?? this.lastPrintedSupplierBalance,
        lastBalanceDocDate: lastBalanceDocDate ?? this.lastBalanceDocDate,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
}
