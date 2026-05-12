import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._datasource);

  final UserRemoteDatasource _datasource;

  @override
  Future<void> createUser(UserModel user) => _datasource.createUser(user);

  @override
  Future<UserModel?> getUserById(String uid) => _datasource.getUserById(uid);

  @override
  Future<void> updateUser(UserModel user) => _datasource.updateUser(user);
}
