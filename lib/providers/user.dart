import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String email;
  String imageURI;
  String canonicalName;
  bool defaultPrivacy;
  String roles;
  String fullName;
  bool complete;
  int eliminationDate;

  User(String user) {
    if (user != null && user.isNotEmpty) {
      User u = User.fromJson(json.decode(user));
      this.email = u.email;
      this.imageURI = u.imageURI;
      this.canonicalName = u.canonicalName;
      this.defaultPrivacy = u.defaultPrivacy;
      this.roles = u.roles;
      this.fullName = u.fullName;
      this.complete = u.complete;
      this.eliminationDate = u.eliminationDate;
    }
  }

  void setUser(Map<String, dynamic> json) {
    email = json["sub"];
    canonicalName = json["canonicalName"];
    imageURI = json["imageURI"];
    defaultPrivacy = json["defaultPrivacy"];
    roles = json["roles"];
    fullName = json["fullName"];
    complete = json["complete"];
    eliminationDate = json["eliminationDate"];
  }

  Future<void> saveUserOnPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", json.encode(this.toJson()));
  }

  void setDefaultPrivacy(bool defaultPrivacy) {
    this.defaultPrivacy = defaultPrivacy;
  }

  void setEliminationDate(int eliminationDate) {
    this.eliminationDate = eliminationDate;
  }

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        imageURI = json['imageURI'],
        canonicalName = json['canonicalName'],
        defaultPrivacy = json['defaultPrivacy'],
        roles = json['roles'],
        fullName = json['fullName'],
        complete = json['complete'],
        eliminationDate = json['eliminationDate'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'imageURI': imageURI,
        'canonicalName': canonicalName,
        'defaultPrivacy': defaultPrivacy,
        'roles': roles,
        'fullName': fullName,
        'complete': complete,
        'eliminationDate': eliminationDate,
      };
}
