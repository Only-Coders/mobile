import 'package:mobile/models/person.dart';

class ContactRequest {
  final String id;
  final Person requester;
  final String message;

  ContactRequest({this.id, this.requester, this.message});

  factory ContactRequest.fromJson(Map<String, dynamic> json) {
    return ContactRequest(
      id: json['id'],
      requester: json['requester'] != null
          ? new Person.fromJson(json['requester'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'requester': requester != null ? requester.toJson() : null,
        'message': message,
      };
}
