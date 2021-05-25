import 'package:mobile/http_client.dart';

class PostService {
  final HttpClient _httpClient = HttpClient();

  PostService();

  Future<void> createPost(String message, String type, bool isPublic,
      String url, List<String> mentions, List<String> tags) async {
    var post = {
      "message": message,
      "type": type,
      "isPublic": isPublic,
      "url": url,
      "mentionCanonicalNames": mentions,
      "tagNames": tags
    };
    print(post);
    var newPost = await _httpClient.postRequest("/api/posts", post);
    print(newPost);
  }
}
