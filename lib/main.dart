import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/http_client.dart';
import 'package:mobile/navigation.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/auth/forgot_password.dart';
import 'package:mobile/screens/auth/login.dart';
import 'package:mobile/screens/auth/wrapper.dart';
import 'package:mobile/screens/feed/feed.dart';
import 'package:mobile/screens/notifications/notifications.dart';
import 'package:mobile/screens/onboard/onboard.dart';
import 'package:mobile/screens/auth/register.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/screens/post/new_post.dart';
import 'package:mobile/screens/post/profile_posts.dart';
import 'package:mobile/screens/profile/favorite_posts.dart';
import 'package:mobile/screens/profile/my_contacts.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/screens/tags/tag_posts.dart';
import 'package:mobile/services/fb_messaging.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> saveDeviceToken(String token) async {
  final HttpClient _httpClient = HttpClient();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String id = "";
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    id = androidInfo.id;
  } else {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    id = iosDeviceInfo.identifierForVendor;
  }
  await _httpClient
      .postRequest("/api/users/fcm-token", {"fcmToken": token, "deviceId": id});
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Got a message in the background");
  print("Message: ${message.data}");
}

void deviceTokenListener() async {
  String token = await FirebaseMessaging.instance.getToken();
  await saveDeviceToken(token);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveDeviceToken);
}

Future<void> registerPushNotifications() async {
  MessagingService _messagingService =
      MessagingService(FirebaseMessaging.instance);
  await _messagingService.registerNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<User> loadPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentTheme.loadTheme(
      prefs.getBool("isDark") == null ? false : prefs.getBool("isDark"));
  return User(prefs.getString("user"));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User user = await loadPrefs();
  await registerPushNotifications();
  runApp(App(
    user: user,
  ));
}

class App extends StatefulWidget {
  final User user;

  const App({Key key, this.user}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    deviceTokenListener();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => widget.user,
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
          "/forgot-password": (context) => ForgotPassword(),
          "/onboard": (context) => Onboard(),
          "/new-post": (context) => NewPost(),
          "/profile": (context) => Profile(),
          "/notifications": (context) => Notifications(),
          "/profile/posts": (context) => ProfilePosts(),
          "/profile/favorites": (context) => FavoritePosts(),
          "/profile/contacts": (context) => MyContacts(),
          "/tag/posts": (context) => TagPosts()
        },
      ),
    );
  }
}
