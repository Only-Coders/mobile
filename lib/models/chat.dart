import 'package:mobile/models/message.dart';

class Chat {
  final String to;
  final String from;
  final String key;
  final String toCanonicalName;
  final String toImageURI;
  final String fromImageURI;
  final Message lastMessage;

  Chat(
      {this.to,
      this.from,
      this.key,
      this.toCanonicalName,
      this.toImageURI,
      this.fromImageURI,
      this.lastMessage});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      to: json['to'],
      from: json['from'],
      key: json['key'],
      toCanonicalName: json['toCanonicalName'],
      toImageURI: json['toImageURI'],
      fromImageURI: json['fromImageURI'],
      lastMessage: json['lastMessage'] != null
          ? new Message.fromJson(json['lastMessage'])
          : null,
    );
  }
}
