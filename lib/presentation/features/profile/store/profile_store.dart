// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../domain/repositories/storage_repository.dart';
import '../../auth/store/auth_store.dart';
import '../../home/store/home_store.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  _ProfileStore(this._authStore, this._storageRepository, this._biometric) {
    _loadBiometricState();
  }

  final AuthStore _authStore;
  final StorageRepository _storageRepository;
  final BiometricService _biometric;
  final _picker = ImagePicker();

  @observable
  bool biometricSupported = false;

  @observable
  bool biometricEnabled = false;

  Future<void> _loadBiometricState() async {
    final supported = await _biometric.isDeviceSupported();
    final enabled = await _biometric.isEnabled();
    runInAction(() {
      biometricSupported = supported;
      biometricEnabled = enabled;
    });
  }

  @action
  Future<void> disableBiometric() async {
    await _biometric.disable();
    biometricEnabled = false;
  }

  @computed
  bool get isAdmin => _authStore.isAdmin;

  @computed
  String get userName => _authStore.displayName;

  @computed
  String get userEmail => _authStore.displayEmail;

  @computed
  String? get fotoPerfilUrl => _authStore.userProfile?.fotoPerfilUrl;

  @observable
  String appVersion = 'v1.15.0';

  @observable
  bool isLoading = false;

  @action
  Future<void> pickAndUpdatePhoto() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile == null) return;

    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;

    isLoading = true;
    try {
      final url =
          await _storageRepository.uploadProfileImage(File(xFile.path), uid);
      await _authStore.updateProfilePhoto(url);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    try {
      // Limpa credenciais biométricas no logout explícito para evitar que o
      // próximo launch reentre automaticamente com a mesma sessão.
      // Sessão expirada (Firebase) NÃO passa por aqui, então mantém biometria.
      await _biometric.disable();
      biometricEnabled = false;
      getIt<HomeStore>().dispose();
      getIt.resetLazySingleton<HomeStore>();
      await _authStore.logout();
    } finally {
      isLoading = false;
    }
  }
}
