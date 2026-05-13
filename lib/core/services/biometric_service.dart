import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricCredentials {
  const BiometricCredentials({required this.email, required this.password});
  final String email;
  final String password;
}

class BiometricService {
  BiometricService({LocalAuthentication? auth, FlutterSecureStorage? storage})
      : _auth = auth ?? LocalAuthentication(),
        _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  static const _emailKey = 'biometric_email';
  static const _passwordKey = 'biometric_password';
  static const _enabledKey = 'biometric_enabled';
  static const _neverAskKey = 'biometric_never_ask';
  static const _permissionRequestedKey = 'biometric_permission_requested';

  Future<bool> isDeviceSupported() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final available = await _auth.getAvailableBiometrics();
      debugPrint(
          '🔒 BiometricService: isDeviceSupported=$supported canCheck=$canCheck available=$available');
      return supported && canCheck;
    } on PlatformException catch (e) {
      debugPrint('🔒 BiometricService.isDeviceSupported error: $e');
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final value = await _storage.read(key: _enabledKey);
    debugPrint('🔒 isEnabled() read key=$_enabledKey value=$value');
    return value == 'true';
  }

  Future<bool> neverAsk() async =>
      (await _storage.read(key: _neverAskKey)) == 'true';

  Future<bool> hasRequestedPermission() async =>
      (await _storage.read(key: _permissionRequestedKey)) == 'true';

  /// Dispara o prompt de consentimento do sistema (iOS Face ID) na primeira
  /// vez que o app abre. Não ativa a biometria — apenas pede a permissão do
  /// SO para que o app possa usá-la futuramente sem precisar mostrar
  /// novamente o consent dialog do iOS.
  Future<void> requestPermissionIfNeeded() async {
    if (await hasRequestedPermission()) return;
    if (!await isDeviceSupported()) {
      await _storage.write(key: _permissionRequestedKey, value: 'true');
      return;
    }
    try {
      await _auth.authenticate(
        localizedReason:
            'Permita o uso da biometria para entrar no Cãobinado de forma rápida e segura.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('BiometricService.requestPermission: $e');
    } finally {
      await _storage.write(key: _permissionRequestedKey, value: 'true');
    }
  }

  Future<bool> shouldOfferActivation() async {
    final enabled = await isEnabled();
    final never = await neverAsk();
    final supported = await isDeviceSupported();
    debugPrint(
        '🔒 shouldOfferActivation: enabled=$enabled never=$never supported=$supported');
    if (enabled) return false;
    if (never) return false;
    return supported;
  }

  Future<void> enable(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(key: _enabledKey, value: 'true');
    await _storage.write(key: _neverAskKey, value: 'false');
  }

  Future<void> markNeverAsk() async {
    await _storage.write(key: _neverAskKey, value: 'true');
  }

  Future<void> disable() async {
    debugPrint('🔒 BiometricService.disable() called');
    // Sobrescreve com 'false'/'' em vez de deletar — `_storage.delete` é
    // inconsistente no iOS Simulator quando há mismatch de accessibility.
    await _storage.write(key: _enabledKey, value: 'false');
    await _storage.write(key: _neverAskKey, value: 'false');
    await _storage.write(key: _emailKey, value: '');
    await _storage.write(key: _passwordKey, value: '');
    final after = await _storage.read(key: _enabledKey);
    debugPrint('🔒 BiometricService.disable() done. enabled key now=$after');
  }

  Future<BiometricCredentials?> authenticateAndGetCredentials({
    String localizedReason = 'Use a biometria para entrar no Cãobinado',
  }) async {
    try {
      final didAuth = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!didAuth) return null;
      final email = await _storage.read(key: _emailKey);
      final password = await _storage.read(key: _passwordKey);
      if (email == null || email.isEmpty) return null;
      if (password == null || password.isEmpty) return null;
      return BiometricCredentials(email: email, password: password);
    } on PlatformException catch (e) {
      debugPrint('BiometricService.authenticate: $e');
      return null;
    }
  }
}
