class UserModel {
  const UserModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    required this.criadoEm,
    this.fotoPerfilUrl,
    this.telefone,
    this.favoritePetIds = const [],
    this.cpf,
    this.cep,
    this.uf,
    this.cidade,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.observacoes,
  });

  final String uid;
  final String nome;
  final String email;

  /// 'adotante' ou 'admin'
  final String tipoUsuario;
  final String? fotoPerfilUrl;
  final String? telefone;
  final DateTime criadoEm;
  final List<String> favoritePetIds;
  final String? cpf;
  final String? cep;
  final String? uf;
  final String? cidade;
  final String? bairro;
  final String? endereco;
  final String? numero;
  final String? complemento;
  final String? observacoes;

  UserModel copyWith({
    String? nome,
    String? email,
    String? tipoUsuario,
    String? fotoPerfilUrl,
    String? telefone,
    List<String>? favoritePetIds,
  }) =>
      UserModel(
        uid: uid,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        tipoUsuario: tipoUsuario ?? this.tipoUsuario,
        fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
        telefone: telefone ?? this.telefone,
        criadoEm: criadoEm,
        favoritePetIds: favoritePetIds ?? this.favoritePetIds,
        cpf: cpf,
        cep: cep,
        uf: uf,
        cidade: cidade,
        bairro: bairro,
        endereco: endereco,
        numero: numero,
        complemento: complemento,
        observacoes: observacoes,
      );
}
