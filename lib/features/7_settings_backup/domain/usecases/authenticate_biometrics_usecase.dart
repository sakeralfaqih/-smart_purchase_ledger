import 'package:local_auth/local_auth.dart';

/// نتيجة محاولة التحقق البيومتري.
class BiometricAuthResult {
  const BiometricAuthResult({
    required this.success,
    required this.message,
    this.available = false,
  });

  final bool success;
  final String message;
  final bool available;
}

/// التحقق من هوية المستخدم عبر البصمة/الوجه قبل العمليات الحساسة (النسخ/الاستعادة).
class AuthenticateBiometricsUseCase {
  AuthenticateBiometricsUseCase([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<BiometricAuthResult> call({
    String reason = 'يرجى التحقق من هويتك للمتابعة',
  }) async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      if (!canCheck || !supported) {
        return const BiometricAuthResult(
          success: false,
          available: false,
          message: 'التحقق البيومتري غير متاح على هذا الجهاز',
        );
      }
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return BiometricAuthResult(
        success: ok,
        available: true,
        message: ok ? 'تم التحقق بنجاح' : 'فشل التحقق',
      );
    } catch (e) {
      return BiometricAuthResult(
        success: false,
        available: true,
        message: 'تعذّر إتمام التحقق: $e',
      );
    }
  }
}
