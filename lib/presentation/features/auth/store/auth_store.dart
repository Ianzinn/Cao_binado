// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import '../../../../domain/models/user_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../core/services/auth_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore(this._authService, this._userRepository) {
    _sub = _authService.authStateChanges.listen(_onAuthChanged);
  }

  final AuthService _authService;
  final UserRepository _userRepository;
  late final StreamSubscription<User?> _sub;

  @observable
  User? firebaseUser;

  @observable
  UserModel? userProfile;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get isAuthenticated => firebaseUser != null;

  @computed
  bool get isAdmin => userProfile?.tipoUsuario == 'admin';

  @computed
  String get displayName =>
      userProfile?.nome ?? firebaseUser?.displayName ?? '';

  @computed
  String get displayEmail => userProfile?.email ?? firebaseUser?.email ?? '';

  @action
  void _onAuthChanged(User? user) {
    firebaseUser = user;
    if (user != null) {
      _fetchProfile(user.uid);
    } else {
      userProfile = null;
    }
  }

  @action
  Future<void> _fetchProfile(String uid) async {
    userProfile = await _userRepository.getUserById(uid);
  }

  @action
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapError(e.code);
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> register({
    required String email,
    required String password,
    required String nome,
    required String tipoUsuario,
  }) async {
    isLoading = true;
    errorMessage = null;
    try {
      final cred =
          await _authService.createUserWithEmailAndPassword(email, password);
      final user = UserModel(
        uid: cred.user!.uid,
        nome: nome,
        email: email,
        tipoUsuario: tipoUsuario,
        criadoEm: DateTime.now(),
      );
      await _userRepository.createUser(user);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapError(e.code);
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() => _authService.signOut();

  @action
  Future<void> updateProfilePhoto(String url) async {
    final profile = userProfile;
    if (profile == null) return;
    final updated = profile.copyWith(fotoPerfilUrl: url);
    await _userRepository.updateUser(updated);
    userProfile = updated;
  }

  @action
  Future<void> refreshProfile() async {
    final uid = firebaseUser?.uid;
    if (uid != null) await _fetchProfile(uid);
  }

  void dispose() => _sub.cancel();

  String _mapError(String code) => switch (code) {
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          'E-mail ou senha incorretos.',
        'email-already-in-use' => 'Este e-mail já está em uso.',
        'weak-password' => 'A senha deve ter pelo menos 6 caracteres.',
        'invalid-email' => 'E-mail inválido.',
        'too-many-requests' =>
          'Muitas tentativas. Tente novamente mais tarde.',
        _ => 'Ocorreu um erro. Tente novamente.',
      };
}
