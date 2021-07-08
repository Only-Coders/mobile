import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:mobile/utils/consts/consts.dart';

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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: Constants.clientId,
        clientSecret: Constants.clientSecret,
        redirectUrl:
            'https://onlycoders-cc609.firebaseapp.com/__/auth/handler');

    final result = await gitHubSignIn.signIn(context);

    final githubAuthCredential = GithubAuthProvider.credential(result.token);

    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
