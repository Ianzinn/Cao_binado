class UserModel {
  const UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    required this.criadoEm,
    this.fotoPerfilUrl,
    this.telefone,
  });

  final String uid;
  final String nome;
  final String email;

  /// 'adotante' ou 'admin'
  final String tipoUsuario;
  final String? fotoPerfilUrl;
  final String? telefone;
  final DateTime criadoEm;

  UserModel copyWith({
    String? nome,
    String? email,
    String? tipoUsuario,
    String? fotoPerfilUrl,
    String? telefone,
  }) =>
      UserModel(
        uid: uid,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        tipoUsuario: tipoUsuario ?? this.tipoUsuario,
        fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
        telefone: telefone ?? this.telefone,
        criadoEm: criadoEm,
      );
}
