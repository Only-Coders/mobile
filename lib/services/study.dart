import 'package:mobile/http_client.dart';
import 'package:mobile/models/institute.dart';
import 'package:mobile/models/study.dart';

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

  Future<void> createStudy(Study study) async {
    var studyJson = study.toJson();
    if (study.id.isEmpty) studyJson.remove("id");
    await _httpClient.postRequest("/api/users/institutes", studyJson);
  }
}
