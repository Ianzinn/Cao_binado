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

  @observable
  bool isAdopting = false;

  @observable
  String? adoptErrorMessage;

  @computed
  bool get isLoading => _petStore.isLoading;

  @computed
  String? get errorMessage => _petStore.loadErrorMessage;

  @action
  Future<void> loadPets() => _petStore.loadPets();

  @action
  void setEspecieFilter(String? v) => _petStore.setEspecieFilter(v);

  @action
  void setPorteFilter(String? v) => _petStore.setPorteFilter(v);

  @action
  Future<RequestAdoptionResult> requestAdoption(PetModel pet) async {
    final user = _authStore.firebaseUser;
    if (user == null) {
      adoptErrorMessage = 'Você precisa estar logado para solicitar adoção.';
      return RequestAdoptionResult.notLogged;
    }
    isAdopting = true;
    adoptErrorMessage = null;
    try {
      final alreadyRequested = await _adoptionRepository.hasActiveRequest(
        petId: pet.id,
        adotanteId: user.uid,
      );
      if (alreadyRequested) {
        adoptErrorMessage =
            'Você já tem uma solicitação ativa para este pet.';
        return RequestAdoptionResult.duplicate;
      }
      final adoption = AdoptionModel(
        id: '',
        petId: pet.id,
        petNome: pet.nome,
        petFotoUrl: pet.primeiraFotoUrl,
        adotanteId: user.uid,
        adotanteNome: _authStore.displayName,
        protetorId: pet.protetorId,
        status: AdoptionStatusValues.interesse,
        criadoEm: DateTime.now(),
      );
      await _adoptionRepository.createAdoption(adoption);
      return RequestAdoptionResult.success;
    } catch (e) {
      adoptErrorMessage = 'Não foi possível enviar a solicitação: $e';
      return RequestAdoptionResult.error;
    } finally {
      isAdopting = false;
    }
  }
}

enum RequestAdoptionResult { success, duplicate, notLogged, error }
