import 'package:mobile/http_client.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/models/profile.dart';

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

  Future<void> sendContactRequest(String canonicalName) async {
    await _httpClient.postRequest(
        "/api/users/contact-request", {"canonicalName": canonicalName});
  }

  Future<void> cancelContactRequest(String canonicalName) async {
    await _httpClient
        .deleteRequest("/api/users/contact-request/" + canonicalName);
  }

  Future<List<Person>> getPersonsByFullName([String name]) async {
    var response = await _httpClient
        .getRequest("/api/users", {"partialName": name, "size": 3});
    return (response.data["content"] as List)
        .map((person) => Person.fromJson(person))
        .toList();
  }

  Future<Profile> getPersonProfile(String canonicalName) async {
    var response = await _httpClient.getRequest("/api/users/" + canonicalName);
    return Profile.fromJson(response.data);
  }

  Future<List<Person>> searchPerson(String partialName) async {
    var response = await _httpClient
        .getRequest("/api/users", {"partialName": partialName, "size": 4});
    return (response.data["content"] as List)
        .map((person) => Person.fromJson(person))
        .toList();
  }
}
