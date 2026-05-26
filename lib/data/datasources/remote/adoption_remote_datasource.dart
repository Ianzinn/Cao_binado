import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/adoption_model.dart';
import '../../dtos/adoption_dto.dart';

class AdoptionRemoteDatasource {
  AdoptionRemoteDatasource() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> get _adoptions =>
      _db.collection('adoptions');

  Future<String> createAdoption(AdoptionModel adoption) async {
    final doc = await _adoptions.add(AdoptionDto.toFirestore(adoption));
    return doc.id;
  }

  /// Operação atômica: cria a adoção E marca o pet como adotado num único
  /// batch. Se qualquer write falhar, nenhum é aplicado (consistência).
  Future<String> adoptPet({
    required AdoptionModel adoption,
    required String petId,
  }) async {
    final adoptionRef = _adoptions.doc();
    final petRef = _db.collection('pets').doc(petId);
    final batch = _db.batch();
    batch.set(adoptionRef, AdoptionDto.toFirestore(adoption));
    batch.update(petRef, {'status': 'adotado'});
    await batch.commit();
    return adoptionRef.id;
  }

  Stream<List<AdoptionModel>> getAdoptionsByProtetor(String protetorId) =>
      _adoptions
          .where('protetorId', isEqualTo: protetorId)
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((s) => s.docs.map(AdoptionDto.fromFirestore).toList());

  Stream<List<AdoptionModel>> getAdoptionsByAdotante(String adotanteId) =>
      _adoptions
          .where('adotanteId', isEqualTo: adotanteId)
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((s) => s.docs.map(AdoptionDto.fromFirestore).toList());

  Future<void> updateAdoptionStatus(String id, String status) =>
      _adoptions.doc(id).update({'status': status});

  /// Stream de solicitações pendentes recebidas pelo protetor — inclui
  /// interesse, visita agendada e reagendamento pendente.
  Stream<List<AdoptionModel>> getPendingRequestsForProtetor(String protetorId) =>
      _adoptions
          .where('protetorId', isEqualTo: protetorId)
          .where('status', whereIn: [
            AdoptionStatusValues.interesse,
            AdoptionStatusValues.visitaAgendada,
            AdoptionStatusValues.reagendamentoPendente,
          ])
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((s) => s.docs.map(AdoptionDto.fromFirestore).toList());

  /// Verifica se já existe uma solicitação ativa deste usuário para este pet.
  Future<bool> hasActiveRequest({
    required String petId,
    required String adotanteId,
  }) async {
    final snap = await _adoptions
        .where('petId', isEqualTo: petId)
        .where('adotanteId', isEqualTo: adotanteId)
        .where('status', whereIn: [
          AdoptionStatusValues.interesse,
          AdoptionStatusValues.visitaAgendada,
          AdoptionStatusValues.reagendamentoPendente,
        ])
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  /// Aprova a solicitação: marca como visita_agendada com dados da visita
  /// E o pet como adotado (atômico — pet sai da listagem).
  Future<void> approveAdoption({
    required String adoptionId,
    required String petId,
    required String visitLocation,
    required DateTime visitDateTime,
    String? visitNotes,
  }) async {
    final adoptionRef = _adoptions.doc(adoptionId);
    final petRef = _db.collection('pets').doc(petId);
    final batch = _db.batch();
    batch.update(adoptionRef, {
      'status': AdoptionStatusValues.visitaAgendada,
      'visitLocation': visitLocation,
      'visitaData': Timestamp.fromDate(visitDateTime),
      if (visitNotes != null && visitNotes.isNotEmpty) 'visitNotes': visitNotes,
      'viewedByAdotante': false,
    });
    batch.update(petRef, {'status': 'visita_agendada'});
    await batch.commit();
  }

  /// Finaliza a visita: se adotado, pet→adotado + adoção→adotado;
  /// se não adotado, pet→disponivel + adoção→nao_adotado (atômico).
  Future<void> finalizeVisit({
    required String adoptionId,
    required String petId,
    required bool adopted,
  }) async {
    final adoptionRef = _adoptions.doc(adoptionId);
    final petRef = _db.collection('pets').doc(petId);
    final batch = _db.batch();
    if (adopted) {
      batch.update(adoptionRef, {'status': AdoptionStatusValues.adotado});
      batch.update(petRef, {'status': 'adotado'});
    } else {
      batch.update(adoptionRef, {'status': AdoptionStatusValues.naoAdotado});
      batch.update(petRef, {'status': 'disponivel'});
    }
    await batch.commit();
  }

  /// Recusa a solicitação — apenas muda o status pra cancelado.
  /// O pet continua disponível pra outras solicitações.
  Future<void> rejectAdoption(String adoptionId) =>
      _adoptions.doc(adoptionId).update({
        'status': AdoptionStatusValues.cancelado,
      });

  /// Busca a notificação de visita agendada pendente (não vista ainda)
  /// pra um adotante — usada no launch do app pra exibir o bottom sheet.
  Future<AdoptionModel?> findPendingVisitNotification(
      String adotanteId) async {
    final snap = await _adoptions
        .where('adotanteId', isEqualTo: adotanteId)
        .get();
    final pending = snap.docs
        .map(AdoptionDto.fromFirestore)
        .where((a) => !a.viewedByAdotante &&
            (a.status == AdoptionStatusValues.visitaAgendada ||
             a.rescheduleRejected))
        .toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return pending.first;
  }

  /// Marca uma notificação de visita como já vista pelo adotante.
  Future<void> markVisitNotificationViewed(String adoptionId) =>
      _adoptions.doc(adoptionId).update({
        'viewedByAdotante': true,
        'rescheduleRejected': false,
      });

  /// Adotante solicita reagendamento — status → reagendamento_pendente.
  Future<void> requestReschedule({
    required String adoptionId,
    required DateTime newDateTime,
    required String reason,
  }) =>
      _adoptions.doc(adoptionId).update({
        'status': AdoptionStatusValues.reagendamentoPendente,
        'rescheduleData': Timestamp.fromDate(newDateTime),
        'rescheduleReason': reason,
      });

  /// Protetor aceita o reagendamento — atualiza visitaData e volta pra
  /// visita_agendada.
  Future<void> approveReschedule(String adoptionId) async {
    final doc = await _adoptions.doc(adoptionId).get();
    final rescheduleData = doc.data()?['rescheduleData'] as Timestamp?;
    if (rescheduleData == null) return;
    await _adoptions.doc(adoptionId).update({
      'status': AdoptionStatusValues.visitaAgendada,
      'visitaData': rescheduleData,
      'rescheduleData': FieldValue.delete(),
      'rescheduleReason': FieldValue.delete(),
      'viewedByAdotante': false,
    });
  }

  /// Protetor recusa o reagendamento — volta pra visita_agendada com a data
  /// original e notifica o adotante via rescheduleRejected + viewedByAdotante.
  Future<void> rejectReschedule(String adoptionId) =>
      _adoptions.doc(adoptionId).update({
        'status': AdoptionStatusValues.visitaAgendada,
        'rescheduleData': FieldValue.delete(),
        'rescheduleReason': FieldValue.delete(),
        'rescheduleRejected': true,
        'viewedByAdotante': false,
      });

  /// Adotante cancela a solicitação — status → cancelado.
  Future<void> cancelAdoptionByAdotante(String adoptionId) =>
      _adoptions.doc(adoptionId).update({
        'status': AdoptionStatusValues.cancelado,
      });

  /// Stream de contagem de notificações não lidas do adotante.
  /// Usa apenas um filtro de igualdade — sem índice composto necessário.
  Stream<int> getUnreadNotificationCountForAdotante(String adotanteId) =>
      _adoptions
          .where('adotanteId', isEqualTo: adotanteId)
          .snapshots()
          .map((s) => s.docs
              .map(AdoptionDto.fromFirestore)
              .where((a) =>
                  !a.viewedByAdotante &&
                  (a.status == AdoptionStatusValues.visitaAgendada ||
                   a.rescheduleRejected))
              .length);

  /// Stream das adoções ativas do adotante (interesse, visita agendada,
  /// reagendamento pendente) — usada na página Minhas Adoções.
  Stream<List<AdoptionModel>> getActiveAdoptionsByAdotante(String adotanteId) =>
      _adoptions
          .where('adotanteId', isEqualTo: adotanteId)
          .where('status', whereIn: [
            AdoptionStatusValues.interesse,
            AdoptionStatusValues.visitaAgendada,
            AdoptionStatusValues.reagendamentoPendente,
          ])
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((s) => s.docs.map(AdoptionDto.fromFirestore).toList());
}
