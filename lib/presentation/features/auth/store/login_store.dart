// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import '../../../../core/services/biometric_service.dart';
import 'auth_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore(this._authStore, this._biometric) {
    _initBiometricFlags();
  }

  final AuthStore _authStore;
  final BiometricService _biometric;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isPasswordVisible = false;

  @observable
  bool biometricSupported = false;

  @observable
  bool biometricEnabled = false;

  @computed
  bool get isLoading => _authStore.isLoading;

  @computed
  String? get errorMessage => _authStore.errorMessage;

  @computed
  bool get isFormValid => email.isNotEmpty && password.length >= 6;

  @computed
  bool get canLoginWithBiometric => biometricSupported && biometricEnabled;

  Future<void> _initBiometricFlags() async {
    final supported = await _biometric.isDeviceSupported();
    final enabled = await _biometric.isEnabled();
    runInAction(() {
      biometricSupported = supported; 
      biometricEnabled = enabled;
    });
  }

  @action
  void setEmail(String v) => email = v;

  @action
  void setPassword(String v) => password = v;

  @action
  void togglePasswordVisibility() => isPasswordVisible = !isPasswordVisible;



  Future<bool> login() async {
    final success = await _authStore.login(email, password);
    if (success) {
      _authStore.rememberPendingBiometric(email, password);
    }
    return success;
  }

  Future<bool> sendPasswordReset(String emailToReset) =>
      _authStore.sendPasswordReset(emailToReset);

  Future<bool> loginWithBiometric() async {
    final creds = await _biometric.authenticateAndGetCredentials();
    if (creds == null) return false;
    return _authStore.login(creds.email, creds.password);
  }
}
