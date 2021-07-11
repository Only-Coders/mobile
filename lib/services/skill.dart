import 'package:mobile/http_client.dart';
import 'package:mobile/models/skill.dart';

class SkillService {
  final HttpClient _httpClient = HttpClient();

  SkillService();

  Future<List<Skill>> getSkills(String name) async {
    var response = await _httpClient
        .getRequest("/api/skills", {"skillName": name, "size": 5});
    return (response.data["content"] as List)
        .map((skill) => Skill.fromJson(skill))
        .toList();
  }

  Future<void> createSkill(Skill skill) async {
    var skillJson = skill.toJson();
    if (skill.canonicalName.isEmpty) skillJson.remove("canonicalName");
    await _httpClient.postRequest("/api/users/skills", skillJson);
  }

  Future<void> removeSkill(String skillCanonicalName) async {
    await _httpClient.deleteRequest("/api/users/skills/$skillCanonicalName");
  }
}
