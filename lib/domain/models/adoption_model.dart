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
    this.petFotoUrl,
    this.visitaData,
    this.visitLocation,
    this.visitNotes,
    this.viewedByAdotante = false,
  });

  final String id;
  final String petId;
  final String petNome;
  final String? petFotoUrl;
  final String adotanteId;
  final String adotanteNome;
  final String protetorId;

  /// Use [AdoptionStatusValues] constants.
  final String status;
  final DateTime criadoEm;

  /// Data E hora da visita combinadas (Timestamp único).
  final DateTime? visitaData;
  final String? visitLocation;
  final String? visitNotes;

  /// `true` quando o adotante já viu o bottom sheet de visita agendada.
  final bool viewedByAdotante;

  AdoptionModel copyWith({
    String? status,
    DateTime? visitaData,
    String? visitLocation,
    String? visitNotes,
    bool? viewedByAdotante,
  }) =>
      AdoptionModel(
        id: id,
        petId: petId,
        petNome: petNome,
        petFotoUrl: petFotoUrl,
        adotanteId: adotanteId,
        adotanteNome: adotanteNome,
        protetorId: protetorId,
        status: status ?? this.status,
        criadoEm: criadoEm,
        visitaData: visitaData ?? this.visitaData,
        visitLocation: visitLocation ?? this.visitLocation,
        visitNotes: visitNotes ?? this.visitNotes,
        viewedByAdotante: viewedByAdotante ?? this.viewedByAdotante,
      );
}
