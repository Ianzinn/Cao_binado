import '../models/adoption_model.dart';

abstract class AdoptionRepository {
  Future<String> createAdoption(AdoptionModel adoption);
  Stream<List<AdoptionModel>> getAdoptionsByProtetor(String protetorId);
  Stream<List<AdoptionModel>> getAdoptionsByAdotante(String adotanteId);

  /// [status] must be one of [AdoptionStatusValues] constants.
  Future<void> updateAdoptionStatus(String id, String status);

  /// Cria a adoção e marca o pet como adotado num batch atômico do Firestore.
  Future<String> adoptPet({
    required AdoptionModel adoption,
    required String petId,
  });

  /// Stream de solicitações pendentes pra um protetor (status=interesse).
  Stream<List<AdoptionModel>> getPendingRequestsForProtetor(String protetorId);

  /// Verifica se existe solicitação ativa do usuário pra este pet.
  Future<bool> hasActiveRequest({
    required String petId,
    required String adotanteId,
  });

  /// Aprova: visita_agendada com dados + pet adotado (atômico).
  Future<void> approveAdoption({
    required String adoptionId,
    required String petId,
    required String visitLocation,
    required DateTime visitDateTime,
    String? visitNotes,
  });

  /// Recusa: status = cancelado.
  Future<void> rejectAdoption(String adoptionId);

  /// Finaliza visita: se adotado, pet→adotado; se não, pet→disponivel (atômico).
  Future<void> finalizeVisit({
    required String adoptionId,
    required String petId,
    required bool adopted,
  });

  /// Visita agendada não vista ainda pelo adotante (mostrar no launch).
  Future<AdoptionModel?> findPendingVisitNotification(String adotanteId);

  /// Marca notificação de visita como vista.
  Future<void> markVisitNotificationViewed(String adoptionId);

  /// Adotante solicita reagendamento.
  Future<void> requestReschedule({
    required String adoptionId,
    required DateTime newDateTime,
    required String reason,
  });

  /// Protetor aceita o reagendamento.
  Future<void> approveReschedule(String adoptionId);

  /// Protetor recusa o reagendamento (mantém data original).
  Future<void> rejectReschedule(String adoptionId);

  /// Adotante cancela a solicitação.
  Future<void> cancelAdoptionByAdotante(String adoptionId);

  /// Stream das adoções ativas do adotante.
  Stream<List<AdoptionModel>> getActiveAdoptionsByAdotante(String adotanteId);

  /// Stream de contagem de notificações não lidas do adotante.
  Stream<int> getUnreadNotificationCountForAdotante(String adotanteId);
}
