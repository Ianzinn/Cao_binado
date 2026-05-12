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
}
