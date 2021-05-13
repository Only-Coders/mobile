import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/onboard/onboard.dart';
import 'package:mobile/screens/register.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Only Coders',
      theme: ThemeData(
        primaryColor: Color(0xff00CDAE),
        secondaryHeaderColor: Color(0xff34374B),
        errorColor: Color(0xffff5252),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/onboard": (context) => Onboard()
      },
      home: Login(),
    );
  }
}
