import '../models/adoption_model.dart';

abstract class AdoptionRepository {
  Future<String> createAdoption(AdoptionModel adoption);
  Stream<List<AdoptionModel>> getAdoptionsByProtetor(String protetorId);
  Stream<List<AdoptionModel>> getAdoptionsByAdotante(String adotanteId);

  /// [status] must be one of [AdoptionStatusValues] constants.
  Future<void> updateAdoptionStatus(String id, String status);
}
