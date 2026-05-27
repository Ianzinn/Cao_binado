// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/pet_repository.dart';

part 'edit_animal_store.g.dart';

class EditAnimalStore = _EditAnimalStore with _$EditAnimalStore;

abstract class _EditAnimalStore with Store {
  _EditAnimalStore({
    required PetRepository petRepository,
    required PetModel pet,
  })  : _petRepository = petRepository,
        _original = pet {
    name = pet.nome;
    age = pet.idade;
    animalClass = pet.especie;
    size = pet.porte;
    breed = pet.raca;
    description = pet.descricao;
  }

  final PetRepository _petRepository;
  final PetModel _original;

  @observable
  String name = '';

  @observable
  String age = '';

  @observable
  String animalClass = '';

  @observable
  String size = '';

  @observable
  String breed = '';

  @observable
  String description = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get isFormValid =>
      name.isNotEmpty && age.isNotEmpty && animalClass.isNotEmpty;

  @action
  void setName(String v) => name = v;

  @action
  void setAge(String v) => age = v;

  @action
  void setAnimalClass(String v) => animalClass = v;

  @action
  void setSize(String v) => size = v;

  @action
  void setBreed(String v) => breed = v;

  @action
  void setDescription(String v) => description = v;

  @action
  Future<bool> save() async {
    if (!isFormValid) return false;
    isLoading = true;
    errorMessage = null;
    try {
      final updated = PetModel(
        id: _original.id,
        nome: name,
        especie: animalClass,
        raca: breed,
        idade: age,
        porte: size,
        descricao: description,
        status: _original.status,
        protetorId: _original.protetorId,
        fotosUrls: _original.fotosUrls,
        criadoEm: _original.criadoEm,
      );
      await _petRepository.updatePet(updated);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar: $e';
      return false;
    } finally {
      isLoading = false;
    }
  }
}
