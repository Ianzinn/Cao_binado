import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService() : _auth = FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
          String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
          String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() => _auth.signOut();
}
