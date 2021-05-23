import 'package:flutter/material.dart';
import 'package:mobile/screens/auth/login.dart';
import 'package:mobile/screens/feed/feed.dart';
import 'package:mobile/screens/onboard/onboard.dart';
import 'package:mobile/screens/auth/register.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("es"),
      ],
      theme: ThemeData(
        primaryColor: Color(0xff00CDAE),
        secondaryHeaderColor: Color(0xff34374B),
        errorColor: Color(0xffff5252),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/feed": (context) => Feed(),
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/onboard": (context) => Onboard()
      },
      home: Feed(),
    );
  }
}
