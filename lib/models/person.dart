import 'package:mobile/models/work_position.dart';

class Contact {
  final String canonicalName;
  final String firstName;
  final String lastName;
  final String imageURI;
  final WorkPosition currentPosition;

  Contact(
      {this.canonicalName,
      this.firstName,
      this.lastName,
      this.imageURI,
      this.currentPosition});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      canonicalName: json['canonicalName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageURI: json['imageURI'],
      currentPosition: json['currentPosition'] != null
          ? new WorkPosition.fromJson(json['currentPosition'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'canonicalName': canonicalName,
        'firstName': firstName,
        'lastName': lastName,
        'imageURI': imageURI,
        'currentPosition':
            currentPosition != null ? currentPosition.toJson() : null,
      };
}
