import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/user_model.dart';
import '../../dtos/user_dto.dart';

class UserRemoteDatasource {
  UserRemoteDatasource() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<void> createUser(UserModel user) =>
      _users.doc(user.uid).set(UserDto.toFirestore(user));

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserDto.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) =>
      _users.doc(user.uid).update(UserDto.toFirestore(user));

  /// Stream do doc do usuário — emite a cada mudança (inclui favoritos).
  Stream<UserModel?> streamUser(String uid) => _users.doc(uid).snapshots().map(
        (doc) => doc.exists ? UserDto.fromFirestore(doc) : null,
      );

  Future<void> addFavorite(String uid, String petId) =>
      _users.doc(uid).update({
        'favoritePetIds': FieldValue.arrayUnion([petId]),
      });

  Future<void> removeFavorite(String uid, String petId) =>
      _users.doc(uid).update({
        'favoritePetIds': FieldValue.arrayRemove([petId]),
      });
}
