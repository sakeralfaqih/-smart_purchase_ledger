import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/1_dashboard/presentation/screens/home_dashboard_screen.dart';
import 'features/3_invoices/presentation/screens/manual_invoice_entry_screen.dart';
import 'features/5_suppliers/presentation/screens/suppliers_list_screen.dart';
import 'features/6_catalog/presentation/screens/price_memory_catalog_screen.dart';
import 'features/7_settings_backup/presentation/providers/backup_providers.dart';
import 'features/7_settings_backup/presentation/screens/settings_and_backup_screen.dart';

class HisabAlMawridApp extends StatelessWidget {
  const HisabAlMawridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const _BiometricAppLockGate(child: RootShell()),
    );
  }
}

/// بوابة أمان تطلب البصمة عند فتح التطبيق إذا كان قفل البصمة مفعلاً في الإعدادات.
class _BiometricAppLockGate extends ConsumerStatefulWidget {
  const _BiometricAppLockGate({required this.child});

  final Widget child;

  @override
  ConsumerState<_BiometricAppLockGate> createState() =>
      _BiometricAppLockGateState();
}

class _BiometricAppLockGateState extends ConsumerState<_BiometricAppLockGate> {
  bool _unlocked = false;
  bool _prompting = false;

  Future<void> _authenticate() async {
    if (_prompting) return;
    setState(() => _prompting = true);
    final res = await ref.read(authenticateBiometricsUseCaseProvider)(
      reason: 'يرجى التحقق بالبصمة لفتح حساب المورد',
    );
    if (mounted) {
      setState(() {
        _prompting = false;
        if (res.success || !res.available) {
          _unlocked = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockEnabled = ref.watch(biometricLockEnabledProvider);
    if (!lockEnabled || _unlocked) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.fingerprint,
                size: 72,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'التطبيق محمي بقفل البصمة',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _prompting ? null : _authenticate,
                icon: const Icon(Icons.lock_open),
                label: const Text('فتح التطبيق بالبصمة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// الهيكل الجذري مع شريط تنقّل سفلي بين الشاشات الرئيسية.
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _index = 0;

  static const _screens = <Widget>[
    HomeDashboardScreen(),
    SuppliersListScreen(),
    PriceMemoryCatalogScreen(),
    SettingsAndBackupScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<bool>(
                  builder: (_) => const ManualInvoiceEntryScreen(),
                ),
              ),
              icon: const Icon(Icons.edit_note),
              label: const Text('إدخال يدوي'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppStrings.suppliers,
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: AppStrings.priceMemory,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}
