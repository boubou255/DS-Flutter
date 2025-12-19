import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Sign in
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erreur de connexion';
    }
  }

  // 🔹 Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Auth state listener
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
