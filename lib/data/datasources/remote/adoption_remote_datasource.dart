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
}
