// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/pet_repository.dart';
import '../../auth/store/auth_store.dart';

part 'my_pets_store.g.dart';

class MyPetsStore = _MyPetsStore with _$MyPetsStore;

abstract class _MyPetsStore with Store {
  _MyPetsStore(this._petRepository, this._authStore);

  final PetRepository _petRepository;
  final AuthStore _authStore;
  StreamSubscription<List<PetModel>>? _sub;

  @observable
  ObservableList<PetModel> pets = ObservableList<PetModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  void start() {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    isLoading = true;
    errorMessage = null;
    _sub?.cancel();
    _sub = _petRepository.getPetsByProtetor(uid).listen(
      (list) {
        debugPrint('🐾 MyPetsStore: ${list.length} pets');
        runInAction(() {
          pets
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e) => runInAction(() {
        errorMessage = 'Erro ao carregar pets: $e';
        isLoading = false;
      }),
    );
  }

  @action
  Future<bool> deletePet(String petId) async {
    try {
      await _petRepository.deletePet(petId);
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível remover o pet: $e';
      return false;
    }
  }

  void dispose() => _sub?.cancel();
}
