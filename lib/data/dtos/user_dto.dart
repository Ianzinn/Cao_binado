import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

class UserDto {
  static UserModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return UserModel(
      uid: doc.id,
      nome: d['nome'] as String,
      email: d['email'] as String,
      tipoUsuario: d['tipoUsuario'] as String,
      fotoPerfilUrl: d['fotoPerfilUrl'] as String?,
      telefone: d['telefone'] as String?,
      favoritePetIds: List<String>.from(d['favoritePetIds'] as List? ?? []),
      criadoEm: (d['criadoEm'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(UserModel model) => {
        'nome': model.nome,
        'email': model.email,
        'tipoUsuario': model.tipoUsuario,
        if (model.fotoPerfilUrl != null) 'fotoPerfilUrl': model.fotoPerfilUrl,
        if (model.telefone != null) 'telefone': model.telefone,
        'favoritePetIds': model.favoritePetIds,
        'criadoEm': Timestamp.fromDate(model.criadoEm),
      };
}
