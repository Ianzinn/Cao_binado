import '../models/pet_model.dart';

abstract class PetRepository {
  Future<String> createPet(PetModel pet);
  Future<void> updatePet(PetModel pet);
  Future<void> updatePetPhotos(String petId, List<String> fotosUrls);
  Future<void> updatePetStatus(String petId, String status);
  Future<PetModel?> getPetById(String id);
  Stream<List<PetModel>> getPetsStream({String? especie, String? porte});
  Stream<List<PetModel>> getPetsByProtetor(String protetorId);
  Stream<List<PetModel>> streamPetsByIds(List<String> ids);
  Future<void> deletePet(String id);
}
