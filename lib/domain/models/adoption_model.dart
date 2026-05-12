class AdoptionStatusValues {
  static const interesse = 'interesse';
  static const visitaAgendada = 'visita_agendada';
  static const adotado = 'adotado';
  static const cancelado = 'cancelado';
}

class AdoptionModel {
  const AdoptionModel({
    required this.id,
    required this.petId,
    required this.petNome,
    required this.adotanteId,
    required this.adotanteNome,
    required this.protetorId,
    required this.status,
    required this.criadoEm,
    this.visitaData,
  });

  final String id;
  final String petId;
  final String petNome;
  final String adotanteId;
  final String adotanteNome;
  final String protetorId;

  /// Use [AdoptionStatusValues] constants.
  final String status;
  final DateTime criadoEm;
  final DateTime? visitaData;
}
