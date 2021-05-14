import 'package:mobile/services/auth.dart';

class RegisterModel {
  String firstName = "";
  String lastName = "";
  String birthDate = "";
  String country = "";
  String imageURI = "";
  String description = "";
  String platform = "";
  String userName = "";

  void setFirstStepData(
      String firstName, String lastName, String birthDate, String country) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.country = country;
  }

  void setSecondStepData(
      String imageURI, String description, String platform, String userName) {
    this.imageURI = imageURI;
    this.description = description;
    this.platform = platform;
    this.userName = userName;
  }

  Future<void> register() async {
    AuthService _auth = AuthService();
    await _auth.register(this);
  }
}
