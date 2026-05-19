import '../models/adoption_model.dart';

abstract class AdoptionRepository {
  Future<String> createAdoption(AdoptionModel adoption);
  Stream<List<AdoptionModel>> getAdoptionsByProtetor(String protetorId);
  Stream<List<AdoptionModel>> getAdoptionsByAdotante(String adotanteId);

  /// [status] must be one of [AdoptionStatusValues] constants.
  Future<void> updateAdoptionStatus(String id, String status);

  /// Cria a adoção e marca o pet como adotado num batch atômico do Firestore.
  Future<String> adoptPet({
    required AdoptionModel adoption,
    required String petId,
  });
}
