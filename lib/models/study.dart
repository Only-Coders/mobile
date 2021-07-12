import 'package:mobile/models/institute.dart';

class Study {
  final String id;
  final String degree;
  final String since;
  final String until;
  final Institute institute;

  Study({this.id, this.degree, this.since, this.until, this.institute});

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      institute: json['institute'] != null
          ? new Institute.fromJson(json['institute'])
          : null,
      id: json['id'],
      degree: json['degree'],
      since: json['since'],
      until: json['until'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': institute != null ? institute.name : null,
        'id': institute != null ? institute.id : null,
        'degree': degree,
        'since': since,
        'until': until,
      };
}
