class User {
  String email;
  String imageURI;
  String canonicalName;
  bool defaultPrivacy;
  String roles;
  String fullName;
  bool complete;

  void setUser(Map<String, dynamic> json) {
    email = json["sub"];
    canonicalName = json["canonicalName"];
    imageURI = json["imageURI"];
    defaultPrivacy = json["defaultPrivacy"];
    roles = json["roles"];
    fullName = json["fullName"];
    complete = json["complete"];
  }
}
