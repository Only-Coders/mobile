import 'package:dio/dio.dart';
import 'package:mobile/models/link.dart';

class LinkPreviewService {
  Dio _dio = Dio();

  LinkPreviewService();

  Future<Link> previewLink(String url) async {
    var response =
        await _dio.post("https://api-dev.onlycoders.tech", data: {"url": url});
    return Link.fromJson(response.data);
  }
}
