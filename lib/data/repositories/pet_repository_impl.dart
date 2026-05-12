import '../../domain/models/pet_model.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/remote/pet_remote_datasource.dart';

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl(this._datasource);

  final PetRemoteDatasource _datasource;

  @override
  Future<String> createPet(PetModel pet) => _datasource.createPet(pet);

  @override
  Future<void> updatePet(PetModel pet) => _datasource.updatePet(pet);

  @override
  Future<void> updatePetPhotos(String petId, List<String> fotosUrls) =>
      _datasource.updatePetPhotos(petId, fotosUrls);

  @override
  Future<PetModel?> getPetById(String id) => _datasource.getPetById(id);

  @override
  Stream<List<PetModel>> getPetsStream({String? especie, String? porte}) =>
      _datasource.getPetsStream(especie: especie, porte: porte);

  @override
  Stream<List<PetModel>> getPetsByProtetor(String protetorId) =>
      _datasource.getPetsByProtetor(protetorId);

  @override
  Future<void> deletePet(String id) => _datasource.deletePet(id);
}
