import 'package:mobile/models/contact.dart';

class Post {
  String message;
  Contact publisher;
  String url;
  bool isPublic;
  String type;
  List<Contact> mentions;

  Post(
      {this.message,
      this.publisher,
      this.url,
      this.isPublic,
      this.type,
      this.mentions});

  factory Post.fromJson(Map<String, dynamic> json) {
    print(json['mentions']);
    return Post(
      message: json["message"],
      publisher: json['publisher'] != null
          ? new Contact.fromJson(json['publisher'])
          : null,
      url: json['url'],
      isPublic: json['isPublic'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'publisher': publisher != null ? publisher.toJson() : null,
        'url': url,
        'isPublic': isPublic,
        'type': type,
        'mentions': mentions
      };
}