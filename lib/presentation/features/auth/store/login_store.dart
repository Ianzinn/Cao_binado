// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'auth_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore(this._authStore);

  final AuthStore _authStore;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isPasswordVisible = false;

  @computed
  bool get isLoading => _authStore.isLoading;

  @computed
  String? get errorMessage => _authStore.errorMessage;

  @computed
  bool get isFormValid => email.isNotEmpty && password.length >= 6;

  @action
  void setEmail(String v) => email = v;

  @action
  void setPassword(String v) => password = v;

  @action
  void togglePasswordVisibility() => isPasswordVisible = !isPasswordVisible;

  Future<bool> login() => _authStore.login(email, password);
}
