import 'package:mobile/models/workplace.dart';

class WorkPosition {
  final String id;
  final Workplace workplace;
  final String position;
  final String since;
  final String until;

  WorkPosition(
      {this.id, this.workplace, this.position, this.since, this.until});

  factory WorkPosition.fromJson(Map<String, dynamic> json) {
    return WorkPosition(
      id: json['id'],
      workplace: json['workplace'] != null
          ? new Workplace.fromJson(json['workplace'])
          : null,
      position: json['position'],
      since: json['since'],
      until: json['until'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': workplace != null ? workplace.toJson()["id"] : null,
        'name': workplace != null ? workplace.toJson()["name"] : null,
        'position': position,
        'since': since,
        'until': until,
      };
}
