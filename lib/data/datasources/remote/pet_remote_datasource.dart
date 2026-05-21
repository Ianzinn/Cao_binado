import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/pet_model.dart';
import '../../dtos/pet_dto.dart';

class PetRemoteDatasource {
  PetRemoteDatasource() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> get _pets =>
      _db.collection('pets');

  Future<String> createPet(PetModel pet) async {
    final doc = await _pets.add(PetDto.toFirestore(pet));
    return doc.id;
  }

  Future<void> updatePet(PetModel pet) =>
      _pets.doc(pet.id).update(PetDto.toFirestore(pet));

  Future<void> updatePetPhotos(String petId, List<String> fotosUrls) =>
      _pets.doc(petId).update({'fotosUrls': fotosUrls});

  Future<void> updatePetStatus(String petId, String status) =>
      _pets.doc(petId).update({'status': status});

  Future<PetModel?> getPetById(String id) async {
    final doc = await _pets.doc(id).get();
    if (!doc.exists) return null;
    return PetDto.fromFirestore(doc);
  }

  Stream<List<PetModel>> getPetsStream({String? especie, String? porte}) {
    Query<Map<String, dynamic>> q =
        _pets.where('status', isEqualTo: 'disponivel');
    if (especie != null && especie.isNotEmpty) {
      q = q.where('especie', isEqualTo: especie);
    }
    if (porte != null && porte.isNotEmpty) {
      q = q.where('porte', isEqualTo: porte);
    }
    return q
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((s) => s.docs.map(PetDto.fromFirestore).toList());
  }

  Stream<List<PetModel>> getPetsByProtetor(String protetorId) => _pets
      .where('protetorId', isEqualTo: protetorId)
      .orderBy('criadoEm', descending: true)
      .snapshots()
      .map((s) => s.docs.map(PetDto.fromFirestore).toList());

  Future<void> deletePet(String id) => _pets.doc(id).delete();

  /// Stream de pets cujo id está na lista. Útil pra carregar a lista de
  /// favoritos do usuário (que armazena só IDs). Lida com lote de 10 IDs
  /// por restrição do `whereIn` do Firestore.
  Stream<List<PetModel>> streamPetsByIds(List<String> ids) {
    if (ids.isEmpty) return Stream.value(const []);
    // Firestore aceita whereIn com até 10 valores. Como nossos usuários
    // dificilmente terão mais que isso favoritado, fazemos 1 query simples.
    // Se ultrapassar 10, truncamos os mais recentes.
    final batch = ids.length > 10 ? ids.sublist(ids.length - 10) : ids;
    return _pets
        .where(FieldPath.documentId, whereIn: batch)
        .snapshots()
        .map((s) => s.docs.map(PetDto.fromFirestore).toList());
  }
}
