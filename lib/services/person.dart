import 'package:mobile/http_client.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/models/profile.dart';
import 'package:mobile/models/skill.dart';
import 'package:mobile/models/study.dart';
import 'package:mobile/models/tag.dart';
import 'package:mobile/models/work_position.dart';

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

  Future<void> acceptContactRequest(String canonicalName) async {
    await _httpClient.putRequest("/api/users/received-contact-requests",
        {"requesterCanonicalName": canonicalName, "acceptContact": true});
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

  Future<void> updateUserPhoto(String imageURI) async {
    await _httpClient.patchRequest("/api/users/image", {"imageURI": imageURI});
  }

  Future<List<Person>> searchPerson(String partialName) async {
    var response = await _httpClient
        .getRequest("/api/users", {"partialName": partialName, "size": 4});
    return (response.data["content"] as List)
        .map((person) => Person.fromJson(person))
        .toList();
  }

  Future<List<WorkPosition>> getPersonWorks(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/users/$canonicalName/workplaces");
    return (response.data["content"] as List)
        .map((work) => WorkPosition.fromJson(work))
        .toList();
  }

  Future<List<Study>> getPersonStudies(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/users/$canonicalName/institutes");
    return (response.data["content"] as List)
        .map((study) => Study.fromJson(study))
        .toList();
  }

  Future<List<Skill>> getPersonSkills(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/users/$canonicalName/skills");
    return (response.data["content"] as List)
        .map((skill) => Skill.fromJson(skill))
        .toList();
  }

  Future<List<Tag>> getPersonTags(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/users/$canonicalName/tags");
    return (response.data["content"] as List)
        .map((tag) => Tag.fromJson(tag))
        .toList();
  }

  Future<List<Person>> getMyContacts([int page]) async {
    var response =
        await _httpClient.getRequest("/api/users/contacts", {"page": page});
    return (response.data["content"] as List)
        .map((person) => Person.fromJson(person))
        .toList();
  }

  Future<void> removeMyContact(String canonicalName) async {
    await _httpClient.deleteRequest("/api/users/contacts/$canonicalName");
  }
}
