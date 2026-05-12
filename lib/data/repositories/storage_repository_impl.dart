import 'dart:io';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/remote/storage_remote_datasource.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl(this._datasource);

  final StorageRemoteDatasource _datasource;

  @override
  Future<String> uploadPetImage(File file, String petId, String fileName) =>
      _datasource.uploadPetImage(file, petId, fileName);

  @override
  Future<void> deletePetImage(String imageUrl) =>
      _datasource.deletePetImage(imageUrl);

  @override
  Future<String> uploadProfileImage(File file, String userId) =>
      _datasource.uploadProfileImage(file, userId);
}
