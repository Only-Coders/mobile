import 'package:mobile/http_client.dart';
import 'package:mobile/models/contact.dart';

class UserService {
  final HttpClient _httpClient = HttpClient();

  UserService();

  Future<List<Contact>> getUsersByFullName([String name]) async {
    var response = await _httpClient
        .getRequest("/api/users", {"partialName": name, "size": 3});
    return (response.data["content"] as List)
        .map((c) => Contact.fromJson(c))
        .toList();
  }
}
