class ReportType {
  final String id;
  final String name;

  ReportType({this.id, this.name});

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
