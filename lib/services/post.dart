import 'package:mobile/http_client.dart';
import 'package:mobile/models/post.dart';

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

  Future<List<Post>> getFeedPosts() async {
    var response = await _httpClient.getRequest("/api/feed-posts");
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }

  Future<List<Post>> getPostsByUser(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/posts/user/" + canonicalName);
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }
}
