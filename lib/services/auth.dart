import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/http_client.dart';
import 'package:mobile/models/token.dart';
import 'package:mobile/storage.dart';

class AuthService {
  final FirebaseAuth _auth;
  final HttpClient _httpClient = HttpClient();

  AuthService(this._auth);

  Future<void> register(String email, String password) async {
    UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await credentials.user.sendEmailVerification();
  }

  Future<void> login(String email, String password) async {
    UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!credentials.user.emailVerified) {
      throw ("Please verify your email address");
    } else {
      String fbToken = await credentials.user.getIdToken();
      var response = await _httpClient
          .postRequest("/api/auth/login", {"firebaseToken": fbToken});
      RegExp rgx = new RegExp(r'\w+=(?<token>.*); Path');
      Token data = Token.fromJson(response.data);
      String token = data.token +
          "." +
          rgx
              .firstMatch(response.headers.map["set-cookie"][0])
              .namedGroup("token");
      await UserStorage.setToken(token);
    }
  }

  Future<void> refreshToken(String email, String password) async {
    UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!credentials.user.emailVerified) {
      throw ("Please verify your email address");
    } else {
      String token = await credentials.user.getIdToken();
      print("Hola");

      var data = await _httpClient
          .postRequest("/auth/login", {"firebaseToken": token});
      print(data);

      // TODO: Call backend with the token provider by firebase
      print(token);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
