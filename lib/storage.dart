import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> setToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  static Future<String> getToken() async {
    return await _storage.read(key: "token");
  }
}
