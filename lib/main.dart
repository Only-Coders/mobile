import 'package:flutter/material.dart';
import 'package:mobile/navigation.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/auth/login.dart';
import 'package:mobile/screens/auth/wrapper.dart';
import 'package:mobile/screens/feed/feed.dart';
import 'package:mobile/screens/onboard/onboard.dart';
import 'package:mobile/screens/auth/register.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/screens/post/new_post.dart';
import 'package:mobile/screens/post/profile_posts.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentTheme.loadTheme(
      prefs.getBool("isDark") == null ? false : prefs.getBool("isDark"));
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    currentTheme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => User(),
      child: MaterialApp(
        navigatorKey: NavigationService.instance.navigationKey,
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
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => Wrapper(),
          "/feed": (context) => Feed(),
          "/login": (context) => Login(),
          "/register": (context) => Register(),
          "/onboard": (context) => Onboard(),
          "/new-post": (context) => NewPost(),
          "/profile": (context) => Profile(),
          "/profile/posts": (context) => ProfilePosts()
        },
      ),
    );
  }
}
