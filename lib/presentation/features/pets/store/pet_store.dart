// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/pet_repository.dart';
import '../../../../domain/repositories/storage_repository.dart';

part 'pet_store.g.dart';

class PetStore = _PetStore with _$PetStore;

abstract class _PetStore with Store {
  _PetStore(this._petRepository, this._storageService);

  final PetRepository _petRepository;
  final StorageRepository _storageService;
  final _picker = ImagePicker();
  StreamSubscription<List<PetModel>>? _petSub;

  @observable
  ObservableList<PetModel> pets = ObservableList<PetModel>();

  @observable
  ObservableList<File> selectedImages = ObservableList<File>();

  @observable
  String? especieFilter;

  @observable
  String? porteFilter;

  @observable
  bool isLoading = false;

  @observable
  String? loadErrorMessage;

  @observable
  String? saveErrorMessage;

  /// Retro-compat: aponta pro save error por padrão.
  @computed
  String? get errorMessage => saveErrorMessage;

  @computed
  List<PetModel> get filteredPets => pets.toList();

  @action
  Future<void> loadPets() async {
    isLoading = true;
    loadErrorMessage = null;
    await _petSub?.cancel();
    _petSub = _petRepository
        .getPetsStream(especie: especieFilter, porte: porteFilter)
        .listen(
      (list) {
        debugPrint('🐾 PetStore.loadPets received ${list.length} pets');
        runInAction(() {
          pets
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e, st) {
        debugPrint('❌ PetStore.loadPets error: $e\n$st');
        runInAction(() {
          loadErrorMessage = 'Erro ao carregar pets: $e';
          isLoading = false;
        });
      },
    );
  }

  @action
  void setEspecieFilter(String? v) {
    especieFilter = v;
    loadPets();
  }

  @action
  void setPorteFilter(String? v) {
    porteFilter = v;
    loadPets();
  }

  @action
  Future<void> pickImage() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (xFile != null) selectedImages.add(File(xFile.path));
  }

  @action
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  @action
  Future<bool> savePet(PetModel pet) async {
    isLoading = true;
    saveErrorMessage = null;
    debugPrint(
        '💾 PetStore.savePet start: name=${pet.nome} selectedImages=${selectedImages.length}');
    try {
      final petId = await _petRepository.createPet(pet);
      debugPrint('💾 PetStore: pet doc created id=$petId');

      final fotosUrls = <String>[];
      for (var i = 0; i < selectedImages.length; i++) {
        final file = selectedImages[i];
        final ext =
            file.path.contains('.') ? file.path.split('.').last : 'jpg';
        final url =
            await _storageService.uploadPetImage(file, petId, '$i.$ext');
        fotosUrls.add(url);
      }

      if (fotosUrls.isNotEmpty) {
        debugPrint('💾 PetStore: updating pet doc with ${fotosUrls.length} photo URLs');
        await _petRepository.updatePetPhotos(petId, fotosUrls);
      } else {
        debugPrint('⚠️  PetStore: NO photos selected — pet saved without images');
      }

      selectedImages.clear();
      return true;
    } catch (e, st) {
      debugPrint('❌ PetStore.savePet error: $e\n$st');
      saveErrorMessage = 'Erro ao salvar pet: $e';
      return false;
    } finally {
      isLoading = false;
    }
  }

  void dispose() => _petSub?.cancel();
}
