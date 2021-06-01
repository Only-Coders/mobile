import 'package:mobile/http_client.dart';
import 'package:mobile/models/post.dart';

class PostService {
  final HttpClient _httpClient = HttpClient();

  PostService();

  Future<void> createPost(String message, String type, bool isPublic,
      String url, List<dynamic> mentions, List<String> tags) async {
    var post = {
      "message": message,
      "type": type,
      "isPublic": isPublic,
      "url": url,
      "mentionCanonicalNames": mentions,
      "tagNames": tags
    };
    await _httpClient.postRequest("/api/posts", post);
  }

  Future<List<Post>> getFeedPosts([int page]) async {
    var response = await _httpClient
        .getRequest("/api/feed-posts", {"page": page, "size": 10});
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }

  Future<void> addToFavorite(String postId) async {
    await _httpClient.postRequest("/api/users/favorite-posts/" + postId, {});
  }

  Future<void> removeFromFavorite(String postId) async {
    await _httpClient.deleteRequest("/api/users/favorite-posts/" + postId);
  }

  Future<List<Post>> getPostsByUser(String canonicalName) async {
    var response =
        await _httpClient.getRequest("/api/posts/user/" + canonicalName);
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }
}
