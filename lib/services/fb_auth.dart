import 'package:firebase_auth/firebase_auth.dart';

class FBAuthService {
  final FirebaseAuth _auth;

  FBAuthService(this._auth);

  Future<void> register(String email, String password) async {
    UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await credentials.user.sendEmailVerification();
  }

  Future<String> login(String email, String password) async {
    UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!credentials.user.emailVerified) {
      throw ("Please verify your email address");
    } else {
      return await credentials.user.getIdToken();
    }
  }
}
