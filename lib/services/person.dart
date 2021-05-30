import 'package:mobile/http_client.dart';
import 'package:mobile/models/person.dart';

class PersonService {
  final HttpClient _httpClient = HttpClient();

  PersonService();

  Future<List<Person>> getSuggestedContacts() async {
    var response = await _httpClient.getRequest("/api/suggested-users");
    return (response.data as List)
        .map((person) => Person.fromJson(person))
        .toList();
  }

  Future<void> followPerson(String canonicalName) async {
    await _httpClient.postRequest("/api/users/following/" + canonicalName, {});
  }

  Future<void> unfollowPerson(String canonicalName) async {
    await _httpClient.deleteRequest("/api/users/following/" + canonicalName);
  }

  Future<void> sendConactRequest(String canonicalName) async {
    await _httpClient.postRequest(
        "/api/users/contact-request", {"canonicalName": canonicalName});
  }

  Future<void> cancelContactRequest(String canonicalName) async {
    await _httpClient
        .deleteRequest("/api/users/contact-request/" + canonicalName);
  }
}
