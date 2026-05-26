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
      petFotoUrl: d['petFotoUrl'] as String?,
      adotanteId: d['adotanteId'] as String,
      adotanteNome: d['adotanteNome'] as String? ?? '',
      protetorId: d['protetorId'] as String,
      status: d['status'] as String? ?? AdoptionStatusValues.interesse,
      criadoEm: (d['criadoEm'] as Timestamp).toDate(),
      visitaData: d['visitaData'] != null
          ? (d['visitaData'] as Timestamp).toDate()
          : null,
      visitLocation: d['visitLocation'] as String?,
      visitNotes: d['visitNotes'] as String?,
      viewedByAdotante: d['viewedByAdotante'] as bool? ?? false,
      rescheduleData: d['rescheduleData'] != null
          ? (d['rescheduleData'] as Timestamp).toDate()
          : null,
      rescheduleReason: d['rescheduleReason'] as String?,
      rescheduleRejected: d['rescheduleRejected'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toFirestore(AdoptionModel model) => {
        'petId': model.petId,
        'petNome': model.petNome,
        if (model.petFotoUrl != null) 'petFotoUrl': model.petFotoUrl,
        'adotanteId': model.adotanteId,
        'adotanteNome': model.adotanteNome,
        'protetorId': model.protetorId,
        'status': model.status,
        'criadoEm': Timestamp.fromDate(model.criadoEm),
        if (model.visitaData != null)
          'visitaData': Timestamp.fromDate(model.visitaData!),
        if (model.visitLocation != null) 'visitLocation': model.visitLocation,
        if (model.visitNotes != null) 'visitNotes': model.visitNotes,
        'viewedByAdotante': model.viewedByAdotante,
        if (model.rescheduleData != null)
          'rescheduleData': Timestamp.fromDate(model.rescheduleData!),
        if (model.rescheduleReason != null)
          'rescheduleReason': model.rescheduleReason,
        if (model.rescheduleRejected) 'rescheduleRejected': true,
      };
}
