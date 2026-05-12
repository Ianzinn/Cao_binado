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
}
