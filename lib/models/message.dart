class Message {
  final String text;
  final int time;
  final String id;
  final String from;
  final bool read;

  Message({this.text, this.time, this.id, this.from, this.read});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      time: json['time'],
      id: json['id'],
      from: json['from'],
      read: json['read'],
    );
  }
}
