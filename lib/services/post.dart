import 'package:mobile/http_client.dart';
import 'package:mobile/models/comment.dart';
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

  Future<List<Post>> getPostsByUser(String canonicalName, [int page]) async {
    var response = await _httpClient
        .getRequest("/api/posts/user/" + canonicalName, {"page": page});
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }

  Future<List<Post>> getPostsByTag(String canonicalName, [int page]) async {
    var response = await _httpClient
        .getRequest("/api/tags/$canonicalName/posts", {"page": page});
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }

  Future<List<Post>> getFavoritesPost([int page]) async {
    var response = await _httpClient
        .getRequest("/api/users/favorite-posts", {"page": page});
    return (response.data["content"] as List)
        .map((post) => Post.fromJson(post))
        .toList();
  }

  Future<void> reactToPost(String postId, String reaction) async {
    await _httpClient.postRequest(
        "/api/posts/$postId/reactions", {"reactionType": reaction});
  }

  Future<List<Comment>> getComments(String postId, [int page]) async {
    var response = await _httpClient
        .getRequest("/api/posts/$postId/comments", {"page": page});
    return (response.data["content"] as List)
        .map((comment) => Comment.fromJson(comment))
        .toList();
  }

  Future<Comment> newComment(String comment, String postId) async {
    var response = await _httpClient
        .postRequest("/api/posts/$postId/comments", {"message": comment});
    return Comment.fromJson(response.data);
  }

  Future<void> reactToComment(String commentId, String reaction) async {
    await _httpClient.postRequest(
        "/api/comments/$commentId/reactions", {"reactionType": reaction});
  }
}
