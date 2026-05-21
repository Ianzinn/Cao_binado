import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pet_model.dart';

class PetDto {
  static PetModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return PetModel(
      id: doc.id,
      nome: d['nome'] as String,
      especie: d['especie'] as String? ?? '',
      raca: d['raca'] as String? ?? '',
      idade: d['idade'] as String? ?? '',
      porte: d['porte'] as String? ?? '',
      descricao: d['descricao'] as String? ?? '',
      status: switch (d['status'] as String? ?? '') {
        'adotado' => PetStatus.adotado,
        'visita_agendada' => PetStatus.visitaAgendada,
        _ => PetStatus.disponivel,
      },
      protetorId: d['protetorId'] as String,
      fotosUrls: List<String>.from(d['fotosUrls'] as List? ?? []),
      criadoEm: (d['criadoEm'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(PetModel model) => {
        'nome': model.nome,
        'especie': model.especie,
        'raca': model.raca,
        'idade': model.idade,
        'porte': model.porte,
        'descricao': model.descricao,
        'status': switch (model.status) {
          PetStatus.adotado => 'adotado',
          PetStatus.visitaAgendada => 'visita_agendada',
          PetStatus.disponivel => 'disponivel',
        },
        'protetorId': model.protetorId,
        'fotosUrls': model.fotosUrls,
        'criadoEm': Timestamp.fromDate(model.criadoEm),
      };
}
