// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';
import 'pet_store.dart';

part 'find_store.g.dart';

class FindStore = _FindStore with _$FindStore;

abstract class _FindStore with Store {
  _FindStore(this._petStore, this._adoptionRepository, this._authStore);

  final PetStore _petStore;
  final AdoptionRepository _adoptionRepository;
  final AuthStore _authStore;

  ObservableList<PetModel> get pets => _petStore.pets;

  @computed
  bool get isLoading => _petStore.isLoading;

  @computed
  String? get errorMessage => _petStore.errorMessage;

  @action
  Future<void> loadPets() => _petStore.loadPets();

  @action
  void setEspecieFilter(String? v) => _petStore.setEspecieFilter(v);

  @action
  void setPorteFilter(String? v) => _petStore.setPorteFilter(v);

  @action
  Future<bool> adopt(PetModel pet) async {
    final user = _authStore.firebaseUser;
    if (user == null) return false;

    try {
      final adoption = AdoptionModel(
        id: '',
        petId: pet.id,
        petNome: pet.nome,
        adotanteId: user.uid,
        adotanteNome: _authStore.displayName,
        protetorId: pet.protetorId,
        status: AdoptionStatusValues.interesse,
        criadoEm: DateTime.now(),
      );
      await _adoptionRepository.createAdoption(adoption);
      return true;
    } catch (_) {
      return false;
    }
  }
}
