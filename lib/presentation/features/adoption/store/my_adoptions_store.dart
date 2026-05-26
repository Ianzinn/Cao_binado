// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../auth/store/auth_store.dart';

part 'my_adoptions_store.g.dart';

class MyAdoptionsStore = _MyAdoptionsStore with _$MyAdoptionsStore;

abstract class _MyAdoptionsStore with Store {
  _MyAdoptionsStore(this._adoptionRepository, this._authStore);

  final AdoptionRepository _adoptionRepository;
  final AuthStore _authStore;
  StreamSubscription<List<AdoptionModel>>? _sub;

  @observable
  ObservableList<AdoptionModel> adoptions = ObservableList<AdoptionModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isProcessing = false;

  @action
  void start() {
    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;
    isLoading = true;
    errorMessage = null;
    _sub?.cancel();
    _sub = _adoptionRepository.getActiveAdoptionsByAdotante(uid).listen(
      (list) {
        debugPrint('📋 MyAdoptionsStore: ${list.length} adoptions');
        runInAction(() {
          adoptions
            ..clear()
            ..addAll(list);
          isLoading = false;
        });
      },
      onError: (e, st) {
        debugPrint('❌ MyAdoptionsStore error: $e\n$st');
        runInAction(() {
          errorMessage = 'Erro ao carregar adoções: $e';
          isLoading = false;
        });
      },
    );
  }

  @action
  Future<bool> requestReschedule(
    AdoptionModel adoption, {
    required DateTime newDateTime,
    required String reason,
  }) async {
    isProcessing = true;
    errorMessage = null;
    try {
      await _adoptionRepository.requestReschedule(
        adoptionId: adoption.id,
        newDateTime: newDateTime,
        reason: reason,
      );
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível solicitar reagendamento: $e';
      return false;
    } finally {
      isProcessing = false;
    }
  }

  @action
  Future<bool> cancelAdoption(AdoptionModel adoption) async {
    isProcessing = true;
    errorMessage = null;
    try {
      await _adoptionRepository.cancelAdoptionByAdotante(adoption.id);
      return true;
    } catch (e) {
      errorMessage = 'Não foi possível cancelar a solicitação: $e';
      return false;
    } finally {
      isProcessing = false;
    }
  }

  void dispose() => _sub?.cancel();
}
