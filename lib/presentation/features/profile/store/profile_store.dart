// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/repositories/storage_repository.dart';
import '../../auth/store/auth_store.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  _ProfileStore(this._authStore, this._storageRepository);

  final AuthStore _authStore;
  final StorageRepository _storageRepository;
  final _picker = ImagePicker();

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
      await _authStore.logout();
    } finally {
      isLoading = false;
    }
  }
}
