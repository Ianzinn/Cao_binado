import '../models/pet_model.dart';

abstract class PetRepository {
  Future<String> createPet(PetModel pet);
  Future<void> updatePet(PetModel pet);
  Future<void> updatePetPhotos(String petId, List<String> fotosUrls);
  Future<PetModel?> getPetById(String id);
  Stream<List<PetModel>> getPetsStream({String? especie, String? porte});
  Stream<List<PetModel>> getPetsByProtetor(String protetorId);
  Future<void> deletePet(String id);
}
