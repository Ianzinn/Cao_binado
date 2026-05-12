// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';

part 'history_store.g.dart';

enum AdoptionStatus { adopted, cancelled, open }

class AdoptionRecord {
  AdoptionRecord({
    required this.id,
    required this.petName,
    required this.adopterName,
    required this.status,
  });
  final String id;
  final String petName;
  final String adopterName;
  final AdoptionStatus status;
}

class HistoryStore = _HistoryStore with _$HistoryStore;

abstract class _HistoryStore with Store {
  _HistoryStore(this._adoptionRepository, this._authStore);

  final AdoptionRepository _adoptionRepository;
  final AuthStore _authStore;
  StreamSubscription<List<AdoptionModel>>? _sub;

  @observable
  ObservableList<AdoptionRecord> records = ObservableList<AdoptionRecord>();

  @observable
  bool isLoading = false;

  @computed
  int get inProgressCount =>
      records.where((r) => r.status == AdoptionStatus.open).length;

  @computed
  int get completedCount =>
      records.where((r) => r.status == AdoptionStatus.adopted).length;

  @action
  Future<void> loadHistory() async {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;

    isLoading = true;
    await _sub?.cancel();
    _sub = _adoptionRepository.getAdoptionsByProtetor(uid).listen(
      (list) {
        runInAction(() {
          records
            ..clear()
            ..addAll(list.map(_toRecord));
          isLoading = false;
        });
      },
      onError: (_) => runInAction(() => isLoading = false),
    );
  }

  void dispose() => _sub?.cancel();

  AdoptionRecord _toRecord(AdoptionModel m) => AdoptionRecord(
        id: m.id,
        petName: m.petNome,
        adopterName: m.adotanteNome,
        status: switch (m.status) {
          AdoptionStatusValues.adotado => AdoptionStatus.adopted,
          AdoptionStatusValues.cancelado => AdoptionStatus.cancelled,
          _ => AdoptionStatus.open,
        },
      );
}
