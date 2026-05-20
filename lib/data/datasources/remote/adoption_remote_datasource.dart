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

  /// Stream de solicitações pendentes (status=interesse) recebidas pelo
  /// protetor — usada na tela de Solicitações do administrador.
  Stream<List<AdoptionModel>> getPendingRequestsForProtetor(String protetorId) =>
      _adoptions
          .where('protetorId', isEqualTo: protetorId)
          .where('status', isEqualTo: AdoptionStatusValues.interesse)
          .orderBy('criadoEm', descending: true)
          .snapshots()
          .map((s) => s.docs.map(AdoptionDto.fromFirestore).toList());

  /// Verifica se já existe uma solicitação ativa (interesse ou visita
  /// agendada) deste usuário para este pet — usada pra bloquear duplicatas.
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
    batch.update(petRef, {'status': 'adotado'});
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
        .where((a) =>
            a.status == AdoptionStatusValues.visitaAgendada &&
            !a.viewedByAdotante)
        .toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return pending.first;
  }

  /// Marca uma notificação de visita como já vista pelo adotante.
  Future<void> markVisitNotificationViewed(String adoptionId) =>
      _adoptions.doc(adoptionId).update({'viewedByAdotante': true});
}
