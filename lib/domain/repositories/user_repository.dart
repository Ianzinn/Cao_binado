import '../models/user_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserById(String uid);
  Future<void> updateUser(UserModel user);
  Stream<UserModel?> streamUser(String uid);
  Future<void> addFavorite(String uid, String petId);
  Future<void> removeFavorite(String uid, String petId);
}
