// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../domain/repositories/pet_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../auth/store/auth_store.dart';

part 'favorites_store.g.dart';

class FavoritesStore = _FavoritesStore with _$FavoritesStore;

abstract class _FavoritesStore with Store {
  _FavoritesStore(this._userRepository, this._petRepository, this._authStore);

  final UserRepository _userRepository;
  final PetRepository _petRepository;
  final AuthStore _authStore;

  StreamSubscription? _userSub;
  StreamSubscription<List<PetModel>>? _petsSub;

  @observable
  ObservableSet<String> favoriteIds = ObservableSet<String>();

  @observable
  ObservableList<PetModel> favorites = ObservableList<PetModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String searchQuery = '';

  @computed
  List<PetModel> get filtered => favorites
      .where((p) => p.nome.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  bool isFavorited(String petId) => favoriteIds.contains(petId);

  @action
  void start() {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    isLoading = true;
    _userSub?.cancel();
    _userSub = _userRepository.streamUser(uid).listen((user) {
      final ids = user?.favoritePetIds ?? const <String>[];
      debugPrint('⭐ FavoritesStore: user has ${ids.length} favorites');
      runInAction(() {
        favoriteIds
          ..clear()
          ..addAll(ids);
      });
      _subscribePets(ids);
    });
  }

  void _subscribePets(List<String> ids) {
    _petsSub?.cancel();
    if (ids.isEmpty) {
      runInAction(() {
        favorites.clear();
        isLoading = false;
      });
      return;
    }
    _petsSub = _petRepository.streamPetsByIds(ids).listen(
      (list) {
        runInAction(() {
          favorites
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e) {
        debugPrint('❌ FavoritesStore.streamPets error: $e');
        runInAction(() {
          errorMessage = 'Erro ao carregar favoritos: $e';
          isLoading = false;
        });
      },
    );
  }

  @action
  Future<void> toggleFavorite(String petId) async {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    if (favoriteIds.contains(petId)) {
      favoriteIds.remove(petId); // otimismo: UI responde imediato
      await _userRepository.removeFavorite(uid, petId);
    } else {
      favoriteIds.add(petId);
      await _userRepository.addFavorite(uid, petId);
    }
  }

  @action
  void setSearchQuery(String v) => searchQuery = v;

  void dispose() {
    _userSub?.cancel();
    _petsSub?.cancel();
  }
}
