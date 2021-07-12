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
        .map((institute) => Institute.fromJson(institute))
        .toList();
  }

  Future<void> createStudy(Study study) async {
    var studyJson = study.toJson();
    if (study.institute.id.isEmpty) studyJson.remove("id");
    await _httpClient.postRequest("/api/users/institutes", studyJson);
  }

  Future<void> deleteStudy(String studyId) async {
    await _httpClient.deleteRequest("/api/users/institutes/$studyId");
  }

  Future<void> updateStudy(Study study) async {
    var studyJson = study.toJson();
    if (study.institute.id.isEmpty) studyJson.remove("id");
    await _httpClient.putRequest(
      "/api/users/institutes/${study.id}",
      studyJson,
    );
  }
}
