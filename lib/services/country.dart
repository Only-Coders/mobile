import 'package:mobile/http_client.dart';
import "package:mobile/models/country.dart";

class CountryService {
  final HttpClient _httpClient = HttpClient();

  CountryService();

  Future<List<Country>> getCountries() async {
    var response = await _httpClient.getRequest("/api/countries");
    return (response.data as List).map((c) => Country.fromJson(c)).toList();
  }
}
