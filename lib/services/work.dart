import 'package:mobile/http_client.dart';
import "package:mobile/models/work_position.dart";
import 'package:mobile/models/workplace.dart';

class WorkService {
  final HttpClient _httpClient = HttpClient();

  WorkService();

  Future<List<Workplace>> getWorkplaces(String name) async {
    var response = await _httpClient
        .getRequest("/api/workplaces", {"workplaceName": name, "size": 5});
    return (response.data["content"] as List)
        .map((work) => Workplace.fromJson(work))
        .toList();
  }

  Future<void> createWork(WorkPosition work) async {
    var workJson = work.toJson();
    if (work.workplace.id.isEmpty) workJson.remove("id");
    await _httpClient.postRequest("/api/users/workplaces", workJson);
  }
}
