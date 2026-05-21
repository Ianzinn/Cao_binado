// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';

part 'adoption_requests_store.g.dart';

class AdoptionRequestsStore = _AdoptionRequestsStore
    with _$AdoptionRequestsStore;

abstract class _AdoptionRequestsStore with Store {
  _AdoptionRequestsStore(this._adoptionRepository, this._authStore);

  final AdoptionRepository _adoptionRepository;
  final AuthStore _authStore;
  StreamSubscription<List<AdoptionModel>>? _sub;

  @observable
  ObservableList<AdoptionModel> requests = ObservableList<AdoptionModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isProcessing = false;

  @computed
  int get pendingCount => requests.length;

  @action
  void start() {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    isLoading = true;
    errorMessage = null;
    _sub?.cancel();
    _sub = _adoptionRepository.getPendingRequestsForProtetor(uid).listen(
      (list) {
        debugPrint('📨 AdoptionRequestsStore: ${list.length} pending');
        runInAction(() {
          requests
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e, st) {
        debugPrint('❌ AdoptionRequestsStore error: $e\n$st');
        runInAction(() {
          errorMessage = 'Erro ao carregar solicitações: $e';
          isLoading = false;
        });
      },
    );
  }

  @action
  Future<bool> approve(
    AdoptionModel request, {
    required String visitLocation,
    required DateTime visitDateTime,
    String? visitNotes,
  }) async {
    isProcessing = true;
    errorMessage = null;
    try {
      await _adoptionRepository.approveAdoption(
        adoptionId: request.id,
        petId: request.petId,
        visitLocation: visitLocation,
        visitDateTime: visitDateTime,
        visitNotes: visitNotes,
      );
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível aprovar: $e';
      return false;
    } finally {
      isProcessing = false;
    }
  }

  @action
  Future<bool> reject(AdoptionModel request) async {
    isProcessing = true;
    errorMessage = null;
    try {
      await _adoptionRepository.rejectAdoption(request.id);
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível recusar: $e';
      return false;
    } finally {
      isProcessing = false;
    }
  }

  @action
  Future<bool> finalizeVisit(AdoptionModel request,
      {required bool adopted}) async {
    isProcessing = true;
    errorMessage = null;
    try {
      await _adoptionRepository.finalizeVisit(
        adoptionId: request.id,
        petId: request.petId,
        adopted: adopted,
      );
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível finalizar a visita: $e';
      return false;
    } finally {
      isProcessing = false;
    }
  }

  void dispose() => _sub?.cancel();
}
