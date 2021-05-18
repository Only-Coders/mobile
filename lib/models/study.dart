class Study {
  final String name;
  final String id;
  final String degree;
  final String since;
  final String until;

  Study({this.name, this.id, this.degree, this.since, this.until});

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      name: json['name'],
      id: json['id'],
      degree: json['degree'],
      since: json['since'],
      until: json['until'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'degree': degree,
        'since': since,
        'until': until,
      };
}
