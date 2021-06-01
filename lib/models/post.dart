import 'package:mobile/models/person.dart';
import 'package:mobile/models/reaction.dart';

class Post {
  String message;
  Person publisher;
  String url;
  bool isPublic;
  String type;
  List<Person> mentions;
  List<Reaction> reactions;
  int commentQuantity;

  Post(
      {this.message,
      this.publisher,
      this.url,
      this.isPublic,
      this.type,
      this.mentions,
      this.reactions,
      this.commentQuantity});

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
      commentQuantity: json['commentQuantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'publisher': publisher != null ? publisher.toJson() : null,
        'url': url,
        'isPublic': isPublic,
        'type': type,
        'mentions': mentions,
        'commentQuantity': commentQuantity
      };
}
