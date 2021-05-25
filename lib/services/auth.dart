import 'package:mobile/http_client.dart';
import 'package:mobile/models/token.dart';
import 'package:mobile/screens/onboard/provider/register_model.dart';
import 'package:mobile/storage.dart';

class AuthService {
  final HttpClient _httpClient = HttpClient();

  AuthService();

  Future<void> register(RegisterModel registerData) async {
    var user = {
      "birthDate": registerData.birthDate,
      "description": registerData.description,
      "firstName": registerData.firstName,
      "lastName": registerData.lastName,
      "imageURI": registerData.imageURI,
      "country": {"code": registerData.country}
    };
    if (registerData.userName.isNotEmpty) {
      user["gitProfile"] = {
        "platform": registerData.platform,
        "userName": registerData.userName
      };
    }
    var response = await _httpClient.postRequest("/api/auth/register", user);
    RegExp rgx = new RegExp(r'\w+=(?<token>.*); Path');
    Token data = Token.fromJson(response.data);
    String token = data.token +
        "." +
        rgx
            .firstMatch(response.headers.map["set-cookie"][0])
            .namedGroup("token");
    await UserStorage.setToken(token);
  }

  Future<String> login(String fbToken) async {
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
    return token;
  }
}
