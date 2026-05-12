// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/repositories/storage_repository.dart';
import 'auth_store.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  _RegisterStore(this._authStore, this._storageRepository);

  final AuthStore _authStore;
  final StorageRepository _storageRepository;
  final _picker = ImagePicker();

  @observable
  String name = '';

  @observable
  String phone = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String tipoUsuario = 'adotante';

  @observable
  bool isPasswordVisible = false;

  @observable
  File? profileImage;

  @observable
  bool isUploadingPhoto = false;

  @computed
  bool get isLoading => _authStore.isLoading || isUploadingPhoto;

  @computed
  String? get errorMessage => _authStore.errorMessage;

  @computed
  bool get isFormValid =>
      name.isNotEmpty &&
      phone.isNotEmpty &&
      email.isNotEmpty &&
      password.length >= 6;

  @action
  void setName(String v) => name = v;

  @action
  void setPhone(String v) => phone = v;

  @action
  void setEmail(String v) => email = v;

  @action
  void setPassword(String v) => password = v;

  @action
  void setTipoUsuario(String v) => tipoUsuario = v;

  @action
  void togglePasswordVisibility() => isPasswordVisible = !isPasswordVisible;

  @action
  Future<void> pickProfileImage() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile != null) profileImage = File(xFile.path);
  }

  Future<bool> register() async {
    final ok = await _authStore.register(
      email: email,
      password: password,
      nome: name,
      tipoUsuario: tipoUsuario,
    );
    if (!ok) return false;

    final image = profileImage;
    final uid = _authStore.firebaseUser?.uid;
    if (image != null && uid != null) {
      isUploadingPhoto = true;
      try {
        final url =
            await _storageRepository.uploadProfileImage(image, uid);
        await _authStore.updateProfilePhoto(url);
      } catch (_) {
        // Foto falhou, mas cadastro foi concluído
      } finally {
        isUploadingPhoto = false;
      }
    }

    return true;
  }
}
