// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _branchNameMeta =
      const VerificationMeta('branchName');
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
      'branch_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _analyticAccountNoMeta =
      const VerificationMeta('analyticAccountNo');
  @override
  late final GeneratedColumn<String> analyticAccountNo =
      GeneratedColumn<String>('analytic_account_no', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phonesJsonMeta =
      const VerificationMeta('phonesJson');
  @override
  late final GeneratedColumn<String> phonesJson = GeneratedColumn<String>(
      'phones_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _ocrAliasesJsonMeta =
      const VerificationMeta('ocrAliasesJson');
  @override
  late final GeneratedColumn<String> ocrAliasesJson = GeneratedColumn<String>(
      'ocr_aliases_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currentCalculatedBalanceMeta =
      const VerificationMeta('currentCalculatedBalance');
  @override
  late final GeneratedColumn<double> currentCalculatedBalance =
      GeneratedColumn<double>('current_calculated_balance', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _lastPrintedSupplierBalanceMeta =
      const VerificationMeta('lastPrintedSupplierBalance');
  @override
  late final GeneratedColumn<double> lastPrintedSupplierBalance =
      GeneratedColumn<double>(
          'last_printed_supplier_balance', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastBalanceDocDateMeta =
      const VerificationMeta('lastBalanceDocDate');
  @override
  late final GeneratedColumn<DateTime> lastBalanceDocDate =
      GeneratedColumn<DateTime>('last_balance_doc_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        branchName,
        analyticAccountNo,
        phonesJson,
        ocrAliasesJson,
        currency,
        openingBalance,
        currentCalculatedBalance,
        lastPrintedSupplierBalance,
        lastBalanceDocDate,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('branch_name')) {
      context.handle(
          _branchNameMeta,
          branchName.isAcceptableOrUnknown(
              data['branch_name']!, _branchNameMeta));
    }
    if (data.containsKey('analytic_account_no')) {
      context.handle(
          _analyticAccountNoMeta,
          analyticAccountNo.isAcceptableOrUnknown(
              data['analytic_account_no']!, _analyticAccountNoMeta));
    }
    if (data.containsKey('phones_json')) {
      context.handle(
          _phonesJsonMeta,
          phonesJson.isAcceptableOrUnknown(
              data['phones_json']!, _phonesJsonMeta));
    }
    if (data.containsKey('ocr_aliases_json')) {
      context.handle(
          _ocrAliasesJsonMeta,
          ocrAliasesJson.isAcceptableOrUnknown(
              data['ocr_aliases_json']!, _ocrAliasesJsonMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    }
    if (data.containsKey('current_calculated_balance')) {
      context.handle(
          _currentCalculatedBalanceMeta,
          currentCalculatedBalance.isAcceptableOrUnknown(
              data['current_calculated_balance']!,
              _currentCalculatedBalanceMeta));
    }
    if (data.containsKey('last_printed_supplier_balance')) {
      context.handle(
          _lastPrintedSupplierBalanceMeta,
          lastPrintedSupplierBalance.isAcceptableOrUnknown(
              data['last_printed_supplier_balance']!,
              _lastPrintedSupplierBalanceMeta));
    }
    if (data.containsKey('last_balance_doc_date')) {
      context.handle(
          _lastBalanceDocDateMeta,
          lastBalanceDocDate.isAcceptableOrUnknown(
              data['last_balance_doc_date']!, _lastBalanceDocDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      branchName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch_name']),
      analyticAccountNo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}analytic_account_no']),
      phonesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phones_json'])!,
      ocrAliasesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ocr_aliases_json'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      currentCalculatedBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}current_calculated_balance'])!,
      lastPrintedSupplierBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}last_printed_supplier_balance']),
      lastBalanceDocDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_balance_doc_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? branchName;

  /// الرقم التحليلي / رقم حساب العميل لدى المورد (مثل 13007).
  final String? analyticAccountNo;

  /// مصفوفة أرقام الهواتف بصيغة JSON.
  final String phonesJson;

  /// مسميات المورد البديلة للـ OCR بصيغة JSON.
  final String ocrAliasesJson;
  final String currency;
  final double openingBalance;
  final double currentCalculatedBalance;

  /// آخر رصيد مطبوع في وثيقة المورد.
  final double? lastPrintedSupplierBalance;
  final DateTime? lastBalanceDocDate;
  final String? notes;
  final DateTime createdAt;
  const Supplier(
      {required this.id,
      required this.name,
      this.branchName,
      this.analyticAccountNo,
      required this.phonesJson,
      required this.ocrAliasesJson,
      required this.currency,
      required this.openingBalance,
      required this.currentCalculatedBalance,
      this.lastPrintedSupplierBalance,
      this.lastBalanceDocDate,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || branchName != null) {
      map['branch_name'] = Variable<String>(branchName);
    }
    if (!nullToAbsent || analyticAccountNo != null) {
      map['analytic_account_no'] = Variable<String>(analyticAccountNo);
    }
    map['phones_json'] = Variable<String>(phonesJson);
    map['ocr_aliases_json'] = Variable<String>(ocrAliasesJson);
    map['currency'] = Variable<String>(currency);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['current_calculated_balance'] =
        Variable<double>(currentCalculatedBalance);
    if (!nullToAbsent || lastPrintedSupplierBalance != null) {
      map['last_printed_supplier_balance'] =
          Variable<double>(lastPrintedSupplierBalance);
    }
    if (!nullToAbsent || lastBalanceDocDate != null) {
      map['last_balance_doc_date'] = Variable<DateTime>(lastBalanceDocDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      branchName: branchName == null && nullToAbsent
          ? const Value.absent()
          : Value(branchName),
      analyticAccountNo: analyticAccountNo == null && nullToAbsent
          ? const Value.absent()
          : Value(analyticAccountNo),
      phonesJson: Value(phonesJson),
      ocrAliasesJson: Value(ocrAliasesJson),
      currency: Value(currency),
      openingBalance: Value(openingBalance),
      currentCalculatedBalance: Value(currentCalculatedBalance),
      lastPrintedSupplierBalance:
          lastPrintedSupplierBalance == null && nullToAbsent
              ? const Value.absent()
              : Value(lastPrintedSupplierBalance),
      lastBalanceDocDate: lastBalanceDocDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBalanceDocDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      branchName: serializer.fromJson<String?>(json['branchName']),
      analyticAccountNo:
          serializer.fromJson<String?>(json['analyticAccountNo']),
      phonesJson: serializer.fromJson<String>(json['phonesJson']),
      ocrAliasesJson: serializer.fromJson<String>(json['ocrAliasesJson']),
      currency: serializer.fromJson<String>(json['currency']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      currentCalculatedBalance:
          serializer.fromJson<double>(json['currentCalculatedBalance']),
      lastPrintedSupplierBalance:
          serializer.fromJson<double?>(json['lastPrintedSupplierBalance']),
      lastBalanceDocDate:
          serializer.fromJson<DateTime?>(json['lastBalanceDocDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'branchName': serializer.toJson<String?>(branchName),
      'analyticAccountNo': serializer.toJson<String?>(analyticAccountNo),
      'phonesJson': serializer.toJson<String>(phonesJson),
      'ocrAliasesJson': serializer.toJson<String>(ocrAliasesJson),
      'currency': serializer.toJson<String>(currency),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'currentCalculatedBalance':
          serializer.toJson<double>(currentCalculatedBalance),
      'lastPrintedSupplierBalance':
          serializer.toJson<double?>(lastPrintedSupplierBalance),
      'lastBalanceDocDate': serializer.toJson<DateTime?>(lastBalanceDocDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          Value<String?> branchName = const Value.absent(),
          Value<String?> analyticAccountNo = const Value.absent(),
          String? phonesJson,
          String? ocrAliasesJson,
          String? currency,
          double? openingBalance,
          double? currentCalculatedBalance,
          Value<double?> lastPrintedSupplierBalance = const Value.absent(),
          Value<DateTime?> lastBalanceDocDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        branchName: branchName.present ? branchName.value : this.branchName,
        analyticAccountNo: analyticAccountNo.present
            ? analyticAccountNo.value
            : this.analyticAccountNo,
        phonesJson: phonesJson ?? this.phonesJson,
        ocrAliasesJson: ocrAliasesJson ?? this.ocrAliasesJson,
        currency: currency ?? this.currency,
        openingBalance: openingBalance ?? this.openingBalance,
        currentCalculatedBalance:
            currentCalculatedBalance ?? this.currentCalculatedBalance,
        lastPrintedSupplierBalance: lastPrintedSupplierBalance.present
            ? lastPrintedSupplierBalance.value
            : this.lastPrintedSupplierBalance,
        lastBalanceDocDate: lastBalanceDocDate.present
            ? lastBalanceDocDate.value
            : this.lastBalanceDocDate,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      branchName:
          data.branchName.present ? data.branchName.value : this.branchName,
      analyticAccountNo: data.analyticAccountNo.present
          ? data.analyticAccountNo.value
          : this.analyticAccountNo,
      phonesJson:
          data.phonesJson.present ? data.phonesJson.value : this.phonesJson,
      ocrAliasesJson: data.ocrAliasesJson.present
          ? data.ocrAliasesJson.value
          : this.ocrAliasesJson,
      currency: data.currency.present ? data.currency.value : this.currency,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      currentCalculatedBalance: data.currentCalculatedBalance.present
          ? data.currentCalculatedBalance.value
          : this.currentCalculatedBalance,
      lastPrintedSupplierBalance: data.lastPrintedSupplierBalance.present
          ? data.lastPrintedSupplierBalance.value
          : this.lastPrintedSupplierBalance,
      lastBalanceDocDate: data.lastBalanceDocDate.present
          ? data.lastBalanceDocDate.value
          : this.lastBalanceDocDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchName: $branchName, ')
          ..write('analyticAccountNo: $analyticAccountNo, ')
          ..write('phonesJson: $phonesJson, ')
          ..write('ocrAliasesJson: $ocrAliasesJson, ')
          ..write('currency: $currency, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentCalculatedBalance: $currentCalculatedBalance, ')
          ..write('lastPrintedSupplierBalance: $lastPrintedSupplierBalance, ')
          ..write('lastBalanceDocDate: $lastBalanceDocDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      branchName,
      analyticAccountNo,
      phonesJson,
      ocrAliasesJson,
      currency,
      openingBalance,
      currentCalculatedBalance,
      lastPrintedSupplierBalance,
      lastBalanceDocDate,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.branchName == this.branchName &&
          other.analyticAccountNo == this.analyticAccountNo &&
          other.phonesJson == this.phonesJson &&
          other.ocrAliasesJson == this.ocrAliasesJson &&
          other.currency == this.currency &&
          other.openingBalance == this.openingBalance &&
          other.currentCalculatedBalance == this.currentCalculatedBalance &&
          other.lastPrintedSupplierBalance == this.lastPrintedSupplierBalance &&
          other.lastBalanceDocDate == this.lastBalanceDocDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> branchName;
  final Value<String?> analyticAccountNo;
  final Value<String> phonesJson;
  final Value<String> ocrAliasesJson;
  final Value<String> currency;
  final Value<double> openingBalance;
  final Value<double> currentCalculatedBalance;
  final Value<double?> lastPrintedSupplierBalance;
  final Value<DateTime?> lastBalanceDocDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.branchName = const Value.absent(),
    this.analyticAccountNo = const Value.absent(),
    this.phonesJson = const Value.absent(),
    this.ocrAliasesJson = const Value.absent(),
    this.currency = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.currentCalculatedBalance = const Value.absent(),
    this.lastPrintedSupplierBalance = const Value.absent(),
    this.lastBalanceDocDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.branchName = const Value.absent(),
    this.analyticAccountNo = const Value.absent(),
    this.phonesJson = const Value.absent(),
    this.ocrAliasesJson = const Value.absent(),
    this.currency = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.currentCalculatedBalance = const Value.absent(),
    this.lastPrintedSupplierBalance = const Value.absent(),
    this.lastBalanceDocDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? branchName,
    Expression<String>? analyticAccountNo,
    Expression<String>? phonesJson,
    Expression<String>? ocrAliasesJson,
    Expression<String>? currency,
    Expression<double>? openingBalance,
    Expression<double>? currentCalculatedBalance,
    Expression<double>? lastPrintedSupplierBalance,
    Expression<DateTime>? lastBalanceDocDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (branchName != null) 'branch_name': branchName,
      if (analyticAccountNo != null) 'analytic_account_no': analyticAccountNo,
      if (phonesJson != null) 'phones_json': phonesJson,
      if (ocrAliasesJson != null) 'ocr_aliases_json': ocrAliasesJson,
      if (currency != null) 'currency': currency,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (currentCalculatedBalance != null)
        'current_calculated_balance': currentCalculatedBalance,
      if (lastPrintedSupplierBalance != null)
        'last_printed_supplier_balance': lastPrintedSupplierBalance,
      if (lastBalanceDocDate != null)
        'last_balance_doc_date': lastBalanceDocDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? branchName,
      Value<String?>? analyticAccountNo,
      Value<String>? phonesJson,
      Value<String>? ocrAliasesJson,
      Value<String>? currency,
      Value<double>? openingBalance,
      Value<double>? currentCalculatedBalance,
      Value<double?>? lastPrintedSupplierBalance,
      Value<DateTime?>? lastBalanceDocDate,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      branchName: branchName ?? this.branchName,
      analyticAccountNo: analyticAccountNo ?? this.analyticAccountNo,
      phonesJson: phonesJson ?? this.phonesJson,
      ocrAliasesJson: ocrAliasesJson ?? this.ocrAliasesJson,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (analyticAccountNo.present) {
      map['analytic_account_no'] = Variable<String>(analyticAccountNo.value);
    }
    if (phonesJson.present) {
      map['phones_json'] = Variable<String>(phonesJson.value);
    }
    if (ocrAliasesJson.present) {
      map['ocr_aliases_json'] = Variable<String>(ocrAliasesJson.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (currentCalculatedBalance.present) {
      map['current_calculated_balance'] =
          Variable<double>(currentCalculatedBalance.value);
    }
    if (lastPrintedSupplierBalance.present) {
      map['last_printed_supplier_balance'] =
          Variable<double>(lastPrintedSupplierBalance.value);
    }
    if (lastBalanceDocDate.present) {
      map['last_balance_doc_date'] =
          Variable<DateTime>(lastBalanceDocDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('branchName: $branchName, ')
          ..write('analyticAccountNo: $analyticAccountNo, ')
          ..write('phonesJson: $phonesJson, ')
          ..write('ocrAliasesJson: $ocrAliasesJson, ')
          ..write('currency: $currency, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('currentCalculatedBalance: $currentCalculatedBalance, ')
          ..write('lastPrintedSupplierBalance: $lastPrintedSupplierBalance, ')
          ..write('lastBalanceDocDate: $lastBalanceDocDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _canonicalNameMeta =
      const VerificationMeta('canonicalName');
  @override
  late final GeneratedColumn<String> canonicalName = GeneratedColumn<String>(
      'canonical_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _normalizedNameMeta =
      const VerificationMeta('normalizedName');
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
      'normalized_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('كرتون'));
  static const VerificationMeta _packUnitsCountMeta =
      const VerificationMeta('packUnitsCount');
  @override
  late final GeneratedColumn<int> packUnitsCount = GeneratedColumn<int>(
      'pack_units_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _suggestedRetailPriceMeta =
      const VerificationMeta('suggestedRetailPrice');
  @override
  late final GeneratedColumn<double> suggestedRetailPrice =
      GeneratedColumn<double>('suggested_retail_price', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastPurchasePriceMeta =
      const VerificationMeta('lastPurchasePrice');
  @override
  late final GeneratedColumn<double> lastPurchasePrice =
      GeneratedColumn<double>('last_purchase_price', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lowestPurchasePriceMeta =
      const VerificationMeta('lowestPurchasePrice');
  @override
  late final GeneratedColumn<double> lowestPurchasePrice =
      GeneratedColumn<double>('lowest_purchase_price', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lowestSupplierIdMeta =
      const VerificationMeta('lowestSupplierId');
  @override
  late final GeneratedColumn<int> lowestSupplierId = GeneratedColumn<int>(
      'lowest_supplier_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        canonicalName,
        normalizedName,
        defaultUnit,
        packUnitsCount,
        suggestedRetailPrice,
        lastPurchasePrice,
        lowestPurchasePrice,
        lowestSupplierId,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('canonical_name')) {
      context.handle(
          _canonicalNameMeta,
          canonicalName.isAcceptableOrUnknown(
              data['canonical_name']!, _canonicalNameMeta));
    } else if (isInserting) {
      context.missing(_canonicalNameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
          _normalizedNameMeta,
          normalizedName.isAcceptableOrUnknown(
              data['normalized_name']!, _normalizedNameMeta));
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    }
    if (data.containsKey('pack_units_count')) {
      context.handle(
          _packUnitsCountMeta,
          packUnitsCount.isAcceptableOrUnknown(
              data['pack_units_count']!, _packUnitsCountMeta));
    }
    if (data.containsKey('suggested_retail_price')) {
      context.handle(
          _suggestedRetailPriceMeta,
          suggestedRetailPrice.isAcceptableOrUnknown(
              data['suggested_retail_price']!, _suggestedRetailPriceMeta));
    }
    if (data.containsKey('last_purchase_price')) {
      context.handle(
          _lastPurchasePriceMeta,
          lastPurchasePrice.isAcceptableOrUnknown(
              data['last_purchase_price']!, _lastPurchasePriceMeta));
    }
    if (data.containsKey('lowest_purchase_price')) {
      context.handle(
          _lowestPurchasePriceMeta,
          lowestPurchasePrice.isAcceptableOrUnknown(
              data['lowest_purchase_price']!, _lowestPurchasePriceMeta));
    }
    if (data.containsKey('lowest_supplier_id')) {
      context.handle(
          _lowestSupplierIdMeta,
          lowestSupplierId.isAcceptableOrUnknown(
              data['lowest_supplier_id']!, _lowestSupplierIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      canonicalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}canonical_name'])!,
      normalizedName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}normalized_name'])!,
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit'])!,
      packUnitsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pack_units_count']),
      suggestedRetailPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}suggested_retail_price']),
      lastPurchasePrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}last_purchase_price']),
      lowestPurchasePrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}lowest_purchase_price']),
      lowestSupplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lowest_supplier_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String canonicalName;

  /// الاسم بعد تطبيع الحروف العربية (للبحث السريع).
  final String normalizedName;

  /// الوحدة الافتراضية: كرتون/دبة/كيس/تنكة/باكت/قطم.
  final String defaultUnit;

  /// عدد الحبات/الوحدات الصغرى في العبوة.
  final int? packUnitsCount;

  /// سعر البيع المقترح للمستهلك.
  final double? suggestedRetailPrice;
  final double? lastPurchasePrice;
  final double? lowestPurchasePrice;
  final int? lowestSupplierId;
  final DateTime updatedAt;
  const Item(
      {required this.id,
      required this.canonicalName,
      required this.normalizedName,
      required this.defaultUnit,
      this.packUnitsCount,
      this.suggestedRetailPrice,
      this.lastPurchasePrice,
      this.lowestPurchasePrice,
      this.lowestSupplierId,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['canonical_name'] = Variable<String>(canonicalName);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['default_unit'] = Variable<String>(defaultUnit);
    if (!nullToAbsent || packUnitsCount != null) {
      map['pack_units_count'] = Variable<int>(packUnitsCount);
    }
    if (!nullToAbsent || suggestedRetailPrice != null) {
      map['suggested_retail_price'] = Variable<double>(suggestedRetailPrice);
    }
    if (!nullToAbsent || lastPurchasePrice != null) {
      map['last_purchase_price'] = Variable<double>(lastPurchasePrice);
    }
    if (!nullToAbsent || lowestPurchasePrice != null) {
      map['lowest_purchase_price'] = Variable<double>(lowestPurchasePrice);
    }
    if (!nullToAbsent || lowestSupplierId != null) {
      map['lowest_supplier_id'] = Variable<int>(lowestSupplierId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      canonicalName: Value(canonicalName),
      normalizedName: Value(normalizedName),
      defaultUnit: Value(defaultUnit),
      packUnitsCount: packUnitsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(packUnitsCount),
      suggestedRetailPrice: suggestedRetailPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedRetailPrice),
      lastPurchasePrice: lastPurchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchasePrice),
      lowestPurchasePrice: lowestPurchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(lowestPurchasePrice),
      lowestSupplierId: lowestSupplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(lowestSupplierId),
      updatedAt: Value(updatedAt),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      canonicalName: serializer.fromJson<String>(json['canonicalName']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      packUnitsCount: serializer.fromJson<int?>(json['packUnitsCount']),
      suggestedRetailPrice:
          serializer.fromJson<double?>(json['suggestedRetailPrice']),
      lastPurchasePrice:
          serializer.fromJson<double?>(json['lastPurchasePrice']),
      lowestPurchasePrice:
          serializer.fromJson<double?>(json['lowestPurchasePrice']),
      lowestSupplierId: serializer.fromJson<int?>(json['lowestSupplierId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'canonicalName': serializer.toJson<String>(canonicalName),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'packUnitsCount': serializer.toJson<int?>(packUnitsCount),
      'suggestedRetailPrice': serializer.toJson<double?>(suggestedRetailPrice),
      'lastPurchasePrice': serializer.toJson<double?>(lastPurchasePrice),
      'lowestPurchasePrice': serializer.toJson<double?>(lowestPurchasePrice),
      'lowestSupplierId': serializer.toJson<int?>(lowestSupplierId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Item copyWith(
          {int? id,
          String? canonicalName,
          String? normalizedName,
          String? defaultUnit,
          Value<int?> packUnitsCount = const Value.absent(),
          Value<double?> suggestedRetailPrice = const Value.absent(),
          Value<double?> lastPurchasePrice = const Value.absent(),
          Value<double?> lowestPurchasePrice = const Value.absent(),
          Value<int?> lowestSupplierId = const Value.absent(),
          DateTime? updatedAt}) =>
      Item(
        id: id ?? this.id,
        canonicalName: canonicalName ?? this.canonicalName,
        normalizedName: normalizedName ?? this.normalizedName,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        packUnitsCount:
            packUnitsCount.present ? packUnitsCount.value : this.packUnitsCount,
        suggestedRetailPrice: suggestedRetailPrice.present
            ? suggestedRetailPrice.value
            : this.suggestedRetailPrice,
        lastPurchasePrice: lastPurchasePrice.present
            ? lastPurchasePrice.value
            : this.lastPurchasePrice,
        lowestPurchasePrice: lowestPurchasePrice.present
            ? lowestPurchasePrice.value
            : this.lowestPurchasePrice,
        lowestSupplierId: lowestSupplierId.present
            ? lowestSupplierId.value
            : this.lowestSupplierId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      canonicalName: data.canonicalName.present
          ? data.canonicalName.value
          : this.canonicalName,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      packUnitsCount: data.packUnitsCount.present
          ? data.packUnitsCount.value
          : this.packUnitsCount,
      suggestedRetailPrice: data.suggestedRetailPrice.present
          ? data.suggestedRetailPrice.value
          : this.suggestedRetailPrice,
      lastPurchasePrice: data.lastPurchasePrice.present
          ? data.lastPurchasePrice.value
          : this.lastPurchasePrice,
      lowestPurchasePrice: data.lowestPurchasePrice.present
          ? data.lowestPurchasePrice.value
          : this.lowestPurchasePrice,
      lowestSupplierId: data.lowestSupplierId.present
          ? data.lowestSupplierId.value
          : this.lowestSupplierId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('packUnitsCount: $packUnitsCount, ')
          ..write('suggestedRetailPrice: $suggestedRetailPrice, ')
          ..write('lastPurchasePrice: $lastPurchasePrice, ')
          ..write('lowestPurchasePrice: $lowestPurchasePrice, ')
          ..write('lowestSupplierId: $lowestSupplierId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      canonicalName,
      normalizedName,
      defaultUnit,
      packUnitsCount,
      suggestedRetailPrice,
      lastPurchasePrice,
      lowestPurchasePrice,
      lowestSupplierId,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.canonicalName == this.canonicalName &&
          other.normalizedName == this.normalizedName &&
          other.defaultUnit == this.defaultUnit &&
          other.packUnitsCount == this.packUnitsCount &&
          other.suggestedRetailPrice == this.suggestedRetailPrice &&
          other.lastPurchasePrice == this.lastPurchasePrice &&
          other.lowestPurchasePrice == this.lowestPurchasePrice &&
          other.lowestSupplierId == this.lowestSupplierId &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> canonicalName;
  final Value<String> normalizedName;
  final Value<String> defaultUnit;
  final Value<int?> packUnitsCount;
  final Value<double?> suggestedRetailPrice;
  final Value<double?> lastPurchasePrice;
  final Value<double?> lowestPurchasePrice;
  final Value<int?> lowestSupplierId;
  final Value<DateTime> updatedAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.canonicalName = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.packUnitsCount = const Value.absent(),
    this.suggestedRetailPrice = const Value.absent(),
    this.lastPurchasePrice = const Value.absent(),
    this.lowestPurchasePrice = const Value.absent(),
    this.lowestSupplierId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String canonicalName,
    required String normalizedName,
    this.defaultUnit = const Value.absent(),
    this.packUnitsCount = const Value.absent(),
    this.suggestedRetailPrice = const Value.absent(),
    this.lastPurchasePrice = const Value.absent(),
    this.lowestPurchasePrice = const Value.absent(),
    this.lowestSupplierId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : canonicalName = Value(canonicalName),
        normalizedName = Value(normalizedName);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? canonicalName,
    Expression<String>? normalizedName,
    Expression<String>? defaultUnit,
    Expression<int>? packUnitsCount,
    Expression<double>? suggestedRetailPrice,
    Expression<double>? lastPurchasePrice,
    Expression<double>? lowestPurchasePrice,
    Expression<int>? lowestSupplierId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (canonicalName != null) 'canonical_name': canonicalName,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (packUnitsCount != null) 'pack_units_count': packUnitsCount,
      if (suggestedRetailPrice != null)
        'suggested_retail_price': suggestedRetailPrice,
      if (lastPurchasePrice != null) 'last_purchase_price': lastPurchasePrice,
      if (lowestPurchasePrice != null)
        'lowest_purchase_price': lowestPurchasePrice,
      if (lowestSupplierId != null) 'lowest_supplier_id': lowestSupplierId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? canonicalName,
      Value<String>? normalizedName,
      Value<String>? defaultUnit,
      Value<int?>? packUnitsCount,
      Value<double?>? suggestedRetailPrice,
      Value<double?>? lastPurchasePrice,
      Value<double?>? lowestPurchasePrice,
      Value<int?>? lowestSupplierId,
      Value<DateTime>? updatedAt}) {
    return ItemsCompanion(
      id: id ?? this.id,
      canonicalName: canonicalName ?? this.canonicalName,
      normalizedName: normalizedName ?? this.normalizedName,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      packUnitsCount: packUnitsCount ?? this.packUnitsCount,
      suggestedRetailPrice: suggestedRetailPrice ?? this.suggestedRetailPrice,
      lastPurchasePrice: lastPurchasePrice ?? this.lastPurchasePrice,
      lowestPurchasePrice: lowestPurchasePrice ?? this.lowestPurchasePrice,
      lowestSupplierId: lowestSupplierId ?? this.lowestSupplierId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (canonicalName.present) {
      map['canonical_name'] = Variable<String>(canonicalName.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (packUnitsCount.present) {
      map['pack_units_count'] = Variable<int>(packUnitsCount.value);
    }
    if (suggestedRetailPrice.present) {
      map['suggested_retail_price'] =
          Variable<double>(suggestedRetailPrice.value);
    }
    if (lastPurchasePrice.present) {
      map['last_purchase_price'] = Variable<double>(lastPurchasePrice.value);
    }
    if (lowestPurchasePrice.present) {
      map['lowest_purchase_price'] =
          Variable<double>(lowestPurchasePrice.value);
    }
    if (lowestSupplierId.present) {
      map['lowest_supplier_id'] = Variable<int>(lowestSupplierId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('packUnitsCount: $packUnitsCount, ')
          ..write('suggestedRetailPrice: $suggestedRetailPrice, ')
          ..write('lastPurchasePrice: $lastPurchasePrice, ')
          ..write('lowestPurchasePrice: $lowestPurchasePrice, ')
          ..write('lowestSupplierId: $lowestSupplierId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SupplierItemsTable extends SupplierItems
    with TableInfo<$SupplierItemsTable, SupplierItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES suppliers (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES items (id) ON DELETE CASCADE'));
  static const VerificationMeta _supplierItemCodeMeta =
      const VerificationMeta('supplierItemCode');
  @override
  late final GeneratedColumn<String> supplierItemCode = GeneratedColumn<String>(
      'supplier_item_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rawOcrNameMeta =
      const VerificationMeta('rawOcrName');
  @override
  late final GeneratedColumn<String> rawOcrName = GeneratedColumn<String>(
      'raw_ocr_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultUnitNameMeta =
      const VerificationMeta('defaultUnitName');
  @override
  late final GeneratedColumn<String> defaultUnitName = GeneratedColumn<String>(
      'default_unit_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUnitPriceMeta =
      const VerificationMeta('lastUnitPrice');
  @override
  late final GeneratedColumn<double> lastUnitPrice = GeneratedColumn<double>(
      'last_unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lastPurchaseDateMeta =
      const VerificationMeta('lastPurchaseDate');
  @override
  late final GeneratedColumn<DateTime> lastPurchaseDate =
      GeneratedColumn<DateTime>('last_purchase_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierId,
        itemId,
        supplierItemCode,
        rawOcrName,
        defaultUnitName,
        lastUnitPrice,
        lastPurchaseDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_items';
  @override
  VerificationContext validateIntegrity(Insertable<SupplierItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('supplier_item_code')) {
      context.handle(
          _supplierItemCodeMeta,
          supplierItemCode.isAcceptableOrUnknown(
              data['supplier_item_code']!, _supplierItemCodeMeta));
    }
    if (data.containsKey('raw_ocr_name')) {
      context.handle(
          _rawOcrNameMeta,
          rawOcrName.isAcceptableOrUnknown(
              data['raw_ocr_name']!, _rawOcrNameMeta));
    } else if (isInserting) {
      context.missing(_rawOcrNameMeta);
    }
    if (data.containsKey('default_unit_name')) {
      context.handle(
          _defaultUnitNameMeta,
          defaultUnitName.isAcceptableOrUnknown(
              data['default_unit_name']!, _defaultUnitNameMeta));
    }
    if (data.containsKey('last_unit_price')) {
      context.handle(
          _lastUnitPriceMeta,
          lastUnitPrice.isAcceptableOrUnknown(
              data['last_unit_price']!, _lastUnitPriceMeta));
    }
    if (data.containsKey('last_purchase_date')) {
      context.handle(
          _lastPurchaseDateMeta,
          lastPurchaseDate.isAcceptableOrUnknown(
              data['last_purchase_date']!, _lastPurchaseDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      supplierItemCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}supplier_item_code']),
      rawOcrName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_ocr_name'])!,
      defaultUnitName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_unit_name']),
      lastUnitPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}last_unit_price'])!,
      lastPurchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_purchase_date']),
    );
  }

  @override
  $SupplierItemsTable createAlias(String alias) {
    return $SupplierItemsTable(attachedDatabase, alias);
  }
}

class SupplierItem extends DataClass implements Insertable<SupplierItem> {
  final int id;
  final int supplierId;
  final int itemId;

  /// رقم الصنف لدى المورد (مثل 001180).
  final String? supplierItemCode;

  /// الاسم كما يطبع في فاتورة المورد.
  final String rawOcrName;
  final String? defaultUnitName;
  final double lastUnitPrice;
  final DateTime? lastPurchaseDate;
  const SupplierItem(
      {required this.id,
      required this.supplierId,
      required this.itemId,
      this.supplierItemCode,
      required this.rawOcrName,
      this.defaultUnitName,
      required this.lastUnitPrice,
      this.lastPurchaseDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['item_id'] = Variable<int>(itemId);
    if (!nullToAbsent || supplierItemCode != null) {
      map['supplier_item_code'] = Variable<String>(supplierItemCode);
    }
    map['raw_ocr_name'] = Variable<String>(rawOcrName);
    if (!nullToAbsent || defaultUnitName != null) {
      map['default_unit_name'] = Variable<String>(defaultUnitName);
    }
    map['last_unit_price'] = Variable<double>(lastUnitPrice);
    if (!nullToAbsent || lastPurchaseDate != null) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate);
    }
    return map;
  }

  SupplierItemsCompanion toCompanion(bool nullToAbsent) {
    return SupplierItemsCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      itemId: Value(itemId),
      supplierItemCode: supplierItemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierItemCode),
      rawOcrName: Value(rawOcrName),
      defaultUnitName: defaultUnitName == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultUnitName),
      lastUnitPrice: Value(lastUnitPrice),
      lastPurchaseDate: lastPurchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchaseDate),
    );
  }

  factory SupplierItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierItem(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      supplierItemCode: serializer.fromJson<String?>(json['supplierItemCode']),
      rawOcrName: serializer.fromJson<String>(json['rawOcrName']),
      defaultUnitName: serializer.fromJson<String?>(json['defaultUnitName']),
      lastUnitPrice: serializer.fromJson<double>(json['lastUnitPrice']),
      lastPurchaseDate:
          serializer.fromJson<DateTime?>(json['lastPurchaseDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'itemId': serializer.toJson<int>(itemId),
      'supplierItemCode': serializer.toJson<String?>(supplierItemCode),
      'rawOcrName': serializer.toJson<String>(rawOcrName),
      'defaultUnitName': serializer.toJson<String?>(defaultUnitName),
      'lastUnitPrice': serializer.toJson<double>(lastUnitPrice),
      'lastPurchaseDate': serializer.toJson<DateTime?>(lastPurchaseDate),
    };
  }

  SupplierItem copyWith(
          {int? id,
          int? supplierId,
          int? itemId,
          Value<String?> supplierItemCode = const Value.absent(),
          String? rawOcrName,
          Value<String?> defaultUnitName = const Value.absent(),
          double? lastUnitPrice,
          Value<DateTime?> lastPurchaseDate = const Value.absent()}) =>
      SupplierItem(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        itemId: itemId ?? this.itemId,
        supplierItemCode: supplierItemCode.present
            ? supplierItemCode.value
            : this.supplierItemCode,
        rawOcrName: rawOcrName ?? this.rawOcrName,
        defaultUnitName: defaultUnitName.present
            ? defaultUnitName.value
            : this.defaultUnitName,
        lastUnitPrice: lastUnitPrice ?? this.lastUnitPrice,
        lastPurchaseDate: lastPurchaseDate.present
            ? lastPurchaseDate.value
            : this.lastPurchaseDate,
      );
  SupplierItem copyWithCompanion(SupplierItemsCompanion data) {
    return SupplierItem(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      supplierItemCode: data.supplierItemCode.present
          ? data.supplierItemCode.value
          : this.supplierItemCode,
      rawOcrName:
          data.rawOcrName.present ? data.rawOcrName.value : this.rawOcrName,
      defaultUnitName: data.defaultUnitName.present
          ? data.defaultUnitName.value
          : this.defaultUnitName,
      lastUnitPrice: data.lastUnitPrice.present
          ? data.lastUnitPrice.value
          : this.lastUnitPrice,
      lastPurchaseDate: data.lastPurchaseDate.present
          ? data.lastPurchaseDate.value
          : this.lastPurchaseDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierItem(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('itemId: $itemId, ')
          ..write('supplierItemCode: $supplierItemCode, ')
          ..write('rawOcrName: $rawOcrName, ')
          ..write('defaultUnitName: $defaultUnitName, ')
          ..write('lastUnitPrice: $lastUnitPrice, ')
          ..write('lastPurchaseDate: $lastPurchaseDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, supplierId, itemId, supplierItemCode,
      rawOcrName, defaultUnitName, lastUnitPrice, lastPurchaseDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierItem &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.itemId == this.itemId &&
          other.supplierItemCode == this.supplierItemCode &&
          other.rawOcrName == this.rawOcrName &&
          other.defaultUnitName == this.defaultUnitName &&
          other.lastUnitPrice == this.lastUnitPrice &&
          other.lastPurchaseDate == this.lastPurchaseDate);
}

class SupplierItemsCompanion extends UpdateCompanion<SupplierItem> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<int> itemId;
  final Value<String?> supplierItemCode;
  final Value<String> rawOcrName;
  final Value<String?> defaultUnitName;
  final Value<double> lastUnitPrice;
  final Value<DateTime?> lastPurchaseDate;
  const SupplierItemsCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.supplierItemCode = const Value.absent(),
    this.rawOcrName = const Value.absent(),
    this.defaultUnitName = const Value.absent(),
    this.lastUnitPrice = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
  });
  SupplierItemsCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required int itemId,
    this.supplierItemCode = const Value.absent(),
    required String rawOcrName,
    this.defaultUnitName = const Value.absent(),
    this.lastUnitPrice = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
  })  : supplierId = Value(supplierId),
        itemId = Value(itemId),
        rawOcrName = Value(rawOcrName);
  static Insertable<SupplierItem> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<int>? itemId,
    Expression<String>? supplierItemCode,
    Expression<String>? rawOcrName,
    Expression<String>? defaultUnitName,
    Expression<double>? lastUnitPrice,
    Expression<DateTime>? lastPurchaseDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (itemId != null) 'item_id': itemId,
      if (supplierItemCode != null) 'supplier_item_code': supplierItemCode,
      if (rawOcrName != null) 'raw_ocr_name': rawOcrName,
      if (defaultUnitName != null) 'default_unit_name': defaultUnitName,
      if (lastUnitPrice != null) 'last_unit_price': lastUnitPrice,
      if (lastPurchaseDate != null) 'last_purchase_date': lastPurchaseDate,
    });
  }

  SupplierItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? supplierId,
      Value<int>? itemId,
      Value<String?>? supplierItemCode,
      Value<String>? rawOcrName,
      Value<String?>? defaultUnitName,
      Value<double>? lastUnitPrice,
      Value<DateTime?>? lastPurchaseDate}) {
    return SupplierItemsCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      itemId: itemId ?? this.itemId,
      supplierItemCode: supplierItemCode ?? this.supplierItemCode,
      rawOcrName: rawOcrName ?? this.rawOcrName,
      defaultUnitName: defaultUnitName ?? this.defaultUnitName,
      lastUnitPrice: lastUnitPrice ?? this.lastUnitPrice,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (supplierItemCode.present) {
      map['supplier_item_code'] = Variable<String>(supplierItemCode.value);
    }
    if (rawOcrName.present) {
      map['raw_ocr_name'] = Variable<String>(rawOcrName.value);
    }
    if (defaultUnitName.present) {
      map['default_unit_name'] = Variable<String>(defaultUnitName.value);
    }
    if (lastUnitPrice.present) {
      map['last_unit_price'] = Variable<double>(lastUnitPrice.value);
    }
    if (lastPurchaseDate.present) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierItemsCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('itemId: $itemId, ')
          ..write('supplierItemCode: $supplierItemCode, ')
          ..write('rawOcrName: $rawOcrName, ')
          ..write('defaultUnitName: $defaultUnitName, ')
          ..write('lastUnitPrice: $lastUnitPrice, ')
          ..write('lastPurchaseDate: $lastPurchaseDate')
          ..write(')'))
        .toString();
  }
}

class $PurchaseInvoicesTable extends PurchaseInvoices
    with TableInfo<$PurchaseInvoicesTable, PurchaseInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES suppliers (id) ON DELETE RESTRICT'));
  static const VerificationMeta _paperInvoiceNumberMeta =
      const VerificationMeta('paperInvoiceNumber');
  @override
  late final GeneratedColumn<String> paperInvoiceNumber =
      GeneratedColumn<String>('paper_invoice_number', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _invoiceDateMeta =
      const VerificationMeta('invoiceDate');
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
      'invoice_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _paymentTypeMeta =
      const VerificationMeta('paymentType');
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
      'payment_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('credit'));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _extraChargesMeta =
      const VerificationMeta('extraCharges');
  @override
  late final GeneratedColumn<double> extraCharges = GeneratedColumn<double>(
      'extra_charges', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netTotalMeta =
      const VerificationMeta('netTotal');
  @override
  late final GeneratedColumn<double> netTotal = GeneratedColumn<double>(
      'net_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _remainingAmountMeta =
      const VerificationMeta('remainingAmount');
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
      'remaining_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _printedTotalQtyMeta =
      const VerificationMeta('printedTotalQty');
  @override
  late final GeneratedColumn<double> printedTotalQty = GeneratedColumn<double>(
      'printed_total_qty', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _printedPrevBalanceMeta =
      const VerificationMeta('printedPrevBalance');
  @override
  late final GeneratedColumn<double> printedPrevBalance =
      GeneratedColumn<double>('printed_prev_balance', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _printedCurrBalanceMeta =
      const VerificationMeta('printedCurrBalance');
  @override
  late final GeneratedColumn<double> printedCurrBalance =
      GeneratedColumn<double>('printed_curr_balance', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _imagePathsJsonMeta =
      const VerificationMeta('imagePathsJson');
  @override
  late final GeneratedColumn<String> imagePathsJson = GeneratedColumn<String>(
      'image_paths_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _hasMathWarningMeta =
      const VerificationMeta('hasMathWarning');
  @override
  late final GeneratedColumn<bool> hasMathWarning = GeneratedColumn<bool>(
      'has_math_warning', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_math_warning" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('confirmed'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierId,
        paperInvoiceNumber,
        invoiceDate,
        currency,
        paymentType,
        subtotal,
        discount,
        extraCharges,
        netTotal,
        paidAmount,
        remainingAmount,
        printedTotalQty,
        printedPrevBalance,
        printedCurrBalance,
        imagePathsJson,
        hasMathWarning,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_invoices';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseInvoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('paper_invoice_number')) {
      context.handle(
          _paperInvoiceNumberMeta,
          paperInvoiceNumber.isAcceptableOrUnknown(
              data['paper_invoice_number']!, _paperInvoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_paperInvoiceNumberMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
          _invoiceDateMeta,
          invoiceDate.isAcceptableOrUnknown(
              data['invoice_date']!, _invoiceDateMeta));
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('payment_type')) {
      context.handle(
          _paymentTypeMeta,
          paymentType.isAcceptableOrUnknown(
              data['payment_type']!, _paymentTypeMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('extra_charges')) {
      context.handle(
          _extraChargesMeta,
          extraCharges.isAcceptableOrUnknown(
              data['extra_charges']!, _extraChargesMeta));
    }
    if (data.containsKey('net_total')) {
      context.handle(_netTotalMeta,
          netTotal.isAcceptableOrUnknown(data['net_total']!, _netTotalMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
          _remainingAmountMeta,
          remainingAmount.isAcceptableOrUnknown(
              data['remaining_amount']!, _remainingAmountMeta));
    }
    if (data.containsKey('printed_total_qty')) {
      context.handle(
          _printedTotalQtyMeta,
          printedTotalQty.isAcceptableOrUnknown(
              data['printed_total_qty']!, _printedTotalQtyMeta));
    }
    if (data.containsKey('printed_prev_balance')) {
      context.handle(
          _printedPrevBalanceMeta,
          printedPrevBalance.isAcceptableOrUnknown(
              data['printed_prev_balance']!, _printedPrevBalanceMeta));
    }
    if (data.containsKey('printed_curr_balance')) {
      context.handle(
          _printedCurrBalanceMeta,
          printedCurrBalance.isAcceptableOrUnknown(
              data['printed_curr_balance']!, _printedCurrBalanceMeta));
    }
    if (data.containsKey('image_paths_json')) {
      context.handle(
          _imagePathsJsonMeta,
          imagePathsJson.isAcceptableOrUnknown(
              data['image_paths_json']!, _imagePathsJsonMeta));
    }
    if (data.containsKey('has_math_warning')) {
      context.handle(
          _hasMathWarningMeta,
          hasMathWarning.isAcceptableOrUnknown(
              data['has_math_warning']!, _hasMathWarningMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseInvoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      paperInvoiceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}paper_invoice_number'])!,
      invoiceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}invoice_date'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      paymentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_type'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      extraCharges: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}extra_charges'])!,
      netTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_total'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      remainingAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_amount'])!,
      printedTotalQty: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}printed_total_qty']),
      printedPrevBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}printed_prev_balance']),
      printedCurrBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}printed_curr_balance']),
      imagePathsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_paths_json'])!,
      hasMathWarning: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_math_warning'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PurchaseInvoicesTable createAlias(String alias) {
    return $PurchaseInvoicesTable(attachedDatabase, alias);
  }
}

class PurchaseInvoice extends DataClass implements Insertable<PurchaseInvoice> {
  final int id;
  final int supplierId;

  /// رقم الفاتورة الورقية.
  final String paperInvoiceNumber;
  final DateTime invoiceDate;
  final String currency;

  /// 'credit' آجل / 'cash' نقدي / 'partial' جزئي.
  final String paymentType;
  final double subtotal;
  final double discount;

  /// الأعباء / المصاريف الإضافية.
  final double extraCharges;
  final double netTotal;
  final double paidAmount;

  /// المبلغ المرحل كدين.
  final double remainingAmount;

  /// عدد القطع المطبوع في التذييل.
  final double? printedTotalQty;

  /// الرصيد السابق المطبوع.
  final double? printedPrevBalance;

  /// الرصيد الحالي المطبوع.
  final double? printedCurrBalance;

  /// مسارات صور صفحات الفاتورة بصيغة JSON.
  final String imagePathsJson;
  final bool hasMathWarning;

  /// 'confirmed' / 'draft_offline'.
  final String status;
  final DateTime createdAt;
  const PurchaseInvoice(
      {required this.id,
      required this.supplierId,
      required this.paperInvoiceNumber,
      required this.invoiceDate,
      required this.currency,
      required this.paymentType,
      required this.subtotal,
      required this.discount,
      required this.extraCharges,
      required this.netTotal,
      required this.paidAmount,
      required this.remainingAmount,
      this.printedTotalQty,
      this.printedPrevBalance,
      this.printedCurrBalance,
      required this.imagePathsJson,
      required this.hasMathWarning,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['paper_invoice_number'] = Variable<String>(paperInvoiceNumber);
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['currency'] = Variable<String>(currency);
    map['payment_type'] = Variable<String>(paymentType);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['extra_charges'] = Variable<double>(extraCharges);
    map['net_total'] = Variable<double>(netTotal);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    if (!nullToAbsent || printedTotalQty != null) {
      map['printed_total_qty'] = Variable<double>(printedTotalQty);
    }
    if (!nullToAbsent || printedPrevBalance != null) {
      map['printed_prev_balance'] = Variable<double>(printedPrevBalance);
    }
    if (!nullToAbsent || printedCurrBalance != null) {
      map['printed_curr_balance'] = Variable<double>(printedCurrBalance);
    }
    map['image_paths_json'] = Variable<String>(imagePathsJson);
    map['has_math_warning'] = Variable<bool>(hasMathWarning);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseInvoicesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseInvoicesCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      paperInvoiceNumber: Value(paperInvoiceNumber),
      invoiceDate: Value(invoiceDate),
      currency: Value(currency),
      paymentType: Value(paymentType),
      subtotal: Value(subtotal),
      discount: Value(discount),
      extraCharges: Value(extraCharges),
      netTotal: Value(netTotal),
      paidAmount: Value(paidAmount),
      remainingAmount: Value(remainingAmount),
      printedTotalQty: printedTotalQty == null && nullToAbsent
          ? const Value.absent()
          : Value(printedTotalQty),
      printedPrevBalance: printedPrevBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(printedPrevBalance),
      printedCurrBalance: printedCurrBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(printedCurrBalance),
      imagePathsJson: Value(imagePathsJson),
      hasMathWarning: Value(hasMathWarning),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseInvoice(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      paperInvoiceNumber:
          serializer.fromJson<String>(json['paperInvoiceNumber']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      currency: serializer.fromJson<String>(json['currency']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      extraCharges: serializer.fromJson<double>(json['extraCharges']),
      netTotal: serializer.fromJson<double>(json['netTotal']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      printedTotalQty: serializer.fromJson<double?>(json['printedTotalQty']),
      printedPrevBalance:
          serializer.fromJson<double?>(json['printedPrevBalance']),
      printedCurrBalance:
          serializer.fromJson<double?>(json['printedCurrBalance']),
      imagePathsJson: serializer.fromJson<String>(json['imagePathsJson']),
      hasMathWarning: serializer.fromJson<bool>(json['hasMathWarning']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'paperInvoiceNumber': serializer.toJson<String>(paperInvoiceNumber),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'currency': serializer.toJson<String>(currency),
      'paymentType': serializer.toJson<String>(paymentType),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'extraCharges': serializer.toJson<double>(extraCharges),
      'netTotal': serializer.toJson<double>(netTotal),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'printedTotalQty': serializer.toJson<double?>(printedTotalQty),
      'printedPrevBalance': serializer.toJson<double?>(printedPrevBalance),
      'printedCurrBalance': serializer.toJson<double?>(printedCurrBalance),
      'imagePathsJson': serializer.toJson<String>(imagePathsJson),
      'hasMathWarning': serializer.toJson<bool>(hasMathWarning),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseInvoice copyWith(
          {int? id,
          int? supplierId,
          String? paperInvoiceNumber,
          DateTime? invoiceDate,
          String? currency,
          String? paymentType,
          double? subtotal,
          double? discount,
          double? extraCharges,
          double? netTotal,
          double? paidAmount,
          double? remainingAmount,
          Value<double?> printedTotalQty = const Value.absent(),
          Value<double?> printedPrevBalance = const Value.absent(),
          Value<double?> printedCurrBalance = const Value.absent(),
          String? imagePathsJson,
          bool? hasMathWarning,
          String? status,
          DateTime? createdAt}) =>
      PurchaseInvoice(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        paperInvoiceNumber: paperInvoiceNumber ?? this.paperInvoiceNumber,
        invoiceDate: invoiceDate ?? this.invoiceDate,
        currency: currency ?? this.currency,
        paymentType: paymentType ?? this.paymentType,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        extraCharges: extraCharges ?? this.extraCharges,
        netTotal: netTotal ?? this.netTotal,
        paidAmount: paidAmount ?? this.paidAmount,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        printedTotalQty: printedTotalQty.present
            ? printedTotalQty.value
            : this.printedTotalQty,
        printedPrevBalance: printedPrevBalance.present
            ? printedPrevBalance.value
            : this.printedPrevBalance,
        printedCurrBalance: printedCurrBalance.present
            ? printedCurrBalance.value
            : this.printedCurrBalance,
        imagePathsJson: imagePathsJson ?? this.imagePathsJson,
        hasMathWarning: hasMathWarning ?? this.hasMathWarning,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  PurchaseInvoice copyWithCompanion(PurchaseInvoicesCompanion data) {
    return PurchaseInvoice(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      paperInvoiceNumber: data.paperInvoiceNumber.present
          ? data.paperInvoiceNumber.value
          : this.paperInvoiceNumber,
      invoiceDate:
          data.invoiceDate.present ? data.invoiceDate.value : this.invoiceDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      paymentType:
          data.paymentType.present ? data.paymentType.value : this.paymentType,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      extraCharges: data.extraCharges.present
          ? data.extraCharges.value
          : this.extraCharges,
      netTotal: data.netTotal.present ? data.netTotal.value : this.netTotal,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      printedTotalQty: data.printedTotalQty.present
          ? data.printedTotalQty.value
          : this.printedTotalQty,
      printedPrevBalance: data.printedPrevBalance.present
          ? data.printedPrevBalance.value
          : this.printedPrevBalance,
      printedCurrBalance: data.printedCurrBalance.present
          ? data.printedCurrBalance.value
          : this.printedCurrBalance,
      imagePathsJson: data.imagePathsJson.present
          ? data.imagePathsJson.value
          : this.imagePathsJson,
      hasMathWarning: data.hasMathWarning.present
          ? data.hasMathWarning.value
          : this.hasMathWarning,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoice(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('paperInvoiceNumber: $paperInvoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('currency: $currency, ')
          ..write('paymentType: $paymentType, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('extraCharges: $extraCharges, ')
          ..write('netTotal: $netTotal, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('printedTotalQty: $printedTotalQty, ')
          ..write('printedPrevBalance: $printedPrevBalance, ')
          ..write('printedCurrBalance: $printedCurrBalance, ')
          ..write('imagePathsJson: $imagePathsJson, ')
          ..write('hasMathWarning: $hasMathWarning, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      supplierId,
      paperInvoiceNumber,
      invoiceDate,
      currency,
      paymentType,
      subtotal,
      discount,
      extraCharges,
      netTotal,
      paidAmount,
      remainingAmount,
      printedTotalQty,
      printedPrevBalance,
      printedCurrBalance,
      imagePathsJson,
      hasMathWarning,
      status,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseInvoice &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.paperInvoiceNumber == this.paperInvoiceNumber &&
          other.invoiceDate == this.invoiceDate &&
          other.currency == this.currency &&
          other.paymentType == this.paymentType &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.extraCharges == this.extraCharges &&
          other.netTotal == this.netTotal &&
          other.paidAmount == this.paidAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.printedTotalQty == this.printedTotalQty &&
          other.printedPrevBalance == this.printedPrevBalance &&
          other.printedCurrBalance == this.printedCurrBalance &&
          other.imagePathsJson == this.imagePathsJson &&
          other.hasMathWarning == this.hasMathWarning &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class PurchaseInvoicesCompanion extends UpdateCompanion<PurchaseInvoice> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<String> paperInvoiceNumber;
  final Value<DateTime> invoiceDate;
  final Value<String> currency;
  final Value<String> paymentType;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> extraCharges;
  final Value<double> netTotal;
  final Value<double> paidAmount;
  final Value<double> remainingAmount;
  final Value<double?> printedTotalQty;
  final Value<double?> printedPrevBalance;
  final Value<double?> printedCurrBalance;
  final Value<String> imagePathsJson;
  final Value<bool> hasMathWarning;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const PurchaseInvoicesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.paperInvoiceNumber = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.extraCharges = const Value.absent(),
    this.netTotal = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.printedTotalQty = const Value.absent(),
    this.printedPrevBalance = const Value.absent(),
    this.printedCurrBalance = const Value.absent(),
    this.imagePathsJson = const Value.absent(),
    this.hasMathWarning = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchaseInvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required String paperInvoiceNumber,
    required DateTime invoiceDate,
    this.currency = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.extraCharges = const Value.absent(),
    this.netTotal = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.printedTotalQty = const Value.absent(),
    this.printedPrevBalance = const Value.absent(),
    this.printedCurrBalance = const Value.absent(),
    this.imagePathsJson = const Value.absent(),
    this.hasMathWarning = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : supplierId = Value(supplierId),
        paperInvoiceNumber = Value(paperInvoiceNumber),
        invoiceDate = Value(invoiceDate);
  static Insertable<PurchaseInvoice> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? paperInvoiceNumber,
    Expression<DateTime>? invoiceDate,
    Expression<String>? currency,
    Expression<String>? paymentType,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? extraCharges,
    Expression<double>? netTotal,
    Expression<double>? paidAmount,
    Expression<double>? remainingAmount,
    Expression<double>? printedTotalQty,
    Expression<double>? printedPrevBalance,
    Expression<double>? printedCurrBalance,
    Expression<String>? imagePathsJson,
    Expression<bool>? hasMathWarning,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (paperInvoiceNumber != null)
        'paper_invoice_number': paperInvoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (currency != null) 'currency': currency,
      if (paymentType != null) 'payment_type': paymentType,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (extraCharges != null) 'extra_charges': extraCharges,
      if (netTotal != null) 'net_total': netTotal,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (printedTotalQty != null) 'printed_total_qty': printedTotalQty,
      if (printedPrevBalance != null)
        'printed_prev_balance': printedPrevBalance,
      if (printedCurrBalance != null)
        'printed_curr_balance': printedCurrBalance,
      if (imagePathsJson != null) 'image_paths_json': imagePathsJson,
      if (hasMathWarning != null) 'has_math_warning': hasMathWarning,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchaseInvoicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? supplierId,
      Value<String>? paperInvoiceNumber,
      Value<DateTime>? invoiceDate,
      Value<String>? currency,
      Value<String>? paymentType,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<double>? extraCharges,
      Value<double>? netTotal,
      Value<double>? paidAmount,
      Value<double>? remainingAmount,
      Value<double?>? printedTotalQty,
      Value<double?>? printedPrevBalance,
      Value<double?>? printedCurrBalance,
      Value<String>? imagePathsJson,
      Value<bool>? hasMathWarning,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return PurchaseInvoicesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      paperInvoiceNumber: paperInvoiceNumber ?? this.paperInvoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      currency: currency ?? this.currency,
      paymentType: paymentType ?? this.paymentType,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      extraCharges: extraCharges ?? this.extraCharges,
      netTotal: netTotal ?? this.netTotal,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      printedTotalQty: printedTotalQty ?? this.printedTotalQty,
      printedPrevBalance: printedPrevBalance ?? this.printedPrevBalance,
      printedCurrBalance: printedCurrBalance ?? this.printedCurrBalance,
      imagePathsJson: imagePathsJson ?? this.imagePathsJson,
      hasMathWarning: hasMathWarning ?? this.hasMathWarning,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (paperInvoiceNumber.present) {
      map['paper_invoice_number'] = Variable<String>(paperInvoiceNumber.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (extraCharges.present) {
      map['extra_charges'] = Variable<double>(extraCharges.value);
    }
    if (netTotal.present) {
      map['net_total'] = Variable<double>(netTotal.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (printedTotalQty.present) {
      map['printed_total_qty'] = Variable<double>(printedTotalQty.value);
    }
    if (printedPrevBalance.present) {
      map['printed_prev_balance'] = Variable<double>(printedPrevBalance.value);
    }
    if (printedCurrBalance.present) {
      map['printed_curr_balance'] = Variable<double>(printedCurrBalance.value);
    }
    if (imagePathsJson.present) {
      map['image_paths_json'] = Variable<String>(imagePathsJson.value);
    }
    if (hasMathWarning.present) {
      map['has_math_warning'] = Variable<bool>(hasMathWarning.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('paperInvoiceNumber: $paperInvoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('currency: $currency, ')
          ..write('paymentType: $paymentType, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('extraCharges: $extraCharges, ')
          ..write('netTotal: $netTotal, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('printedTotalQty: $printedTotalQty, ')
          ..write('printedPrevBalance: $printedPrevBalance, ')
          ..write('printedCurrBalance: $printedCurrBalance, ')
          ..write('imagePathsJson: $imagePathsJson, ')
          ..write('hasMathWarning: $hasMathWarning, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceLinesTable extends InvoiceLines
    with TableInfo<$InvoiceLinesTable, InvoiceLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchase_invoices (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES items (id) ON DELETE RESTRICT'));
  static const VerificationMeta _lineNumberMeta =
      const VerificationMeta('lineNumber');
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
      'line_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _supplierItemCodeMeta =
      const VerificationMeta('supplierItemCode');
  @override
  late final GeneratedColumn<String> supplierItemCode = GeneratedColumn<String>(
      'supplier_item_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rawItemNameMeta =
      const VerificationMeta('rawItemName');
  @override
  late final GeneratedColumn<String> rawItemName = GeneratedColumn<String>(
      'raw_item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitNameMeta =
      const VerificationMeta('unitName');
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
      'unit_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('كرتون'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _quantityWordsMeta =
      const VerificationMeta('quantityWords');
  @override
  late final GeneratedColumn<String> quantityWords = GeneratedColumn<String>(
      'quantity_words', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _freeQuantityMeta =
      const VerificationMeta('freeQuantity');
  @override
  late final GeneratedColumn<double> freeQuantity = GeneratedColumn<double>(
      'free_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _effectiveUnitCostMeta =
      const VerificationMeta('effectiveUnitCost');
  @override
  late final GeneratedColumn<double> effectiveUnitCost =
      GeneratedColumn<double>('effective_unit_cost', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _singlePieceCostMeta =
      const VerificationMeta('singlePieceCost');
  @override
  late final GeneratedColumn<double> singlePieceCost = GeneratedColumn<double>(
      'single_piece_cost', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _previousUnitPriceMeta =
      const VerificationMeta('previousUnitPrice');
  @override
  late final GeneratedColumn<double> previousUnitPrice =
      GeneratedColumn<double>('previous_unit_price', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _priceDiffAmountMeta =
      const VerificationMeta('priceDiffAmount');
  @override
  late final GeneratedColumn<double> priceDiffAmount = GeneratedColumn<double>(
      'price_diff_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _needsReviewMeta =
      const VerificationMeta('needsReview');
  @override
  late final GeneratedColumn<bool> needsReview = GeneratedColumn<bool>(
      'needs_review', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("needs_review" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        itemId,
        lineNumber,
        supplierItemCode,
        rawItemName,
        unitName,
        quantity,
        quantityWords,
        freeQuantity,
        unitPrice,
        lineTotal,
        effectiveUnitCost,
        singlePieceCost,
        previousUnitPrice,
        priceDiffAmount,
        needsReview
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_lines';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
          _lineNumberMeta,
          lineNumber.isAcceptableOrUnknown(
              data['line_number']!, _lineNumberMeta));
    }
    if (data.containsKey('supplier_item_code')) {
      context.handle(
          _supplierItemCodeMeta,
          supplierItemCode.isAcceptableOrUnknown(
              data['supplier_item_code']!, _supplierItemCodeMeta));
    }
    if (data.containsKey('raw_item_name')) {
      context.handle(
          _rawItemNameMeta,
          rawItemName.isAcceptableOrUnknown(
              data['raw_item_name']!, _rawItemNameMeta));
    } else if (isInserting) {
      context.missing(_rawItemNameMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(_unitNameMeta,
          unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('quantity_words')) {
      context.handle(
          _quantityWordsMeta,
          quantityWords.isAcceptableOrUnknown(
              data['quantity_words']!, _quantityWordsMeta));
    }
    if (data.containsKey('free_quantity')) {
      context.handle(
          _freeQuantityMeta,
          freeQuantity.isAcceptableOrUnknown(
              data['free_quantity']!, _freeQuantityMeta));
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    }
    if (data.containsKey('effective_unit_cost')) {
      context.handle(
          _effectiveUnitCostMeta,
          effectiveUnitCost.isAcceptableOrUnknown(
              data['effective_unit_cost']!, _effectiveUnitCostMeta));
    }
    if (data.containsKey('single_piece_cost')) {
      context.handle(
          _singlePieceCostMeta,
          singlePieceCost.isAcceptableOrUnknown(
              data['single_piece_cost']!, _singlePieceCostMeta));
    }
    if (data.containsKey('previous_unit_price')) {
      context.handle(
          _previousUnitPriceMeta,
          previousUnitPrice.isAcceptableOrUnknown(
              data['previous_unit_price']!, _previousUnitPriceMeta));
    }
    if (data.containsKey('price_diff_amount')) {
      context.handle(
          _priceDiffAmountMeta,
          priceDiffAmount.isAcceptableOrUnknown(
              data['price_diff_amount']!, _priceDiffAmountMeta));
    }
    if (data.containsKey('needs_review')) {
      context.handle(
          _needsReviewMeta,
          needsReview.isAcceptableOrUnknown(
              data['needs_review']!, _needsReviewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      lineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_number'])!,
      supplierItemCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}supplier_item_code']),
      rawItemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_item_name'])!,
      unitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      quantityWords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quantity_words']),
      freeQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}free_quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      effectiveUnitCost: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}effective_unit_cost'])!,
      singlePieceCost: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}single_piece_cost']),
      previousUnitPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_unit_price']),
      priceDiffAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}price_diff_amount'])!,
      needsReview: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_review'])!,
    );
  }

  @override
  $InvoiceLinesTable createAlias(String alias) {
    return $InvoiceLinesTable(attachedDatabase, alias);
  }
}

class InvoiceLine extends DataClass implements Insertable<InvoiceLine> {
  final int id;
  final int invoiceId;
  final int itemId;
  final int lineNumber;
  final String? supplierItemCode;
  final String rawItemName;
  final String unitName;
  final double quantity;

  /// الكمية كتابةً (مثل: خمسة كرتون).
  final String? quantityWords;

  /// ك.المجانية / البونص.
  final double freeQuantity;
  final double unitPrice;
  final double lineTotal;

  /// تكلفة العبوة الفعلية بعد البونص.
  final double effectiveUnitCost;

  /// تكلفة الحبة الواحدة.
  final double? singlePieceCost;
  final double? previousUnitPrice;

  /// فرق السعر عن آخر شراء.
  final double priceDiffAmount;
  final bool needsReview;
  const InvoiceLine(
      {required this.id,
      required this.invoiceId,
      required this.itemId,
      required this.lineNumber,
      this.supplierItemCode,
      required this.rawItemName,
      required this.unitName,
      required this.quantity,
      this.quantityWords,
      required this.freeQuantity,
      required this.unitPrice,
      required this.lineTotal,
      required this.effectiveUnitCost,
      this.singlePieceCost,
      this.previousUnitPrice,
      required this.priceDiffAmount,
      required this.needsReview});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['item_id'] = Variable<int>(itemId);
    map['line_number'] = Variable<int>(lineNumber);
    if (!nullToAbsent || supplierItemCode != null) {
      map['supplier_item_code'] = Variable<String>(supplierItemCode);
    }
    map['raw_item_name'] = Variable<String>(rawItemName);
    map['unit_name'] = Variable<String>(unitName);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || quantityWords != null) {
      map['quantity_words'] = Variable<String>(quantityWords);
    }
    map['free_quantity'] = Variable<double>(freeQuantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['line_total'] = Variable<double>(lineTotal);
    map['effective_unit_cost'] = Variable<double>(effectiveUnitCost);
    if (!nullToAbsent || singlePieceCost != null) {
      map['single_piece_cost'] = Variable<double>(singlePieceCost);
    }
    if (!nullToAbsent || previousUnitPrice != null) {
      map['previous_unit_price'] = Variable<double>(previousUnitPrice);
    }
    map['price_diff_amount'] = Variable<double>(priceDiffAmount);
    map['needs_review'] = Variable<bool>(needsReview);
    return map;
  }

  InvoiceLinesCompanion toCompanion(bool nullToAbsent) {
    return InvoiceLinesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      itemId: Value(itemId),
      lineNumber: Value(lineNumber),
      supplierItemCode: supplierItemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierItemCode),
      rawItemName: Value(rawItemName),
      unitName: Value(unitName),
      quantity: Value(quantity),
      quantityWords: quantityWords == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityWords),
      freeQuantity: Value(freeQuantity),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
      effectiveUnitCost: Value(effectiveUnitCost),
      singlePieceCost: singlePieceCost == null && nullToAbsent
          ? const Value.absent()
          : Value(singlePieceCost),
      previousUnitPrice: previousUnitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(previousUnitPrice),
      priceDiffAmount: Value(priceDiffAmount),
      needsReview: Value(needsReview),
    );
  }

  factory InvoiceLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceLine(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
      supplierItemCode: serializer.fromJson<String?>(json['supplierItemCode']),
      rawItemName: serializer.fromJson<String>(json['rawItemName']),
      unitName: serializer.fromJson<String>(json['unitName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      quantityWords: serializer.fromJson<String?>(json['quantityWords']),
      freeQuantity: serializer.fromJson<double>(json['freeQuantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      effectiveUnitCost: serializer.fromJson<double>(json['effectiveUnitCost']),
      singlePieceCost: serializer.fromJson<double?>(json['singlePieceCost']),
      previousUnitPrice:
          serializer.fromJson<double?>(json['previousUnitPrice']),
      priceDiffAmount: serializer.fromJson<double>(json['priceDiffAmount']),
      needsReview: serializer.fromJson<bool>(json['needsReview']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'itemId': serializer.toJson<int>(itemId),
      'lineNumber': serializer.toJson<int>(lineNumber),
      'supplierItemCode': serializer.toJson<String?>(supplierItemCode),
      'rawItemName': serializer.toJson<String>(rawItemName),
      'unitName': serializer.toJson<String>(unitName),
      'quantity': serializer.toJson<double>(quantity),
      'quantityWords': serializer.toJson<String?>(quantityWords),
      'freeQuantity': serializer.toJson<double>(freeQuantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'effectiveUnitCost': serializer.toJson<double>(effectiveUnitCost),
      'singlePieceCost': serializer.toJson<double?>(singlePieceCost),
      'previousUnitPrice': serializer.toJson<double?>(previousUnitPrice),
      'priceDiffAmount': serializer.toJson<double>(priceDiffAmount),
      'needsReview': serializer.toJson<bool>(needsReview),
    };
  }

  InvoiceLine copyWith(
          {int? id,
          int? invoiceId,
          int? itemId,
          int? lineNumber,
          Value<String?> supplierItemCode = const Value.absent(),
          String? rawItemName,
          String? unitName,
          double? quantity,
          Value<String?> quantityWords = const Value.absent(),
          double? freeQuantity,
          double? unitPrice,
          double? lineTotal,
          double? effectiveUnitCost,
          Value<double?> singlePieceCost = const Value.absent(),
          Value<double?> previousUnitPrice = const Value.absent(),
          double? priceDiffAmount,
          bool? needsReview}) =>
      InvoiceLine(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        itemId: itemId ?? this.itemId,
        lineNumber: lineNumber ?? this.lineNumber,
        supplierItemCode: supplierItemCode.present
            ? supplierItemCode.value
            : this.supplierItemCode,
        rawItemName: rawItemName ?? this.rawItemName,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        quantityWords:
            quantityWords.present ? quantityWords.value : this.quantityWords,
        freeQuantity: freeQuantity ?? this.freeQuantity,
        unitPrice: unitPrice ?? this.unitPrice,
        lineTotal: lineTotal ?? this.lineTotal,
        effectiveUnitCost: effectiveUnitCost ?? this.effectiveUnitCost,
        singlePieceCost: singlePieceCost.present
            ? singlePieceCost.value
            : this.singlePieceCost,
        previousUnitPrice: previousUnitPrice.present
            ? previousUnitPrice.value
            : this.previousUnitPrice,
        priceDiffAmount: priceDiffAmount ?? this.priceDiffAmount,
        needsReview: needsReview ?? this.needsReview,
      );
  InvoiceLine copyWithCompanion(InvoiceLinesCompanion data) {
    return InvoiceLine(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      lineNumber:
          data.lineNumber.present ? data.lineNumber.value : this.lineNumber,
      supplierItemCode: data.supplierItemCode.present
          ? data.supplierItemCode.value
          : this.supplierItemCode,
      rawItemName:
          data.rawItemName.present ? data.rawItemName.value : this.rawItemName,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      quantityWords: data.quantityWords.present
          ? data.quantityWords.value
          : this.quantityWords,
      freeQuantity: data.freeQuantity.present
          ? data.freeQuantity.value
          : this.freeQuantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      effectiveUnitCost: data.effectiveUnitCost.present
          ? data.effectiveUnitCost.value
          : this.effectiveUnitCost,
      singlePieceCost: data.singlePieceCost.present
          ? data.singlePieceCost.value
          : this.singlePieceCost,
      previousUnitPrice: data.previousUnitPrice.present
          ? data.previousUnitPrice.value
          : this.previousUnitPrice,
      priceDiffAmount: data.priceDiffAmount.present
          ? data.priceDiffAmount.value
          : this.priceDiffAmount,
      needsReview:
          data.needsReview.present ? data.needsReview.value : this.needsReview,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLine(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemId: $itemId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('supplierItemCode: $supplierItemCode, ')
          ..write('rawItemName: $rawItemName, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity, ')
          ..write('quantityWords: $quantityWords, ')
          ..write('freeQuantity: $freeQuantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('effectiveUnitCost: $effectiveUnitCost, ')
          ..write('singlePieceCost: $singlePieceCost, ')
          ..write('previousUnitPrice: $previousUnitPrice, ')
          ..write('priceDiffAmount: $priceDiffAmount, ')
          ..write('needsReview: $needsReview')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceId,
      itemId,
      lineNumber,
      supplierItemCode,
      rawItemName,
      unitName,
      quantity,
      quantityWords,
      freeQuantity,
      unitPrice,
      lineTotal,
      effectiveUnitCost,
      singlePieceCost,
      previousUnitPrice,
      priceDiffAmount,
      needsReview);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceLine &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.itemId == this.itemId &&
          other.lineNumber == this.lineNumber &&
          other.supplierItemCode == this.supplierItemCode &&
          other.rawItemName == this.rawItemName &&
          other.unitName == this.unitName &&
          other.quantity == this.quantity &&
          other.quantityWords == this.quantityWords &&
          other.freeQuantity == this.freeQuantity &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal &&
          other.effectiveUnitCost == this.effectiveUnitCost &&
          other.singlePieceCost == this.singlePieceCost &&
          other.previousUnitPrice == this.previousUnitPrice &&
          other.priceDiffAmount == this.priceDiffAmount &&
          other.needsReview == this.needsReview);
}

class InvoiceLinesCompanion extends UpdateCompanion<InvoiceLine> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> itemId;
  final Value<int> lineNumber;
  final Value<String?> supplierItemCode;
  final Value<String> rawItemName;
  final Value<String> unitName;
  final Value<double> quantity;
  final Value<String?> quantityWords;
  final Value<double> freeQuantity;
  final Value<double> unitPrice;
  final Value<double> lineTotal;
  final Value<double> effectiveUnitCost;
  final Value<double?> singlePieceCost;
  final Value<double?> previousUnitPrice;
  final Value<double> priceDiffAmount;
  final Value<bool> needsReview;
  const InvoiceLinesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.lineNumber = const Value.absent(),
    this.supplierItemCode = const Value.absent(),
    this.rawItemName = const Value.absent(),
    this.unitName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.quantityWords = const Value.absent(),
    this.freeQuantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.effectiveUnitCost = const Value.absent(),
    this.singlePieceCost = const Value.absent(),
    this.previousUnitPrice = const Value.absent(),
    this.priceDiffAmount = const Value.absent(),
    this.needsReview = const Value.absent(),
  });
  InvoiceLinesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int itemId,
    this.lineNumber = const Value.absent(),
    this.supplierItemCode = const Value.absent(),
    required String rawItemName,
    this.unitName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.quantityWords = const Value.absent(),
    this.freeQuantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.effectiveUnitCost = const Value.absent(),
    this.singlePieceCost = const Value.absent(),
    this.previousUnitPrice = const Value.absent(),
    this.priceDiffAmount = const Value.absent(),
    this.needsReview = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        itemId = Value(itemId),
        rawItemName = Value(rawItemName);
  static Insertable<InvoiceLine> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? itemId,
    Expression<int>? lineNumber,
    Expression<String>? supplierItemCode,
    Expression<String>? rawItemName,
    Expression<String>? unitName,
    Expression<double>? quantity,
    Expression<String>? quantityWords,
    Expression<double>? freeQuantity,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
    Expression<double>? effectiveUnitCost,
    Expression<double>? singlePieceCost,
    Expression<double>? previousUnitPrice,
    Expression<double>? priceDiffAmount,
    Expression<bool>? needsReview,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (itemId != null) 'item_id': itemId,
      if (lineNumber != null) 'line_number': lineNumber,
      if (supplierItemCode != null) 'supplier_item_code': supplierItemCode,
      if (rawItemName != null) 'raw_item_name': rawItemName,
      if (unitName != null) 'unit_name': unitName,
      if (quantity != null) 'quantity': quantity,
      if (quantityWords != null) 'quantity_words': quantityWords,
      if (freeQuantity != null) 'free_quantity': freeQuantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (effectiveUnitCost != null) 'effective_unit_cost': effectiveUnitCost,
      if (singlePieceCost != null) 'single_piece_cost': singlePieceCost,
      if (previousUnitPrice != null) 'previous_unit_price': previousUnitPrice,
      if (priceDiffAmount != null) 'price_diff_amount': priceDiffAmount,
      if (needsReview != null) 'needs_review': needsReview,
    });
  }

  InvoiceLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<int>? itemId,
      Value<int>? lineNumber,
      Value<String?>? supplierItemCode,
      Value<String>? rawItemName,
      Value<String>? unitName,
      Value<double>? quantity,
      Value<String?>? quantityWords,
      Value<double>? freeQuantity,
      Value<double>? unitPrice,
      Value<double>? lineTotal,
      Value<double>? effectiveUnitCost,
      Value<double?>? singlePieceCost,
      Value<double?>? previousUnitPrice,
      Value<double>? priceDiffAmount,
      Value<bool>? needsReview}) {
    return InvoiceLinesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      itemId: itemId ?? this.itemId,
      lineNumber: lineNumber ?? this.lineNumber,
      supplierItemCode: supplierItemCode ?? this.supplierItemCode,
      rawItemName: rawItemName ?? this.rawItemName,
      unitName: unitName ?? this.unitName,
      quantity: quantity ?? this.quantity,
      quantityWords: quantityWords ?? this.quantityWords,
      freeQuantity: freeQuantity ?? this.freeQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      effectiveUnitCost: effectiveUnitCost ?? this.effectiveUnitCost,
      singlePieceCost: singlePieceCost ?? this.singlePieceCost,
      previousUnitPrice: previousUnitPrice ?? this.previousUnitPrice,
      priceDiffAmount: priceDiffAmount ?? this.priceDiffAmount,
      needsReview: needsReview ?? this.needsReview,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    if (supplierItemCode.present) {
      map['supplier_item_code'] = Variable<String>(supplierItemCode.value);
    }
    if (rawItemName.present) {
      map['raw_item_name'] = Variable<String>(rawItemName.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (quantityWords.present) {
      map['quantity_words'] = Variable<String>(quantityWords.value);
    }
    if (freeQuantity.present) {
      map['free_quantity'] = Variable<double>(freeQuantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (effectiveUnitCost.present) {
      map['effective_unit_cost'] = Variable<double>(effectiveUnitCost.value);
    }
    if (singlePieceCost.present) {
      map['single_piece_cost'] = Variable<double>(singlePieceCost.value);
    }
    if (previousUnitPrice.present) {
      map['previous_unit_price'] = Variable<double>(previousUnitPrice.value);
    }
    if (priceDiffAmount.present) {
      map['price_diff_amount'] = Variable<double>(priceDiffAmount.value);
    }
    if (needsReview.present) {
      map['needs_review'] = Variable<bool>(needsReview.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLinesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemId: $itemId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('supplierItemCode: $supplierItemCode, ')
          ..write('rawItemName: $rawItemName, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity, ')
          ..write('quantityWords: $quantityWords, ')
          ..write('freeQuantity: $freeQuantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('effectiveUnitCost: $effectiveUnitCost, ')
          ..write('singlePieceCost: $singlePieceCost, ')
          ..write('previousUnitPrice: $previousUnitPrice, ')
          ..write('priceDiffAmount: $priceDiffAmount, ')
          ..write('needsReview: $needsReview')
          ..write(')'))
        .toString();
  }
}

class $PaymentVouchersTable extends PaymentVouchers
    with TableInfo<$PaymentVouchersTable, PaymentVoucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentVouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES suppliers (id) ON DELETE RESTRICT'));
  static const VerificationMeta _linkedInvoiceIdMeta =
      const VerificationMeta('linkedInvoiceId');
  @override
  late final GeneratedColumn<int> linkedInvoiceId = GeneratedColumn<int>(
      'linked_invoice_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchase_invoices (id) ON DELETE SET NULL'));
  static const VerificationMeta _paperVoucherNumberMeta =
      const VerificationMeta('paperVoucherNumber');
  @override
  late final GeneratedColumn<String> paperVoucherNumber =
      GeneratedColumn<String>('paper_voucher_number', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voucherDateMeta =
      const VerificationMeta('voucherDate');
  @override
  late final GeneratedColumn<DateTime> voucherDate = GeneratedColumn<DateTime>(
      'voucher_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('YER'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _amountWordsMeta =
      const VerificationMeta('amountWords');
  @override
  late final GeneratedColumn<String> amountWords = GeneratedColumn<String>(
      'amount_words', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _statementNoteMeta =
      const VerificationMeta('statementNote');
  @override
  late final GeneratedColumn<String> statementNote = GeneratedColumn<String>(
      'statement_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _printedRemainingBalanceMeta =
      const VerificationMeta('printedRemainingBalance');
  @override
  late final GeneratedColumn<double> printedRemainingBalance =
      GeneratedColumn<double>('printed_remaining_balance', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierId,
        linkedInvoiceId,
        paperVoucherNumber,
        voucherDate,
        currency,
        amount,
        amountWords,
        paymentMethod,
        statementNote,
        printedRemainingBalance,
        imagePath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_vouchers';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentVoucher> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('linked_invoice_id')) {
      context.handle(
          _linkedInvoiceIdMeta,
          linkedInvoiceId.isAcceptableOrUnknown(
              data['linked_invoice_id']!, _linkedInvoiceIdMeta));
    }
    if (data.containsKey('paper_voucher_number')) {
      context.handle(
          _paperVoucherNumberMeta,
          paperVoucherNumber.isAcceptableOrUnknown(
              data['paper_voucher_number']!, _paperVoucherNumberMeta));
    } else if (isInserting) {
      context.missing(_paperVoucherNumberMeta);
    }
    if (data.containsKey('voucher_date')) {
      context.handle(
          _voucherDateMeta,
          voucherDate.isAcceptableOrUnknown(
              data['voucher_date']!, _voucherDateMeta));
    } else if (isInserting) {
      context.missing(_voucherDateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('amount_words')) {
      context.handle(
          _amountWordsMeta,
          amountWords.isAcceptableOrUnknown(
              data['amount_words']!, _amountWordsMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('statement_note')) {
      context.handle(
          _statementNoteMeta,
          statementNote.isAcceptableOrUnknown(
              data['statement_note']!, _statementNoteMeta));
    }
    if (data.containsKey('printed_remaining_balance')) {
      context.handle(
          _printedRemainingBalanceMeta,
          printedRemainingBalance.isAcceptableOrUnknown(
              data['printed_remaining_balance']!,
              _printedRemainingBalanceMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentVoucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentVoucher(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      linkedInvoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}linked_invoice_id']),
      paperVoucherNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}paper_voucher_number'])!,
      voucherDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}voucher_date'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      amountWords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount_words']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      statementNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statement_note']),
      printedRemainingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}printed_remaining_balance']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentVouchersTable createAlias(String alias) {
    return $PaymentVouchersTable(attachedDatabase, alias);
  }
}

class PaymentVoucher extends DataClass implements Insertable<PaymentVoucher> {
  final int id;
  final int supplierId;
  final int? linkedInvoiceId;

  /// رقم السند الورقي.
  final String paperVoucherNumber;
  final DateTime voucherDate;
  final String currency;
  final double amount;

  /// المبلغ كتابةً.
  final String? amountWords;

  /// نقداً / حوالة.
  final String paymentMethod;

  /// البيان مثل: لكم نقداً من الحساب.
  final String? statementNote;

  /// الرصيد المتبقي المطبوع في السند.
  final double? printedRemainingBalance;
  final String? imagePath;
  final DateTime createdAt;
  const PaymentVoucher(
      {required this.id,
      required this.supplierId,
      this.linkedInvoiceId,
      required this.paperVoucherNumber,
      required this.voucherDate,
      required this.currency,
      required this.amount,
      this.amountWords,
      required this.paymentMethod,
      this.statementNote,
      this.printedRemainingBalance,
      this.imagePath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    if (!nullToAbsent || linkedInvoiceId != null) {
      map['linked_invoice_id'] = Variable<int>(linkedInvoiceId);
    }
    map['paper_voucher_number'] = Variable<String>(paperVoucherNumber);
    map['voucher_date'] = Variable<DateTime>(voucherDate);
    map['currency'] = Variable<String>(currency);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || amountWords != null) {
      map['amount_words'] = Variable<String>(amountWords);
    }
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || statementNote != null) {
      map['statement_note'] = Variable<String>(statementNote);
    }
    if (!nullToAbsent || printedRemainingBalance != null) {
      map['printed_remaining_balance'] =
          Variable<double>(printedRemainingBalance);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentVouchersCompanion toCompanion(bool nullToAbsent) {
    return PaymentVouchersCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      linkedInvoiceId: linkedInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedInvoiceId),
      paperVoucherNumber: Value(paperVoucherNumber),
      voucherDate: Value(voucherDate),
      currency: Value(currency),
      amount: Value(amount),
      amountWords: amountWords == null && nullToAbsent
          ? const Value.absent()
          : Value(amountWords),
      paymentMethod: Value(paymentMethod),
      statementNote: statementNote == null && nullToAbsent
          ? const Value.absent()
          : Value(statementNote),
      printedRemainingBalance: printedRemainingBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(printedRemainingBalance),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentVoucher.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentVoucher(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      linkedInvoiceId: serializer.fromJson<int?>(json['linkedInvoiceId']),
      paperVoucherNumber:
          serializer.fromJson<String>(json['paperVoucherNumber']),
      voucherDate: serializer.fromJson<DateTime>(json['voucherDate']),
      currency: serializer.fromJson<String>(json['currency']),
      amount: serializer.fromJson<double>(json['amount']),
      amountWords: serializer.fromJson<String?>(json['amountWords']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      statementNote: serializer.fromJson<String?>(json['statementNote']),
      printedRemainingBalance:
          serializer.fromJson<double?>(json['printedRemainingBalance']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'linkedInvoiceId': serializer.toJson<int?>(linkedInvoiceId),
      'paperVoucherNumber': serializer.toJson<String>(paperVoucherNumber),
      'voucherDate': serializer.toJson<DateTime>(voucherDate),
      'currency': serializer.toJson<String>(currency),
      'amount': serializer.toJson<double>(amount),
      'amountWords': serializer.toJson<String?>(amountWords),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'statementNote': serializer.toJson<String?>(statementNote),
      'printedRemainingBalance':
          serializer.toJson<double?>(printedRemainingBalance),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentVoucher copyWith(
          {int? id,
          int? supplierId,
          Value<int?> linkedInvoiceId = const Value.absent(),
          String? paperVoucherNumber,
          DateTime? voucherDate,
          String? currency,
          double? amount,
          Value<String?> amountWords = const Value.absent(),
          String? paymentMethod,
          Value<String?> statementNote = const Value.absent(),
          Value<double?> printedRemainingBalance = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentVoucher(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        linkedInvoiceId: linkedInvoiceId.present
            ? linkedInvoiceId.value
            : this.linkedInvoiceId,
        paperVoucherNumber: paperVoucherNumber ?? this.paperVoucherNumber,
        voucherDate: voucherDate ?? this.voucherDate,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
        amountWords: amountWords.present ? amountWords.value : this.amountWords,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        statementNote:
            statementNote.present ? statementNote.value : this.statementNote,
        printedRemainingBalance: printedRemainingBalance.present
            ? printedRemainingBalance.value
            : this.printedRemainingBalance,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        createdAt: createdAt ?? this.createdAt,
      );
  PaymentVoucher copyWithCompanion(PaymentVouchersCompanion data) {
    return PaymentVoucher(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      linkedInvoiceId: data.linkedInvoiceId.present
          ? data.linkedInvoiceId.value
          : this.linkedInvoiceId,
      paperVoucherNumber: data.paperVoucherNumber.present
          ? data.paperVoucherNumber.value
          : this.paperVoucherNumber,
      voucherDate:
          data.voucherDate.present ? data.voucherDate.value : this.voucherDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountWords:
          data.amountWords.present ? data.amountWords.value : this.amountWords,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      statementNote: data.statementNote.present
          ? data.statementNote.value
          : this.statementNote,
      printedRemainingBalance: data.printedRemainingBalance.present
          ? data.printedRemainingBalance.value
          : this.printedRemainingBalance,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentVoucher(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('linkedInvoiceId: $linkedInvoiceId, ')
          ..write('paperVoucherNumber: $paperVoucherNumber, ')
          ..write('voucherDate: $voucherDate, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('amountWords: $amountWords, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('statementNote: $statementNote, ')
          ..write('printedRemainingBalance: $printedRemainingBalance, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      supplierId,
      linkedInvoiceId,
      paperVoucherNumber,
      voucherDate,
      currency,
      amount,
      amountWords,
      paymentMethod,
      statementNote,
      printedRemainingBalance,
      imagePath,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentVoucher &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.linkedInvoiceId == this.linkedInvoiceId &&
          other.paperVoucherNumber == this.paperVoucherNumber &&
          other.voucherDate == this.voucherDate &&
          other.currency == this.currency &&
          other.amount == this.amount &&
          other.amountWords == this.amountWords &&
          other.paymentMethod == this.paymentMethod &&
          other.statementNote == this.statementNote &&
          other.printedRemainingBalance == this.printedRemainingBalance &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt);
}

class PaymentVouchersCompanion extends UpdateCompanion<PaymentVoucher> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<int?> linkedInvoiceId;
  final Value<String> paperVoucherNumber;
  final Value<DateTime> voucherDate;
  final Value<String> currency;
  final Value<double> amount;
  final Value<String?> amountWords;
  final Value<String> paymentMethod;
  final Value<String?> statementNote;
  final Value<double?> printedRemainingBalance;
  final Value<String?> imagePath;
  final Value<DateTime> createdAt;
  const PaymentVouchersCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.linkedInvoiceId = const Value.absent(),
    this.paperVoucherNumber = const Value.absent(),
    this.voucherDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountWords = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.statementNote = const Value.absent(),
    this.printedRemainingBalance = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentVouchersCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    this.linkedInvoiceId = const Value.absent(),
    required String paperVoucherNumber,
    required DateTime voucherDate,
    this.currency = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountWords = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.statementNote = const Value.absent(),
    this.printedRemainingBalance = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : supplierId = Value(supplierId),
        paperVoucherNumber = Value(paperVoucherNumber),
        voucherDate = Value(voucherDate);
  static Insertable<PaymentVoucher> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<int>? linkedInvoiceId,
    Expression<String>? paperVoucherNumber,
    Expression<DateTime>? voucherDate,
    Expression<String>? currency,
    Expression<double>? amount,
    Expression<String>? amountWords,
    Expression<String>? paymentMethod,
    Expression<String>? statementNote,
    Expression<double>? printedRemainingBalance,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (linkedInvoiceId != null) 'linked_invoice_id': linkedInvoiceId,
      if (paperVoucherNumber != null)
        'paper_voucher_number': paperVoucherNumber,
      if (voucherDate != null) 'voucher_date': voucherDate,
      if (currency != null) 'currency': currency,
      if (amount != null) 'amount': amount,
      if (amountWords != null) 'amount_words': amountWords,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (statementNote != null) 'statement_note': statementNote,
      if (printedRemainingBalance != null)
        'printed_remaining_balance': printedRemainingBalance,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentVouchersCompanion copyWith(
      {Value<int>? id,
      Value<int>? supplierId,
      Value<int?>? linkedInvoiceId,
      Value<String>? paperVoucherNumber,
      Value<DateTime>? voucherDate,
      Value<String>? currency,
      Value<double>? amount,
      Value<String?>? amountWords,
      Value<String>? paymentMethod,
      Value<String?>? statementNote,
      Value<double?>? printedRemainingBalance,
      Value<String?>? imagePath,
      Value<DateTime>? createdAt}) {
    return PaymentVouchersCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      linkedInvoiceId: linkedInvoiceId ?? this.linkedInvoiceId,
      paperVoucherNumber: paperVoucherNumber ?? this.paperVoucherNumber,
      voucherDate: voucherDate ?? this.voucherDate,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      amountWords: amountWords ?? this.amountWords,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      statementNote: statementNote ?? this.statementNote,
      printedRemainingBalance:
          printedRemainingBalance ?? this.printedRemainingBalance,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (linkedInvoiceId.present) {
      map['linked_invoice_id'] = Variable<int>(linkedInvoiceId.value);
    }
    if (paperVoucherNumber.present) {
      map['paper_voucher_number'] = Variable<String>(paperVoucherNumber.value);
    }
    if (voucherDate.present) {
      map['voucher_date'] = Variable<DateTime>(voucherDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountWords.present) {
      map['amount_words'] = Variable<String>(amountWords.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (statementNote.present) {
      map['statement_note'] = Variable<String>(statementNote.value);
    }
    if (printedRemainingBalance.present) {
      map['printed_remaining_balance'] =
          Variable<double>(printedRemainingBalance.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentVouchersCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('linkedInvoiceId: $linkedInvoiceId, ')
          ..write('paperVoucherNumber: $paperVoucherNumber, ')
          ..write('voucherDate: $voucherDate, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('amountWords: $amountWords, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('statementNote: $statementNote, ')
          ..write('printedRemainingBalance: $printedRemainingBalance, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $SupplierItemsTable supplierItems = $SupplierItemsTable(this);
  late final $PurchaseInvoicesTable purchaseInvoices =
      $PurchaseInvoicesTable(this);
  late final $InvoiceLinesTable invoiceLines = $InvoiceLinesTable(this);
  late final $PaymentVouchersTable paymentVouchers =
      $PaymentVouchersTable(this);
  late final Index idxItemsNormalized = Index('idx_items_normalized',
      'CREATE INDEX idx_items_normalized ON items (normalized_name)');
  late final Index idxSupplierItemsCode = Index('idx_supplier_items_code',
      'CREATE INDEX idx_supplier_items_code ON supplier_items (supplier_item_code)');
  late final SuppliersDao suppliersDao = SuppliersDao(this as AppDatabase);
  late final CatalogDao catalogDao = CatalogDao(this as AppDatabase);
  late final InvoicesDao invoicesDao = InvoicesDao(this as AppDatabase);
  late final VouchersDao vouchersDao = VouchersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        suppliers,
        items,
        supplierItems,
        purchaseInvoices,
        invoiceLines,
        paymentVouchers,
        idxItemsNormalized,
        idxSupplierItemsCode
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('suppliers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('supplier_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('items',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('supplier_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchase_invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('invoice_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchase_invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payment_vouchers', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> branchName,
  Value<String?> analyticAccountNo,
  Value<String> phonesJson,
  Value<String> ocrAliasesJson,
  Value<String> currency,
  Value<double> openingBalance,
  Value<double> currentCalculatedBalance,
  Value<double?> lastPrintedSupplierBalance,
  Value<DateTime?> lastBalanceDocDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> branchName,
  Value<String?> analyticAccountNo,
  Value<String> phonesJson,
  Value<String> ocrAliasesJson,
  Value<String> currency,
  Value<double> openingBalance,
  Value<double> currentCalculatedBalance,
  Value<double?> lastPrintedSupplierBalance,
  Value<DateTime?> lastBalanceDocDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SuppliersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SuppliersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> branchName = const Value.absent(),
            Value<String?> analyticAccountNo = const Value.absent(),
            Value<String> phonesJson = const Value.absent(),
            Value<String> ocrAliasesJson = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double> currentCalculatedBalance = const Value.absent(),
            Value<double?> lastPrintedSupplierBalance = const Value.absent(),
            Value<DateTime?> lastBalanceDocDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            branchName: branchName,
            analyticAccountNo: analyticAccountNo,
            phonesJson: phonesJson,
            ocrAliasesJson: ocrAliasesJson,
            currency: currency,
            openingBalance: openingBalance,
            currentCalculatedBalance: currentCalculatedBalance,
            lastPrintedSupplierBalance: lastPrintedSupplierBalance,
            lastBalanceDocDate: lastBalanceDocDate,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> branchName = const Value.absent(),
            Value<String?> analyticAccountNo = const Value.absent(),
            Value<String> phonesJson = const Value.absent(),
            Value<String> ocrAliasesJson = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double> currentCalculatedBalance = const Value.absent(),
            Value<double?> lastPrintedSupplierBalance = const Value.absent(),
            Value<DateTime?> lastBalanceDocDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            branchName: branchName,
            analyticAccountNo: analyticAccountNo,
            phonesJson: phonesJson,
            ocrAliasesJson: ocrAliasesJson,
            currency: currency,
            openingBalance: openingBalance,
            currentCalculatedBalance: currentCalculatedBalance,
            lastPrintedSupplierBalance: lastPrintedSupplierBalance,
            lastBalanceDocDate: lastBalanceDocDate,
            notes: notes,
            createdAt: createdAt,
          ),
        ));
}

class $$SuppliersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get branchName => $state.composableBuilder(
      column: $state.table.branchName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get analyticAccountNo => $state.composableBuilder(
      column: $state.table.analyticAccountNo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phonesJson => $state.composableBuilder(
      column: $state.table.phonesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ocrAliasesJson => $state.composableBuilder(
      column: $state.table.ocrAliasesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get openingBalance => $state.composableBuilder(
      column: $state.table.openingBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get currentCalculatedBalance =>
      $state.composableBuilder(
          column: $state.table.currentCalculatedBalance,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastPrintedSupplierBalance =>
      $state.composableBuilder(
          column: $state.table.lastPrintedSupplierBalance,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastBalanceDocDate => $state.composableBuilder(
      column: $state.table.lastBalanceDocDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter itemsRefs(
      ComposableFilter Function($$ItemsTableFilterComposer f) f) {
    final $$ItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.items,
        getReferencedColumn: (t) => t.lowestSupplierId,
        builder: (joinBuilder, parentComposers) => $$ItemsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.items, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter supplierItemsRefs(
      ComposableFilter Function($$SupplierItemsTableFilterComposer f) f) {
    final $$SupplierItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.supplierItems,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder, parentComposers) =>
            $$SupplierItemsTableFilterComposer(ComposerState($state.db,
                $state.db.supplierItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter purchaseInvoicesRefs(
      ComposableFilter Function($$PurchaseInvoicesTableFilterComposer f) f) {
    final $$PurchaseInvoicesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.purchaseInvoices,
            getReferencedColumn: (t) => t.supplierId,
            builder: (joinBuilder, parentComposers) =>
                $$PurchaseInvoicesTableFilterComposer(ComposerState($state.db,
                    $state.db.purchaseInvoices, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentVouchersRefs(
      ComposableFilter Function($$PaymentVouchersTableFilterComposer f) f) {
    final $$PaymentVouchersTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.paymentVouchers,
            getReferencedColumn: (t) => t.supplierId,
            builder: (joinBuilder, parentComposers) =>
                $$PaymentVouchersTableFilterComposer(ComposerState($state.db,
                    $state.db.paymentVouchers, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get branchName => $state.composableBuilder(
      column: $state.table.branchName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get analyticAccountNo => $state.composableBuilder(
      column: $state.table.analyticAccountNo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phonesJson => $state.composableBuilder(
      column: $state.table.phonesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ocrAliasesJson => $state.composableBuilder(
      column: $state.table.ocrAliasesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get openingBalance => $state.composableBuilder(
      column: $state.table.openingBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get currentCalculatedBalance =>
      $state.composableBuilder(
          column: $state.table.currentCalculatedBalance,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastPrintedSupplierBalance =>
      $state.composableBuilder(
          column: $state.table.lastPrintedSupplierBalance,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastBalanceDocDate => $state.composableBuilder(
      column: $state.table.lastBalanceDocDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required String canonicalName,
  required String normalizedName,
  Value<String> defaultUnit,
  Value<int?> packUnitsCount,
  Value<double?> suggestedRetailPrice,
  Value<double?> lastPurchasePrice,
  Value<double?> lowestPurchasePrice,
  Value<int?> lowestSupplierId,
  Value<DateTime> updatedAt,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<String> canonicalName,
  Value<String> normalizedName,
  Value<String> defaultUnit,
  Value<int?> packUnitsCount,
  Value<double?> suggestedRetailPrice,
  Value<double?> lastPurchasePrice,
  Value<double?> lowestPurchasePrice,
  Value<int?> lowestSupplierId,
  Value<DateTime> updatedAt,
});

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> canonicalName = const Value.absent(),
            Value<String> normalizedName = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<int?> packUnitsCount = const Value.absent(),
            Value<double?> suggestedRetailPrice = const Value.absent(),
            Value<double?> lastPurchasePrice = const Value.absent(),
            Value<double?> lowestPurchasePrice = const Value.absent(),
            Value<int?> lowestSupplierId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            canonicalName: canonicalName,
            normalizedName: normalizedName,
            defaultUnit: defaultUnit,
            packUnitsCount: packUnitsCount,
            suggestedRetailPrice: suggestedRetailPrice,
            lastPurchasePrice: lastPurchasePrice,
            lowestPurchasePrice: lowestPurchasePrice,
            lowestSupplierId: lowestSupplierId,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String canonicalName,
            required String normalizedName,
            Value<String> defaultUnit = const Value.absent(),
            Value<int?> packUnitsCount = const Value.absent(),
            Value<double?> suggestedRetailPrice = const Value.absent(),
            Value<double?> lastPurchasePrice = const Value.absent(),
            Value<double?> lowestPurchasePrice = const Value.absent(),
            Value<int?> lowestSupplierId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            canonicalName: canonicalName,
            normalizedName: normalizedName,
            defaultUnit: defaultUnit,
            packUnitsCount: packUnitsCount,
            suggestedRetailPrice: suggestedRetailPrice,
            lastPurchasePrice: lastPurchasePrice,
            lowestPurchasePrice: lowestPurchasePrice,
            lowestSupplierId: lowestSupplierId,
            updatedAt: updatedAt,
          ),
        ));
}

class $$ItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get canonicalName => $state.composableBuilder(
      column: $state.table.canonicalName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get normalizedName => $state.composableBuilder(
      column: $state.table.normalizedName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get defaultUnit => $state.composableBuilder(
      column: $state.table.defaultUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get packUnitsCount => $state.composableBuilder(
      column: $state.table.packUnitsCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get suggestedRetailPrice => $state.composableBuilder(
      column: $state.table.suggestedRetailPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastPurchasePrice => $state.composableBuilder(
      column: $state.table.lastPurchasePrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lowestPurchasePrice => $state.composableBuilder(
      column: $state.table.lowestPurchasePrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SuppliersTableFilterComposer get lowestSupplierId {
    final $$SuppliersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lowestSupplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableFilterComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter supplierItemsRefs(
      ComposableFilter Function($$SupplierItemsTableFilterComposer f) f) {
    final $$SupplierItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.supplierItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder, parentComposers) =>
            $$SupplierItemsTableFilterComposer(ComposerState($state.db,
                $state.db.supplierItems, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter invoiceLinesRefs(
      ComposableFilter Function($$InvoiceLinesTableFilterComposer f) f) {
    final $$InvoiceLinesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoiceLines,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoiceLinesTableFilterComposer(ComposerState($state.db,
                $state.db.invoiceLines, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get canonicalName => $state.composableBuilder(
      column: $state.table.canonicalName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get normalizedName => $state.composableBuilder(
      column: $state.table.normalizedName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get defaultUnit => $state.composableBuilder(
      column: $state.table.defaultUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get packUnitsCount => $state.composableBuilder(
      column: $state.table.packUnitsCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get suggestedRetailPrice => $state.composableBuilder(
      column: $state.table.suggestedRetailPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastPurchasePrice => $state.composableBuilder(
      column: $state.table.lastPurchasePrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lowestPurchasePrice => $state.composableBuilder(
      column: $state.table.lowestPurchasePrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SuppliersTableOrderingComposer get lowestSupplierId {
    final $$SuppliersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lowestSupplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableOrderingComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SupplierItemsTableCreateCompanionBuilder = SupplierItemsCompanion
    Function({
  Value<int> id,
  required int supplierId,
  required int itemId,
  Value<String?> supplierItemCode,
  required String rawOcrName,
  Value<String?> defaultUnitName,
  Value<double> lastUnitPrice,
  Value<DateTime?> lastPurchaseDate,
});
typedef $$SupplierItemsTableUpdateCompanionBuilder = SupplierItemsCompanion
    Function({
  Value<int> id,
  Value<int> supplierId,
  Value<int> itemId,
  Value<String?> supplierItemCode,
  Value<String> rawOcrName,
  Value<String?> defaultUnitName,
  Value<double> lastUnitPrice,
  Value<DateTime?> lastPurchaseDate,
});

class $$SupplierItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplierItemsTable,
    SupplierItem,
    $$SupplierItemsTableFilterComposer,
    $$SupplierItemsTableOrderingComposer,
    $$SupplierItemsTableCreateCompanionBuilder,
    $$SupplierItemsTableUpdateCompanionBuilder> {
  $$SupplierItemsTableTableManager(_$AppDatabase db, $SupplierItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SupplierItemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SupplierItemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String?> supplierItemCode = const Value.absent(),
            Value<String> rawOcrName = const Value.absent(),
            Value<String?> defaultUnitName = const Value.absent(),
            Value<double> lastUnitPrice = const Value.absent(),
            Value<DateTime?> lastPurchaseDate = const Value.absent(),
          }) =>
              SupplierItemsCompanion(
            id: id,
            supplierId: supplierId,
            itemId: itemId,
            supplierItemCode: supplierItemCode,
            rawOcrName: rawOcrName,
            defaultUnitName: defaultUnitName,
            lastUnitPrice: lastUnitPrice,
            lastPurchaseDate: lastPurchaseDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int supplierId,
            required int itemId,
            Value<String?> supplierItemCode = const Value.absent(),
            required String rawOcrName,
            Value<String?> defaultUnitName = const Value.absent(),
            Value<double> lastUnitPrice = const Value.absent(),
            Value<DateTime?> lastPurchaseDate = const Value.absent(),
          }) =>
              SupplierItemsCompanion.insert(
            id: id,
            supplierId: supplierId,
            itemId: itemId,
            supplierItemCode: supplierItemCode,
            rawOcrName: rawOcrName,
            defaultUnitName: defaultUnitName,
            lastUnitPrice: lastUnitPrice,
            lastPurchaseDate: lastPurchaseDate,
          ),
        ));
}

class $$SupplierItemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SupplierItemsTable> {
  $$SupplierItemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierItemCode => $state.composableBuilder(
      column: $state.table.supplierItemCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rawOcrName => $state.composableBuilder(
      column: $state.table.rawOcrName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get defaultUnitName => $state.composableBuilder(
      column: $state.table.defaultUnitName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastUnitPrice => $state.composableBuilder(
      column: $state.table.lastUnitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastPurchaseDate => $state.composableBuilder(
      column: $state.table.lastPurchaseDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableFilterComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $state.db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ItemsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.items, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$SupplierItemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SupplierItemsTable> {
  $$SupplierItemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierItemCode => $state.composableBuilder(
      column: $state.table.supplierItemCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rawOcrName => $state.composableBuilder(
      column: $state.table.rawOcrName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get defaultUnitName => $state.composableBuilder(
      column: $state.table.defaultUnitName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastUnitPrice => $state.composableBuilder(
      column: $state.table.lastUnitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastPurchaseDate => $state.composableBuilder(
      column: $state.table.lastPurchaseDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableOrderingComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $state.db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ItemsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.items, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PurchaseInvoicesTableCreateCompanionBuilder
    = PurchaseInvoicesCompanion Function({
  Value<int> id,
  required int supplierId,
  required String paperInvoiceNumber,
  required DateTime invoiceDate,
  Value<String> currency,
  Value<String> paymentType,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> extraCharges,
  Value<double> netTotal,
  Value<double> paidAmount,
  Value<double> remainingAmount,
  Value<double?> printedTotalQty,
  Value<double?> printedPrevBalance,
  Value<double?> printedCurrBalance,
  Value<String> imagePathsJson,
  Value<bool> hasMathWarning,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$PurchaseInvoicesTableUpdateCompanionBuilder
    = PurchaseInvoicesCompanion Function({
  Value<int> id,
  Value<int> supplierId,
  Value<String> paperInvoiceNumber,
  Value<DateTime> invoiceDate,
  Value<String> currency,
  Value<String> paymentType,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> extraCharges,
  Value<double> netTotal,
  Value<double> paidAmount,
  Value<double> remainingAmount,
  Value<double?> printedTotalQty,
  Value<double?> printedPrevBalance,
  Value<double?> printedCurrBalance,
  Value<String> imagePathsJson,
  Value<bool> hasMathWarning,
  Value<String> status,
  Value<DateTime> createdAt,
});

class $$PurchaseInvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseInvoicesTable,
    PurchaseInvoice,
    $$PurchaseInvoicesTableFilterComposer,
    $$PurchaseInvoicesTableOrderingComposer,
    $$PurchaseInvoicesTableCreateCompanionBuilder,
    $$PurchaseInvoicesTableUpdateCompanionBuilder> {
  $$PurchaseInvoicesTableTableManager(
      _$AppDatabase db, $PurchaseInvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PurchaseInvoicesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PurchaseInvoicesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<String> paperInvoiceNumber = const Value.absent(),
            Value<DateTime> invoiceDate = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> paymentType = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> extraCharges = const Value.absent(),
            Value<double> netTotal = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<double?> printedTotalQty = const Value.absent(),
            Value<double?> printedPrevBalance = const Value.absent(),
            Value<double?> printedCurrBalance = const Value.absent(),
            Value<String> imagePathsJson = const Value.absent(),
            Value<bool> hasMathWarning = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseInvoicesCompanion(
            id: id,
            supplierId: supplierId,
            paperInvoiceNumber: paperInvoiceNumber,
            invoiceDate: invoiceDate,
            currency: currency,
            paymentType: paymentType,
            subtotal: subtotal,
            discount: discount,
            extraCharges: extraCharges,
            netTotal: netTotal,
            paidAmount: paidAmount,
            remainingAmount: remainingAmount,
            printedTotalQty: printedTotalQty,
            printedPrevBalance: printedPrevBalance,
            printedCurrBalance: printedCurrBalance,
            imagePathsJson: imagePathsJson,
            hasMathWarning: hasMathWarning,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int supplierId,
            required String paperInvoiceNumber,
            required DateTime invoiceDate,
            Value<String> currency = const Value.absent(),
            Value<String> paymentType = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> extraCharges = const Value.absent(),
            Value<double> netTotal = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> remainingAmount = const Value.absent(),
            Value<double?> printedTotalQty = const Value.absent(),
            Value<double?> printedPrevBalance = const Value.absent(),
            Value<double?> printedCurrBalance = const Value.absent(),
            Value<String> imagePathsJson = const Value.absent(),
            Value<bool> hasMathWarning = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseInvoicesCompanion.insert(
            id: id,
            supplierId: supplierId,
            paperInvoiceNumber: paperInvoiceNumber,
            invoiceDate: invoiceDate,
            currency: currency,
            paymentType: paymentType,
            subtotal: subtotal,
            discount: discount,
            extraCharges: extraCharges,
            netTotal: netTotal,
            paidAmount: paidAmount,
            remainingAmount: remainingAmount,
            printedTotalQty: printedTotalQty,
            printedPrevBalance: printedPrevBalance,
            printedCurrBalance: printedCurrBalance,
            imagePathsJson: imagePathsJson,
            hasMathWarning: hasMathWarning,
            status: status,
            createdAt: createdAt,
          ),
        ));
}

class $$PurchaseInvoicesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paperInvoiceNumber => $state.composableBuilder(
      column: $state.table.paperInvoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get invoiceDate => $state.composableBuilder(
      column: $state.table.invoiceDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentType => $state.composableBuilder(
      column: $state.table.paymentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discount => $state.composableBuilder(
      column: $state.table.discount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get extraCharges => $state.composableBuilder(
      column: $state.table.extraCharges,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get netTotal => $state.composableBuilder(
      column: $state.table.netTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get paidAmount => $state.composableBuilder(
      column: $state.table.paidAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get remainingAmount => $state.composableBuilder(
      column: $state.table.remainingAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get printedTotalQty => $state.composableBuilder(
      column: $state.table.printedTotalQty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get printedPrevBalance => $state.composableBuilder(
      column: $state.table.printedPrevBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get printedCurrBalance => $state.composableBuilder(
      column: $state.table.printedCurrBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get imagePathsJson => $state.composableBuilder(
      column: $state.table.imagePathsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hasMathWarning => $state.composableBuilder(
      column: $state.table.hasMathWarning,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableFilterComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter invoiceLinesRefs(
      ComposableFilter Function($$InvoiceLinesTableFilterComposer f) f) {
    final $$InvoiceLinesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoiceLines,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoiceLinesTableFilterComposer(ComposerState($state.db,
                $state.db.invoiceLines, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter paymentVouchersRefs(
      ComposableFilter Function($$PaymentVouchersTableFilterComposer f) f) {
    final $$PaymentVouchersTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.paymentVouchers,
            getReferencedColumn: (t) => t.linkedInvoiceId,
            builder: (joinBuilder, parentComposers) =>
                $$PaymentVouchersTableFilterComposer(ComposerState($state.db,
                    $state.db.paymentVouchers, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PurchaseInvoicesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paperInvoiceNumber => $state.composableBuilder(
      column: $state.table.paperInvoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get invoiceDate => $state.composableBuilder(
      column: $state.table.invoiceDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentType => $state.composableBuilder(
      column: $state.table.paymentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discount => $state.composableBuilder(
      column: $state.table.discount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get extraCharges => $state.composableBuilder(
      column: $state.table.extraCharges,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get netTotal => $state.composableBuilder(
      column: $state.table.netTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get paidAmount => $state.composableBuilder(
      column: $state.table.paidAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get remainingAmount => $state.composableBuilder(
      column: $state.table.remainingAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get printedTotalQty => $state.composableBuilder(
      column: $state.table.printedTotalQty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get printedPrevBalance => $state.composableBuilder(
      column: $state.table.printedPrevBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get printedCurrBalance => $state.composableBuilder(
      column: $state.table.printedCurrBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get imagePathsJson => $state.composableBuilder(
      column: $state.table.imagePathsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hasMathWarning => $state.composableBuilder(
      column: $state.table.hasMathWarning,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableOrderingComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$InvoiceLinesTableCreateCompanionBuilder = InvoiceLinesCompanion
    Function({
  Value<int> id,
  required int invoiceId,
  required int itemId,
  Value<int> lineNumber,
  Value<String?> supplierItemCode,
  required String rawItemName,
  Value<String> unitName,
  Value<double> quantity,
  Value<String?> quantityWords,
  Value<double> freeQuantity,
  Value<double> unitPrice,
  Value<double> lineTotal,
  Value<double> effectiveUnitCost,
  Value<double?> singlePieceCost,
  Value<double?> previousUnitPrice,
  Value<double> priceDiffAmount,
  Value<bool> needsReview,
});
typedef $$InvoiceLinesTableUpdateCompanionBuilder = InvoiceLinesCompanion
    Function({
  Value<int> id,
  Value<int> invoiceId,
  Value<int> itemId,
  Value<int> lineNumber,
  Value<String?> supplierItemCode,
  Value<String> rawItemName,
  Value<String> unitName,
  Value<double> quantity,
  Value<String?> quantityWords,
  Value<double> freeQuantity,
  Value<double> unitPrice,
  Value<double> lineTotal,
  Value<double> effectiveUnitCost,
  Value<double?> singlePieceCost,
  Value<double?> previousUnitPrice,
  Value<double> priceDiffAmount,
  Value<bool> needsReview,
});

class $$InvoiceLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceLinesTable,
    InvoiceLine,
    $$InvoiceLinesTableFilterComposer,
    $$InvoiceLinesTableOrderingComposer,
    $$InvoiceLinesTableCreateCompanionBuilder,
    $$InvoiceLinesTableUpdateCompanionBuilder> {
  $$InvoiceLinesTableTableManager(_$AppDatabase db, $InvoiceLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InvoiceLinesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InvoiceLinesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> invoiceId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> lineNumber = const Value.absent(),
            Value<String?> supplierItemCode = const Value.absent(),
            Value<String> rawItemName = const Value.absent(),
            Value<String> unitName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String?> quantityWords = const Value.absent(),
            Value<double> freeQuantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<double> effectiveUnitCost = const Value.absent(),
            Value<double?> singlePieceCost = const Value.absent(),
            Value<double?> previousUnitPrice = const Value.absent(),
            Value<double> priceDiffAmount = const Value.absent(),
            Value<bool> needsReview = const Value.absent(),
          }) =>
              InvoiceLinesCompanion(
            id: id,
            invoiceId: invoiceId,
            itemId: itemId,
            lineNumber: lineNumber,
            supplierItemCode: supplierItemCode,
            rawItemName: rawItemName,
            unitName: unitName,
            quantity: quantity,
            quantityWords: quantityWords,
            freeQuantity: freeQuantity,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
            effectiveUnitCost: effectiveUnitCost,
            singlePieceCost: singlePieceCost,
            previousUnitPrice: previousUnitPrice,
            priceDiffAmount: priceDiffAmount,
            needsReview: needsReview,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int invoiceId,
            required int itemId,
            Value<int> lineNumber = const Value.absent(),
            Value<String?> supplierItemCode = const Value.absent(),
            required String rawItemName,
            Value<String> unitName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String?> quantityWords = const Value.absent(),
            Value<double> freeQuantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<double> effectiveUnitCost = const Value.absent(),
            Value<double?> singlePieceCost = const Value.absent(),
            Value<double?> previousUnitPrice = const Value.absent(),
            Value<double> priceDiffAmount = const Value.absent(),
            Value<bool> needsReview = const Value.absent(),
          }) =>
              InvoiceLinesCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            itemId: itemId,
            lineNumber: lineNumber,
            supplierItemCode: supplierItemCode,
            rawItemName: rawItemName,
            unitName: unitName,
            quantity: quantity,
            quantityWords: quantityWords,
            freeQuantity: freeQuantity,
            unitPrice: unitPrice,
            lineTotal: lineTotal,
            effectiveUnitCost: effectiveUnitCost,
            singlePieceCost: singlePieceCost,
            previousUnitPrice: previousUnitPrice,
            priceDiffAmount: priceDiffAmount,
            needsReview: needsReview,
          ),
        ));
}

class $$InvoiceLinesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lineNumber => $state.composableBuilder(
      column: $state.table.lineNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get supplierItemCode => $state.composableBuilder(
      column: $state.table.supplierItemCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rawItemName => $state.composableBuilder(
      column: $state.table.rawItemName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get quantityWords => $state.composableBuilder(
      column: $state.table.quantityWords,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get freeQuantity => $state.composableBuilder(
      column: $state.table.freeQuantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lineTotal => $state.composableBuilder(
      column: $state.table.lineTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get effectiveUnitCost => $state.composableBuilder(
      column: $state.table.effectiveUnitCost,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get singlePieceCost => $state.composableBuilder(
      column: $state.table.singlePieceCost,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get previousUnitPrice => $state.composableBuilder(
      column: $state.table.previousUnitPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get priceDiffAmount => $state.composableBuilder(
      column: $state.table.priceDiffAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get needsReview => $state.composableBuilder(
      column: $state.table.needsReview,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PurchaseInvoicesTableFilterComposer get invoiceId {
    final $$PurchaseInvoicesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.invoiceId,
            referencedTable: $state.db.purchaseInvoices,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PurchaseInvoicesTableFilterComposer(ComposerState($state.db,
                    $state.db.purchaseInvoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $state.db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ItemsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.items, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$InvoiceLinesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lineNumber => $state.composableBuilder(
      column: $state.table.lineNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get supplierItemCode => $state.composableBuilder(
      column: $state.table.supplierItemCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rawItemName => $state.composableBuilder(
      column: $state.table.rawItemName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get quantityWords => $state.composableBuilder(
      column: $state.table.quantityWords,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get freeQuantity => $state.composableBuilder(
      column: $state.table.freeQuantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unitPrice => $state.composableBuilder(
      column: $state.table.unitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lineTotal => $state.composableBuilder(
      column: $state.table.lineTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get effectiveUnitCost => $state.composableBuilder(
      column: $state.table.effectiveUnitCost,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get singlePieceCost => $state.composableBuilder(
      column: $state.table.singlePieceCost,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get previousUnitPrice => $state.composableBuilder(
      column: $state.table.previousUnitPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get priceDiffAmount => $state.composableBuilder(
      column: $state.table.priceDiffAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get needsReview => $state.composableBuilder(
      column: $state.table.needsReview,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PurchaseInvoicesTableOrderingComposer get invoiceId {
    final $$PurchaseInvoicesTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.invoiceId,
            referencedTable: $state.db.purchaseInvoices,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PurchaseInvoicesTableOrderingComposer(ComposerState($state.db,
                    $state.db.purchaseInvoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $state.db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$ItemsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.items, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PaymentVouchersTableCreateCompanionBuilder = PaymentVouchersCompanion
    Function({
  Value<int> id,
  required int supplierId,
  Value<int?> linkedInvoiceId,
  required String paperVoucherNumber,
  required DateTime voucherDate,
  Value<String> currency,
  Value<double> amount,
  Value<String?> amountWords,
  Value<String> paymentMethod,
  Value<String?> statementNote,
  Value<double?> printedRemainingBalance,
  Value<String?> imagePath,
  Value<DateTime> createdAt,
});
typedef $$PaymentVouchersTableUpdateCompanionBuilder = PaymentVouchersCompanion
    Function({
  Value<int> id,
  Value<int> supplierId,
  Value<int?> linkedInvoiceId,
  Value<String> paperVoucherNumber,
  Value<DateTime> voucherDate,
  Value<String> currency,
  Value<double> amount,
  Value<String?> amountWords,
  Value<String> paymentMethod,
  Value<String?> statementNote,
  Value<double?> printedRemainingBalance,
  Value<String?> imagePath,
  Value<DateTime> createdAt,
});

class $$PaymentVouchersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentVouchersTable,
    PaymentVoucher,
    $$PaymentVouchersTableFilterComposer,
    $$PaymentVouchersTableOrderingComposer,
    $$PaymentVouchersTableCreateCompanionBuilder,
    $$PaymentVouchersTableUpdateCompanionBuilder> {
  $$PaymentVouchersTableTableManager(
      _$AppDatabase db, $PaymentVouchersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PaymentVouchersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PaymentVouchersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<int?> linkedInvoiceId = const Value.absent(),
            Value<String> paperVoucherNumber = const Value.absent(),
            Value<DateTime> voucherDate = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> amountWords = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> statementNote = const Value.absent(),
            Value<double?> printedRemainingBalance = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PaymentVouchersCompanion(
            id: id,
            supplierId: supplierId,
            linkedInvoiceId: linkedInvoiceId,
            paperVoucherNumber: paperVoucherNumber,
            voucherDate: voucherDate,
            currency: currency,
            amount: amount,
            amountWords: amountWords,
            paymentMethod: paymentMethod,
            statementNote: statementNote,
            printedRemainingBalance: printedRemainingBalance,
            imagePath: imagePath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int supplierId,
            Value<int?> linkedInvoiceId = const Value.absent(),
            required String paperVoucherNumber,
            required DateTime voucherDate,
            Value<String> currency = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> amountWords = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> statementNote = const Value.absent(),
            Value<double?> printedRemainingBalance = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PaymentVouchersCompanion.insert(
            id: id,
            supplierId: supplierId,
            linkedInvoiceId: linkedInvoiceId,
            paperVoucherNumber: paperVoucherNumber,
            voucherDate: voucherDate,
            currency: currency,
            amount: amount,
            amountWords: amountWords,
            paymentMethod: paymentMethod,
            statementNote: statementNote,
            printedRemainingBalance: printedRemainingBalance,
            imagePath: imagePath,
            createdAt: createdAt,
          ),
        ));
}

class $$PaymentVouchersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PaymentVouchersTable> {
  $$PaymentVouchersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paperVoucherNumber => $state.composableBuilder(
      column: $state.table.paperVoucherNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get voucherDate => $state.composableBuilder(
      column: $state.table.voucherDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get amountWords => $state.composableBuilder(
      column: $state.table.amountWords,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get statementNote => $state.composableBuilder(
      column: $state.table.statementNote,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get printedRemainingBalance => $state.composableBuilder(
      column: $state.table.printedRemainingBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableFilterComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  $$PurchaseInvoicesTableFilterComposer get linkedInvoiceId {
    final $$PurchaseInvoicesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedInvoiceId,
            referencedTable: $state.db.purchaseInvoices,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PurchaseInvoicesTableFilterComposer(ComposerState($state.db,
                    $state.db.purchaseInvoices, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PaymentVouchersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PaymentVouchersTable> {
  $$PaymentVouchersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paperVoucherNumber => $state.composableBuilder(
      column: $state.table.paperVoucherNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get voucherDate => $state.composableBuilder(
      column: $state.table.voucherDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get amountWords => $state.composableBuilder(
      column: $state.table.amountWords,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get statementNote => $state.composableBuilder(
      column: $state.table.statementNote,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get printedRemainingBalance =>
      $state.composableBuilder(
          column: $state.table.printedRemainingBalance,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get imagePath => $state.composableBuilder(
      column: $state.table.imagePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $state.db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SuppliersTableOrderingComposer(ComposerState(
                $state.db, $state.db.suppliers, joinBuilder, parentComposers)));
    return composer;
  }

  $$PurchaseInvoicesTableOrderingComposer get linkedInvoiceId {
    final $$PurchaseInvoicesTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.linkedInvoiceId,
            referencedTable: $state.db.purchaseInvoices,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PurchaseInvoicesTableOrderingComposer(ComposerState($state.db,
                    $state.db.purchaseInvoices, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$SupplierItemsTableTableManager get supplierItems =>
      $$SupplierItemsTableTableManager(_db, _db.supplierItems);
  $$PurchaseInvoicesTableTableManager get purchaseInvoices =>
      $$PurchaseInvoicesTableTableManager(_db, _db.purchaseInvoices);
  $$InvoiceLinesTableTableManager get invoiceLines =>
      $$InvoiceLinesTableTableManager(_db, _db.invoiceLines);
  $$PaymentVouchersTableTableManager get paymentVouchers =>
      $$PaymentVouchersTableTableManager(_db, _db.paymentVouchers);
}
