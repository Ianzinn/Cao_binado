enum PetStatus { disponivel, adotado }

class PetModel {
  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idade,
    required this.porte,
    required this.descricao,
    required this.status,
    required this.protetorId,
    required this.fotosUrls,
    required this.criadoEm,
  });

  final String id;
  final String nome;
  final String especie;
  final String raca;
  final String idade;
  final String porte;
  final String descricao;
  final PetStatus status;
  final String protetorId;
  final List<String> fotosUrls;
  final DateTime criadoEm;

  String? get primeiraFotoUrl => fotosUrls.isNotEmpty ? fotosUrls.first : null;

  PetModel copyWith({PetStatus? status, List<String>? fotosUrls}) => PetModel(
        id: id,
        nome: nome,
        especie: especie,
        raca: raca,
        idade: idade,
        porte: porte,
        descricao: descricao,
        status: status ?? this.status,
        protetorId: protetorId,
        fotosUrls: fotosUrls ?? this.fotosUrls,
        criadoEm: criadoEm,
      );
}
