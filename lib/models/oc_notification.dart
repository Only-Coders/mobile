class OCNotification {
  final String id;
  final String type;
  final bool email;
  final bool push;

  OCNotification({
    this.id,
    this.type,
    this.email,
    this.push,
  });

  factory OCNotification.fromJson(Map<String, dynamic> json) {
    return OCNotification(
      id: json['id'],
      type: json['type'],
      email: json['email'],
      push: json['push'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'email': email,
        'push': push,
      };
}
