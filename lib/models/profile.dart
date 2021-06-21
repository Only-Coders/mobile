import 'package:mobile/models/country.dart';
import 'package:mobile/models/git_platform.dart';
import 'package:mobile/models/work_position.dart';

class Profile {
  final String email;
  final String canonicalName;
  final String firstName;
  final String lastName;
  final String imageURI;
  final String description;
  final WorkPosition currentPosition;
  final int medalQty;
  final int followerQty;
  final int contactQty;
  final int followingQty;
  final int postQty;
  final bool pendingRequest;
  final bool requestHasBeenSent;
  final bool following;
  final bool connected;
  final GitPlatform gitProfile;
  final Country country;
  final String birthDate;

  Profile({
    this.email,
    this.canonicalName,
    this.firstName,
    this.lastName,
    this.imageURI,
    this.description,
    this.currentPosition,
    this.medalQty,
    this.followerQty,
    this.contactQty,
    this.followingQty,
    this.postQty,
    this.pendingRequest,
    this.requestHasBeenSent,
    this.following,
    this.connected,
    this.gitProfile,
    this.country,
    this.birthDate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json["email"],
      canonicalName: json["canonicalName"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      imageURI: json["imageURI"],
      description: json["description"],
      currentPosition: json['currentPosition'] != null
          ? new WorkPosition.fromJson(json['currentPosition'])
          : null,
      medalQty: json["medalQty"],
      followerQty: json["followerQty"],
      contactQty: json["contactQty"],
      followingQty: json["followingQty"],
      postQty: json["postQty"],
      pendingRequest: json["pendingRequest"],
      requestHasBeenSent: json["requestHasBeenSent"],
      following: json["following"],
      connected: json["connected"],
      gitProfile: json['gitProfile'] != null
          ? new GitPlatform.fromJson(json['gitProfile'])
          : null,
      country: json['country'] != null
          ? new Country.fromJson(json['country'])
          : null,
      birthDate: json["birthDate"],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'canonicalName': canonicalName,
        'firstName': firstName,
        'lastName': lastName,
        'imageURI': imageURI,
        'description': description,
        'currentPosition':
            currentPosition != null ? currentPosition.toJson() : null,
        'medalQty': medalQty,
        'followerQty': followerQty,
        'contactQty': contactQty,
        'followingQty': followingQty,
        'postQty': postQty,
        'pendingRequest': pendingRequest,
        'requestHasBeenSent': requestHasBeenSent,
        'following': following,
        'connected': connected,
        'gitProfile': gitProfile != null ? gitProfile.toJson() : null,
        'country': country != null ? country.toJson() : null,
        "birthDate": birthDate
      };
}
