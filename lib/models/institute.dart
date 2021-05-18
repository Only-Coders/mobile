class Institute {
  final String id;
  final String name;

  Institute({this.id, this.name});

  factory Institute.fromJson(Map<String, dynamic> json) {
    return Institute(
      id: json['id'],
      name: json['name'],
    );
  }
}
