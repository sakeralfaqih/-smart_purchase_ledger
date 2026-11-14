import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/suppliers_dao.dart';
import '../../../../core/services/arabic_text_normalizer.dart';
import '../../domain/entities/extracted_document_entity.dart';
import '../../domain/repositories/supplier_resolver.dart';

/// إيجاد المورد بالرقم التحليلي أو الاسم/المرادفات أو إنشاؤه تلقائياً بأمان تام.
class SupplierResolverImpl implements SupplierResolver {
  SupplierResolverImpl(this._dao);

  final SuppliersDao _dao;

  @override
  Future<int> resolveSupplier(SupplierInfo info) async {
    var name = info.name.trim();

    // حماية ضد عكس المنظور: منع تسجيل اسم صاحب المحل ("أبو ردمان") كمورد عن طريق الخطأ
    final normalizedInput = ArabicTextNormalizer.normalize(name);
    final isOwnerMistakenAsSupplier = AppStrings.ownerAliases.any(
      (alias) => ArabicTextNormalizer.normalize(alias) == normalizedInput,
    );
    if (isOwnerMistakenAsSupplier) {
      name = '';
    }

    if (name.isEmpty &&
        (info.analyticCode == null || info.analyticCode!.trim().isEmpty)) {
      throw StateError('اسم المورد فارغ — يرجى تحديد اسم المورد قبل الحفظ.');
    }

    final all = await _dao.getAllSuppliers();

    // 1) مطابقة فورية عبر الرقم التحليلي لدى المورد (مثل 13007 أو 1227) إن وجد
    final incomingCode = info.analyticCode?.trim();
    if (incomingCode != null && incomingCode.isNotEmpty && name.isEmpty) {
      for (final s in all) {
        if (s.analyticAccountNo?.trim() == incomingCode) {
          return s.id;
        }
      }
    }

    // 2) مطابقة تامة بالاسم
    if (name.isNotEmpty) {
      final exact = await _dao.findByNameExact(name);
      if (exact != null) {
        await _maybeUpdateAnalyticSafe(exact, info);
        return exact.id;
      }
    }

    // 3) مطابقة ضبابية (Fuzzy Match) مع الأسماء والمرادفات المحفوظة
    if (name.isNotEmpty && all.isNotEmpty) {
      final candidates = <String>[];
      final supplierByIndex = <Supplier>[];

      for (final s in all) {
        candidates.add(s.name);
        supplierByIndex.add(s);
        final aliases = _parseAliases(s.ocrAliasesJson);
        for (final alias in aliases) {
          candidates.add(alias);
          supplierByIndex.add(s);
        }
      }

      final best = ArabicTextNormalizer.bestMatch(
        name,
        candidates,
        threshold: 0.80,
      );
      if (best != null) {
        final matchedSupplier = supplierByIndex[best.index];
        await _maybeUpdateAnalyticSafe(matchedSupplier, info);
        return matchedSupplier.id;
      }
    }

    // 4) إنشاء مورد جديد إذا لم يكن مسجلاً من قبل
    final finalName = name.isNotEmpty ? name : 'مورد (حساب رقم $incomingCode)';
    return _dao.insertSupplier(
      SuppliersCompanion.insert(
        name: finalName,
        branchName: Value(info.branchName),
        analyticAccountNo: Value(incomingCode),
        phonesJson: Value(jsonEncode(info.phones)),
        currency: const Value('YER'),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  /// تحديث الرقم التحليلي أو الفرع بأمان عبر كائن المورد الكامل دون مسح الرصيد أو الاسم.
  Future<void> _maybeUpdateAnalyticSafe(
    Supplier existingSupplier,
    SupplierInfo info,
  ) async {
    final newCode = info.analyticCode?.trim();
    final hasNewCode = newCode != null &&
        newCode.isNotEmpty &&
        (existingSupplier.analyticAccountNo == null ||
            existingSupplier.analyticAccountNo!.isEmpty);

    final newBranch = info.branchName?.trim();
    final hasNewBranch = newBranch != null &&
        newBranch.isNotEmpty &&
        (existingSupplier.branchName == null ||
            existingSupplier.branchName!.isEmpty);

    if (!hasNewCode && !hasNewBranch) return;

    await _dao.updateSupplier(
      existingSupplier
          .copyWith(
            analyticAccountNo: Value(
              hasNewCode ? newCode : existingSupplier.analyticAccountNo,
            ),
            branchName: Value(
              hasNewBranch ? newBranch : existingSupplier.branchName,
            ),
          )
          .toCompanion(false),
    );
  }

  List<String> _parseAliases(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}
