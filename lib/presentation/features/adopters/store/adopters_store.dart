// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';

part 'adopters_store.g.dart';

/// Agrupa adoções por pet — usado pra mostrar:
///   Pet X
///     - João interessado
///     - Maria interessada
class AdoptersGroup {
  const AdoptersGroup({required this.petNome, required this.adopters});
  final String petNome;
  final List<AdoptionModel> adopters;
}

class AdoptersStore = _AdoptersStore with _$AdoptersStore;

abstract class _AdoptersStore with Store {
  _AdoptersStore(this._adoptionRepository, this._authStore);

  final AdoptionRepository _adoptionRepository;
  final AuthStore _authStore;
  StreamSubscription<List<AdoptionModel>>? _sub;

  @observable
  ObservableList<AdoptionModel> _adoptions = ObservableList<AdoptionModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String searchQuery = '';

  /// Solicitações agrupadas por pet, filtrando por busca no nome do adotante
  /// ou do pet.
  @computed
  List<AdoptersGroup> get groupedAdopters {
    final q = searchQuery.toLowerCase().trim();
    final filtered = _adoptions
        .where((a) =>
            q.isEmpty ||
            a.petNome.toLowerCase().contains(q) ||
            a.adotanteNome.toLowerCase().contains(q))
        .toList();
    final byPet = <String, List<AdoptionModel>>{};
    for (final a in filtered) {
      byPet.putIfAbsent(a.petNome, () => []).add(a);
    }
    return byPet.entries
        .map((e) => AdoptersGroup(petNome: e.key, adopters: e.value))
        .toList();
  }

  @action
  void setSearchQuery(String v) => searchQuery = v;

  @action
  void start() {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    isLoading = true;
    errorMessage = null;
    _sub?.cancel();
    _sub = _adoptionRepository.getAdoptionsByProtetor(uid).listen(
      (list) {
        debugPrint('👥 AdoptersStore: ${list.length} adoptions');
        runInAction(() {
          _adoptions
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e, st) {
        debugPrint('❌ AdoptersStore error: $e\n$st');
        runInAction(() {
          errorMessage = 'Erro ao carregar adotantes: $e';
          isLoading = false;
        });
      },
    );
  }

  void dispose() => _sub?.cancel();
}
