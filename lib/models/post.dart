import 'package:mobile/models/person.dart';
import 'package:mobile/models/reaction.dart';

class Post {
  String message;
  String id;
  Person publisher;
  String url;
  bool isPublic;
  String type;
  List<Person> mentions;
  List<Reaction> reactions;
  int commentQuantity;
  bool isFavorite;

  Post(
      {this.message,
      this.publisher,
      this.url,
      this.id,
      this.isPublic,
      this.type,
      this.mentions,
      this.reactions,
      this.commentQuantity,
      this.isFavorite});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      message: json["message"],
      publisher: json['publisher'] != null
          ? new Person.fromJson(json['publisher'])
          : null,
      url: json['url'],
      isPublic: json['isPublic'],
      type: json['type'],
      reactions: (json['reactions'] as List<dynamic>)
          .map((reaction) => Reaction.fromJson(reaction))
          .toList(),
      mentions: (json['mentions'] as List<dynamic>)
          .map((mention) => Person.fromJson(mention))
          .toList(),
      commentQuantity: json['commentQuantity'],
      isFavorite: json['isFavorite'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'publisher': publisher != null ? publisher.toJson() : null,
        'url': url,
        'isPublic': isPublic,
        'type': type,
        'commentQuantity': commentQuantity,
        'isFavorite': isFavorite,
        'id': id
      };
}
