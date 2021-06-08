import 'package:mobile/models/work_position.dart';

class Person {
  final String canonicalName;
  final String firstName;
  final String lastName;
  final String imageURI;
  final int amountOfMedals;
  final WorkPosition currentPosition;

  Person(
      {this.canonicalName,
      this.firstName,
      this.lastName,
      this.imageURI,
      this.amountOfMedals,
      this.currentPosition});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      canonicalName: json['canonicalName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageURI: json['imageURI'],
      amountOfMedals: json['amountOfMedals'],
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
        'amountOfMedals': amountOfMedals,
        'currentPosition':
            currentPosition != null ? currentPosition.toJson() : null,
      };
}
