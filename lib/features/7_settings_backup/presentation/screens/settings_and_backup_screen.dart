import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../2_ocr_scanner/data/datasources/offline_ocr_queue_local_datasource.dart';
import '../../../2_ocr_scanner/domain/entities/extracted_document_entity.dart';
import '../../../2_ocr_scanner/presentation/providers/ocr_providers.dart';
import '../../../2_ocr_scanner/presentation/screens/split_screen_ocr_review_screen.dart';
import '../providers/backup_providers.dart';

class SettingsAndBackupScreen extends ConsumerStatefulWidget {
  const SettingsAndBackupScreen({super.key});

  @override
  ConsumerState<SettingsAndBackupScreen> createState() =>
      _SettingsAndBackupScreenState();
}

class _SettingsAndBackupScreenState
    extends ConsumerState<SettingsAndBackupScreen> {
  bool _busy = false;
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignIn();
  }

  Future<void> _checkSignIn() async {
    final ok = await ref.read(backupRepositoryProvider).isSignedIn();
    if (mounted) setState(() => _signedIn = ok);
  }

  @override
  Widget build(BuildContext context) {
    final biometricOn = ref.watch(biometricLockEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _ownerCard(),
          const SizedBox(height: 12),
          _sectionTitle('الأمان'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.fingerprint,
                color: AppColors.primary,
              ),
              title: const Text(AppStrings.biometricLock),
              subtitle: const Text(
                'قفل التطبيق بالبصمة عند الفتح وقبل عمليات النسخ والاستعادة الحساسة',
              ),
              value: biometricOn,
              onChanged: (v) async {
                if (v) {
                  final result = await ref
                      .read(authenticateBiometricsUseCaseProvider)(
                    reason: 'تفعيل قفل البصمة',
                  );
                  if (!result.success) {
                    if (mounted) {
                      _snack(result.message);
                    }
                    return;
                  }
                }
                await ref
                    .read(biometricLockEnabledProvider.notifier)
                    .setEnabled(v);
              },
            ),
          ),
          const SizedBox(height: 12),
          _sectionTitle(AppStrings.offlineQueue),
          _offlineQueueCard(),
          const SizedBox(height: 12),
          _sectionTitle('النسخ الاحتياطي السحابي (Google Drive)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _signedIn ? Icons.cloud_done : Icons.cloud_off,
                      color: _signedIn
                          ? AppColors.balanceMatch
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      _signedIn
                          ? 'متصل بحساب Google'
                          : 'غير متصل بحساب Google',
                    ),
                    subtitle: Text(
                      _signedIn
                          ? 'النسخ الاحتياطي جاهز'
                          : 'سجّل الدخول لتفعيل النسخ الاحتياطي',
                    ),
                    trailing: _signedIn
                        ? TextButton(
                            onPressed: _busy ? null : _signOut,
                            child: const Text('خروج'),
                          )
                        : TextButton(
                            onPressed: _busy ? null : _signIn,
                            child: const Text('تسجيل الدخول'),
                          ),
                  ),
                  const Divider(),
                  _actionTile(
                    icon: Icons.backup_outlined,
                    title: AppStrings.backupToDrive,
                    subtitle: 'رفع نسخة من قاعدة البيانات إلى مجلد خاص بك',
                    onTap: _busy ? null : _backup,
                  ),
                  _actionTile(
                    icon: Icons.restore,
                    title: AppStrings.restoreFromDrive,
                    subtitle: 'استعادة أحدث نسخة (سيستبدل البيانات المحلية)',
                    onTap: _busy ? null : _restore,
                    color: AppColors.priceUp,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _sectionTitle('النسخ السحابية المتاحة'),
          _backupsList(),
          const SizedBox(height: 12),
          _sectionTitle('عن التطبيق'),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: AppColors.primary),
                  title: Text(AppStrings.appName),
                  subtitle: Text(
                    'نظام أوفلاين لإدارة فواتير المشتريات وذاكرة الأسعار ومديونيات الموردين',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline, color: AppColors.primary),
                  title: Text('المالك'),
                  subtitle: Text(AppStrings.ownerName),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _offlineQueueCard() {
    final queueAsync = ref.watch(pendingOcrQueueProvider);
    return Card(
      child: queueAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('تعذّر قراءة الطابور: $e'),
        ),
        data: (List<PendingScan> items) {
          if (items.isEmpty) {
            return const ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: AppColors.balanceMatch,
              ),
              title: Text(
                'لا توجد فواتير معلقة في الطابور',
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                'جميع الصور الملتقطة تمت معالجتها بنجاح.',
                style: TextStyle(fontSize: 11),
              ),
            );
          }

          return Column(
            children: [
              ...items.asMap().entries.map((entry) {
                final idx = entry.key;
                final scan = entry.value;
                final isVoucher = scan.hint == 'receipt_voucher';
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.reviewYellow,
                    child: Icon(
                      Icons.pending_actions,
                      color: AppColors.reviewYellowBorder,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${isVoucher ? 'سند قبض' : 'فاتورة مشتريات'} (${scan.imagePaths.length} صفحة)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'التُقطت في: ${DateFormatter.displayDateTime(scan.createdAt)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('معالجة الآن'),
                        onPressed: () => _processQueuedScan(idx, scan),
                      ),
                      IconButton(
                        tooltip: 'حذف من الطابور',
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.balanceMismatch,
                        ),
                        onPressed: () async {
                          await ref
                              .read(offlineOcrQueueProvider)
                              .removeAt(idx);
                          ref.invalidate(pendingOcrQueueProvider);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Future<void> _processQueuedScan(int index, PendingScan scan) async {
    final hint = scan.hint == 'receipt_voucher'
        ? DocType.receiptVoucher
        : DocType.purchaseInvoice;

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => SplitScreenOcrReviewScreen(
          imagePaths: scan.imagePaths,
          hint: hint,
        ),
      ),
    );

    if (saved == true) {
      await ref.read(offlineOcrQueueProvider).removeAt(index);
    }
    ref.invalidate(pendingOcrQueueProvider);
  }

  Widget _ownerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.debtGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.storefront, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.ownerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'نسخة محلية — بياناتك على جهازك فقط',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: color ?? AppColors.textPrimary),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_left, size: 18),
      onTap: onTap,
    );
  }

  Widget _backupsList() {
    if (!_signedIn) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'سجّل الدخول بحساب Google لعرض النسخ الاحتياطية السحابية.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
      );
    }

    final backupsAsync = ref.watch(driveBackupsProvider);
    return Card(
      child: backupsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'تعذّر جلب النسخ: $e',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        data: (backups) {
          if (backups.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'لا توجد نسخ احتياطية بعد.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return Column(
            children: backups
                .map(
                  (b) => ListTile(
                    leading: const Icon(
                      Icons.cloud_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(b.name, style: const TextStyle(fontSize: 13)),
                    subtitle: Text(
                      DateFormatter.displayDateTime(b.createdTime) +
                          (b.sizeBytes != null
                              ? ' • ${(b.sizeBytes! / 1024).toStringAsFixed(0)} KB'
                              : ''),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      final email = await ref.read(backupRepositoryProvider).signIn();
      if (mounted) {
        setState(() => _signedIn = email != null);
        _snack(
          email != null
              ? 'تم تسجيل الدخول: $email'
              : 'تم إلغاء تسجيل الدخول',
        );
        ref.invalidate(driveBackupsProvider);
      }
    } catch (e) {
      if (mounted) _snack('فشل تسجيل الدخول: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    try {
      await ref.read(backupRepositoryProvider).signOut();
      if (mounted) {
        setState(() => _signedIn = false);
        _snack('تم تسجيل الخروج');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _guardBiometric() async {
    if (!ref.read(biometricLockEnabledProvider)) return true;
    final result = await ref.read(authenticateBiometricsUseCaseProvider)(
      reason: 'تأكيد العملية الحساسة',
    );
    if (!result.success && mounted) _snack(result.message);
    return result.success;
  }

  Future<void> _backup() async {
    if (!await _guardBiometric()) return;
    setState(() => _busy = true);
    try {
      final result = await ref.read(backupToGoogleDriveUseCaseProvider)();
      if (mounted) {
        _snack(result.message);
        ref.invalidate(driveBackupsProvider);
      }
    } catch (e) {
      if (mounted) _snack('فشل النسخ: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الاستعادة'),
        content: const Text(
          'سيتم استبدال قاعدة البيانات المحلية بأحدث نسخة سحابية. هل أنت متأكد؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('استعادة'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    if (!await _guardBiometric()) return;
    setState(() => _busy = true);
    try {
      final result = await ref.read(restoreFromGoogleDriveUseCaseProvider)();
      if (mounted) _snack(result.message);
    } catch (e) {
      if (mounted) _snack('فشل الاستعادة: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
