import 'package:mobile/http_client.dart';
import 'package:mobile/models/contact.dart';

class ContactService {
  final HttpClient _httpClient = HttpClient();

  ContactService();

  Future<List<Contact>> getContacts() async {
    var response = await _httpClient.getRequest("/api/suggested-users");
    return (response.data as List).map((c) => Contact.fromJson(c)).toList();
  }

  Future<void> followContact(String canonicalName) async {
    await _httpClient.postRequest("/api/users/following/" + canonicalName, {});
  }

  Future<void> unfollowContact(String canonicalName) async {
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
}
