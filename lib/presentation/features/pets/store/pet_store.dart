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
  String? errorMessage;

  @computed
  List<PetModel> get filteredPets => pets.toList();

  @action
  Future<void> loadPets() async {
    isLoading = true;
    errorMessage = null;
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
          errorMessage = 'Erro ao carregar pets: $e';
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
    errorMessage = null;
    try {
      final petId = await _petRepository.createPet(pet);

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
        await _petRepository.updatePetPhotos(petId, fotosUrls);
      }

      selectedImages.clear();
      return true;
    } catch (e, st) {
      debugPrint('❌ PetStore.savePet error: $e\n$st');
      errorMessage = 'Erro ao salvar pet: $e';
      return false;
    } finally {
      isLoading = false;
    }
  }

  void dispose() => _petSub?.cancel();
}
