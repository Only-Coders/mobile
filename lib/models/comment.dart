import 'package:mobile/models/person.dart';
import 'package:mobile/models/reaction.dart';

class Comment {
  final String id;
  final Person publisher;
  final String message;
  final List<Reaction> reactions;
  final String myReaction;
  final String createdAt;

  Comment({
    this.id,
    this.publisher,
    this.message,
    this.reactions,
    this.myReaction,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      publisher: json['publisher'] != null
          ? new Person.fromJson(json['publisher'])
          : null,
      message: json['message'],
      reactions: (json['reactions'] as List<dynamic>)
          .map((reaction) => Reaction.fromJson(reaction))
          .toList(),
      myReaction: json['myReaction'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'publisher': publisher != null ? publisher.toJson() : null,
        'message': message,
        'myReaction': myReaction,
        'createdAt': createdAt,
      };
}
