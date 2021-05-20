class Skill {
  final String name;
  final String canonicalName;

  Skill({this.name, this.canonicalName});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      canonicalName: json['canonicalName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'canonicalName': canonicalName,
      };
}
