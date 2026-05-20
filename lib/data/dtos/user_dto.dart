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
      cpf: d['cpf'] as String?,
      cep: d['cep'] as String?,
      uf: d['uf'] as String?,
      cidade: d['cidade'] as String?,
      bairro: d['bairro'] as String?,
      endereco: d['endereco'] as String?,
      numero: d['numero'] as String?,
      complemento: d['complemento'] as String?,
      observacoes: d['observacoes'] as String?,
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
        if (model.cpf != null) 'cpf': model.cpf,
        if (model.cep != null) 'cep': model.cep,
        if (model.uf != null) 'uf': model.uf,
        if (model.cidade != null) 'cidade': model.cidade,
        if (model.bairro != null) 'bairro': model.bairro,
        if (model.endereco != null) 'endereco': model.endereco,
        if (model.numero != null) 'numero': model.numero,
        if (model.complemento != null) 'complemento': model.complemento,
        if (model.observacoes != null) 'observacoes': model.observacoes,
      };
}
