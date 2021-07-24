import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const bucket =
      "https://storage.googleapis.com/onlycoders-cc609.appspot.com/";
  static var clientId = dotenv.env["CLIENT_ID"];
  static var clientSecret = dotenv.env["CLIENT_SECRET"];
}
