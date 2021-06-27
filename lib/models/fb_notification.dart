class FBNotification {
  final String eventType;
  final String message;
  final bool read;
  final String canonicalName;
  final int createdAt;
  final String from;
  final String key;
  final String imageURI;

  FBNotification(
      {this.eventType,
      this.message,
      this.read,
      this.canonicalName,
      this.createdAt,
      this.key,
      this.imageURI,
      this.from});

  factory FBNotification.fromJson(Map<String, dynamic> json) {
    return FBNotification(
      eventType: json['eventType'],
      message: json['message'],
      read: json['read'],
      canonicalName: json['canonicalName'],
      createdAt: json['createdAt'],
      from: json['from'],
      key: json['key'],
      imageURI: json['imageURI'],
    );
  }

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'message': message,
        'read': read,
        'canonicalName': canonicalName,
        'createdAt': createdAt,
        'from': from,
        'key': key,
        'imageURI': imageURI,
      };
}
