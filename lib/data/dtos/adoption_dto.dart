import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/adoption_model.dart';

class AdoptionDto {
  static AdoptionModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return AdoptionModel(
      id: doc.id,
      petId: d['petId'] as String,
      petNome: d['petNome'] as String? ?? '',
      adotanteId: d['adotanteId'] as String,
      adotanteNome: d['adotanteNome'] as String? ?? '',
      protetorId: d['protetorId'] as String,
      status: d['status'] as String? ?? AdoptionStatusValues.interesse,
      criadoEm: (d['criadoEm'] as Timestamp).toDate(),
      visitaData: d['visitaData'] != null
          ? (d['visitaData'] as Timestamp).toDate()
          : null,
    );
  }

  static Map<String, dynamic> toFirestore(AdoptionModel model) => {
        'petId': model.petId,
        'petNome': model.petNome,
        'adotanteId': model.adotanteId,
        'adotanteNome': model.adotanteNome,
        'protetorId': model.protetorId,
        'status': model.status,
        'criadoEm': Timestamp.fromDate(model.criadoEm),
        if (model.visitaData != null)
          'visitaData': Timestamp.fromDate(model.visitaData!),
      };
}
