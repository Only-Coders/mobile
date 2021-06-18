class Country {
  final String name;
  final String code;

  Country({this.name, this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
      };
}
