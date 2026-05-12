import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadPetImage(File file, String petId, String fileName);
  Future<void> deletePetImage(String imageUrl);
  Future<String> uploadProfileImage(File file, String userId);
}
