import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String email;
  String imageURI;
  String canonicalName;
  bool defaultPrivacy;
  String roles;
  String fullName;
  bool complete;
  int eliminationDate;
  String githubUser;
  String language = "es";

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
      this.githubUser = "";
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

  Future<void> setLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", lang);
    language = lang;
    notifyListeners();
  }

  void setDefaultPrivacy(bool defaultPrivacy) {
    this.defaultPrivacy = defaultPrivacy;
  }

  void setGithubUser(Map<String, dynamic> githubInfo) {
    githubUser = githubInfo["githubUser"];
    fullName = githubInfo["displayName"];
    imageURI = githubInfo["photoURL"];
  }

  void setGoogleUser(Map<String, dynamic> googleInfo) {
    fullName = googleInfo["displayName"];
    imageURI = googleInfo["photoURL"];
  }

  void setEliminationDate(int eliminationDate) {
    this.eliminationDate = eliminationDate;
    notifyListeners();
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
