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
  StreamSubscription<List<AdoptionModel>>? _pendingRequestsSub;
  StreamSubscription<int>? _unreadSub;

  @observable
  int totalDonations = 0;

  @observable
  int adoptedAnimals = 0;

  @observable
  String currentDate = '';

  /// Contagem de solicitações pendentes para o admin (badge + notificação).
  @observable
  int adminPendingCount = 0;

  /// Solicitação mais recente ainda não vista pelo admin — dispara bottomsheet.
  @observable
  AdoptionModel? newAdminRequest;

  /// Contagem de notificações não lidas do adotante.
  @observable
  int userUnreadCount = 0;

  bool _initialized = false;
  bool _adminFirstLoad = true;

  @computed
  String get userName => _authStore.displayName;

  @computed
  bool get isAdmin => _authStore.isAdmin;

  @action
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final now = DateTime.now();
    currentDate = '${now.day} de ${_monthName(now.month)}';

    final uid = _authStore.firebaseUser?.uid;
    if (uid == null) return;

    // Sempre inicia as três subscriptions — não depende de isAdmin estar
    // correto no momento do initialize (userProfile pode chegar depois).
    _adoptionSub?.cancel();
    _adoptionSub = _adoptionRepository.getAdoptionsByProtetor(uid).listen(
      (list) {
        runInAction(() {
          adoptedAnimals =
              list.where((a) => a.status == AdoptionStatusValues.adotado).length;
          totalDonations = list.length;
        });
      },
      onError: (_) {},
    );

    _pendingRequestsSub?.cancel();
    _adminFirstLoad = true;
    _pendingRequestsSub =
        _adoptionRepository.getPendingRequestsForProtetor(uid).listen(
      (list) {
        runInAction(() {
          final prev = adminPendingCount;
          adminPendingCount = list.length;
          // Primeira emissão com dados OU nova solicitação chegou
          if ((_adminFirstLoad || list.length > prev) && list.isNotEmpty) {
            newAdminRequest = list.first;
          }
          _adminFirstLoad = false;
        });
      },
      onError: (_) {},
    );

    _unreadSub?.cancel();
    _unreadSub = _adoptionRepository
        .getUnreadNotificationCountForAdotante(uid)
        .listen(
      (count) => runInAction(() => userUnreadCount = count),
      onError: (_) {},
    );
  }

  @action
  void clearAdminNotification() => newAdminRequest = null;

  void dispose() {
    _adoptionSub?.cancel();
    _pendingRequestsSub?.cancel();
    _unreadSub?.cancel();
    _initialized = false;
    _adminFirstLoad = true;
    totalDonations = 0;
    adoptedAnimals = 0;
    adminPendingCount = 0;
    newAdminRequest = null;
    userUnreadCount = 0;
  }

  String _monthName(int month) {
    const months = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    return months[month - 1];
  }
}
