import '../../domain/models/adoption_model.dart';
import '../../domain/repositories/adoption_repository.dart';
import '../datasources/remote/adoption_remote_datasource.dart';

class AdoptionRepositoryImpl implements AdoptionRepository {
  AdoptionRepositoryImpl(this._datasource);

  final AdoptionRemoteDatasource _datasource;

  @override
  Future<String> createAdoption(AdoptionModel adoption) =>
      _datasource.createAdoption(adoption);

  @override
  Stream<List<AdoptionModel>> getAdoptionsByProtetor(String protetorId) =>
      _datasource.getAdoptionsByProtetor(protetorId);

  @override
  Stream<List<AdoptionModel>> getAdoptionsByAdotante(String adotanteId) =>
      _datasource.getAdoptionsByAdotante(adotanteId);

  @override
  Future<void> updateAdoptionStatus(String id, String status) =>
      _datasource.updateAdoptionStatus(id, status);

  @override
  Future<String> adoptPet({
    required AdoptionModel adoption,
    required String petId,
  }) =>
      _datasource.adoptPet(adoption: adoption, petId: petId);

  @override
  Stream<List<AdoptionModel>> getPendingRequestsForProtetor(String protetorId) =>
      _datasource.getPendingRequestsForProtetor(protetorId);

  @override
  Future<bool> hasActiveRequest({
    required String petId,
    required String adotanteId,
  }) =>
      _datasource.hasActiveRequest(petId: petId, adotanteId: adotanteId);

  @override
  Future<void> approveAdoption({
    required String adoptionId,
    required String petId,
    required String visitLocation,
    required DateTime visitDateTime,
    String? visitNotes,
  }) =>
      _datasource.approveAdoption(
        adoptionId: adoptionId,
        petId: petId,
        visitLocation: visitLocation,
        visitDateTime: visitDateTime,
        visitNotes: visitNotes,
      );

  @override
  Future<void> rejectAdoption(String adoptionId) =>
      _datasource.rejectAdoption(adoptionId);

  @override
  Future<AdoptionModel?> findPendingVisitNotification(String adotanteId) =>
      _datasource.findPendingVisitNotification(adotanteId);

  @override
  Future<void> markVisitNotificationViewed(String adoptionId) =>
      _datasource.markVisitNotificationViewed(adoptionId);
}
