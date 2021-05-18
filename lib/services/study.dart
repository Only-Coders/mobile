import 'package:mobile/http_client.dart';
import 'package:mobile/models/institute.dart';

class StudyService {
  final HttpClient _httpClient = HttpClient();

  StudyService();

  Future<List<Institute>> getInstitutes(String name) async {
    var response = await _httpClient
        .getRequest("/api/institutes", {"instituteName": name, "size": 5});
    return (response.data["content"] as List)
        .map((i) => Institute.fromJson(i))
        .toList();
  }
}
