// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/pet_model.dart';
import '../../auth/store/auth_store.dart';
import 'pet_store.dart';

part 'register_animal_store.g.dart';

class RegisterAnimalStore = _RegisterAnimalStore with _$RegisterAnimalStore;

abstract class _RegisterAnimalStore with Store {
  _RegisterAnimalStore(this._petStore, this._authStore);

  final PetStore _petStore;
  final AuthStore _authStore;

  @observable
  String name = '';

  @observable
  String age = '';

  @observable
  String kingdom = '';

  @observable
  String animalClass = '';

  @observable
  String size = '';

  @observable
  String breed = '';

  @observable
  String description = '';

  ObservableList<File> get selectedImages => _petStore.selectedImages;

  @computed
  bool get isLoading => _petStore.isLoading;

  @computed
  String? get errorMessage => _petStore.errorMessage;

  @computed
  bool get isFormValid =>
      name.isNotEmpty && age.isNotEmpty && kingdom.isNotEmpty;

  @action
  void setName(String v) => name = v;

  @action
  void setAge(String v) => age = v;

  @action
  void setKingdom(String v) => kingdom = v;

  @action
  void setAnimalClass(String v) => animalClass = v;

  @action
  void setSize(String v) => size = v;

  @action
  void setBreed(String v) => breed = v;

  @action
  void setDescription(String v) => description = v;

  Future<void> pickImage() => _petStore.pickImage();

  void removeImage(int index) => _petStore.removeImage(index);

  @action
  Future<bool> save() async {
    if (!isFormValid) return false;
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return false;

    final pet = PetModel(
      id: '',
      nome: name,
      especie: animalClass.isNotEmpty ? animalClass : kingdom,
      raca: breed,
      idade: age,
      porte: size,
      descricao: description,
      status: PetStatus.disponivel,
      protetorId: uid,
      fotosUrls: const [],
      criadoEm: DateTime.now(),
    );

    return _petStore.savePet(pet);
  }
}
