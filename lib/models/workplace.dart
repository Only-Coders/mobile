class Workplace {
  final String id;
  final String name;

  Workplace({this.id, this.name});

  factory Workplace.fromJson(Map<String, dynamic> json) {
    return Workplace(
      id: json['id'],
      name: json['name'],
    );
  }
}
