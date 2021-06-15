class FBNotification {
  final String eventType;
  final String message;
  final bool read;
  final String to;
  final String from;
  final String key;
  final String imageURI;

  FBNotification(
      {this.eventType,
      this.message,
      this.read,
      this.to,
      this.key,
      this.imageURI,
      this.from});

  factory FBNotification.fromJson(Map<String, dynamic> json) {
    return FBNotification(
      eventType: json['eventType'],
      message: json['message'],
      read: json['read'],
      to: json['to'],
      from: json['from'],
      key: json['key'],
      imageURI: json['imageURI'],
    );
  }

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'message': message,
        'read': read,
        'to': to,
        'from': from,
        'key': key,
        'imageURI': imageURI,
      };
}
