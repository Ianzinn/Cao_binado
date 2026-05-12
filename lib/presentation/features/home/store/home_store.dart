// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore(this._authStore, this._adoptionRepository);

  final AuthStore _authStore;
  final AdoptionRepository _adoptionRepository;
  StreamSubscription<List<AdoptionModel>>? _adoptionSub;

  @observable
  int totalDonations = 0;

  @observable
  int adoptedAnimals = 0;

  @observable
  String currentDate = '';

  @computed
  String get userName => _authStore.displayName;

  @computed
  bool get isAdmin => _authStore.isAdmin;

  @action
  Future<void> initialize() async {
    final now = DateTime.now();
    currentDate = '${now.day} de ${_monthName(now.month)}';

    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;

    await _adoptionSub?.cancel();
    _adoptionSub = _adoptionRepository
        .getAdoptionsByProtetor(uid)
        .listen(
      (list) {
        runInAction(() {
          adoptedAnimals =
              list.where((a) => a.status == AdoptionStatusValues.adotado).length;
          totalDonations = list.length;
        });
      },
      onError: (_) {},
    );
  }

  void dispose() => _adoptionSub?.cancel();

  String _monthName(int month) {
    const months = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return months[month - 1];
  }
}
