class Work {
  final String name;
  final String id;
  final String position;
  final String since;
  final String until;

  Work({this.name, this.id, this.position, this.since, this.until});

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      name: json['name'],
      id: json['id'],
      position: json['position'],
      since: json['since'],
      until: json['until'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'position': position,
        'since': since,
        'until': until,
      };
}
