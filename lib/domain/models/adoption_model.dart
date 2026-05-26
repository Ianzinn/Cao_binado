class AdoptionStatusValues {
  static const interesse = 'interesse';
  static const visitaAgendada = 'visita_agendada';
  static const reagendamentoPendente = 'reagendamento_pendente';
  static const adotado = 'adotado';
  static const cancelado = 'cancelado';
  static const naoAdotado = 'nao_adotado';
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
    this.rescheduleData,
    this.rescheduleReason,
    this.rescheduleRejected = false,
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

  /// Nova data/hora proposta pelo adotante no reagendamento.
  final DateTime? rescheduleData;

  /// Motivo do reagendamento informado pelo adotante.
  final String? rescheduleReason;

  /// `true` quando o protetor recusou o reagendamento e o adotante ainda
  /// não foi notificado (viewedByAdotante volta pra false junto).
  final bool rescheduleRejected;

  AdoptionModel copyWith({
    String? status,
    DateTime? visitaData,
    String? visitLocation,
    String? visitNotes,
    bool? viewedByAdotante,
    DateTime? rescheduleData,
    String? rescheduleReason,
    bool? rescheduleRejected,
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
        rescheduleData: rescheduleData ?? this.rescheduleData,
        rescheduleReason: rescheduleReason ?? this.rescheduleReason,
        rescheduleRejected: rescheduleRejected ?? this.rescheduleRejected,
      );
}
