import 'package:mobile/http_client.dart';
import 'package:mobile/models/tag.dart';

class TagService {
  final HttpClient _httpClient = HttpClient();

  TagService();

  Future<List<Tag>> getTags([String name]) async {
    var response = await _httpClient
        .getRequest("/api/tags", {"tagName": name, "size": 10});
    return (response.data["content"] as List)
        .map((t) => Tag.fromJson(t))
        .toList();
  }

  Future<void> followTag(String canonicalName) async {
    await _httpClient.postRequest("/api/users/tags/" + canonicalName, {});
  }
}
