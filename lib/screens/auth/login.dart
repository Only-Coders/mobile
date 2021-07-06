import 'package:flutter/material.dart';
import 'package:mobile/components/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/providers/user.dart' as UserData;
import 'package:mobile/services/fb_auth.dart';
import 'package:mobile/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobile/storage.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _fbAuth = FBAuthService(FirebaseAuth.instance);
  final _auth = AuthService();
  final _toast = Toast();

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      String fbToken = await _fbAuth.login(email, password);
      String token = await _auth.login(fbToken);
      var payload = Jwt.parseJwt(token);
      if (payload["complete"] != null) {
        Provider.of<UserData.User>(context, listen: false).setUser(payload);
        await Provider.of<UserData.User>(context, listen: false)
            .saveUserOnPrefs();
        Navigator.pushNamedAndRemoveUntil(context, "/feed", (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/onboard", (_) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _toast.showError(context, AppLocalizations.of(context).userNotFound);
      } else if (e.code == 'wrong-password') {
        _toast.showError(
            context, AppLocalizations.of(context).credentialsError);
      }
    } catch (e) {
      _toast.showError(context, AppLocalizations.of(context).serverError);
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      UserCredential credentials = await _fbAuth.signInWithGoogle();
      String fbToken = await credentials.user.getIdToken();
      String token = await _auth.login(fbToken);
      var payload = Jwt.parseJwt(token);
      if (payload["complete"] != null) {
        Provider.of<UserData.User>(context, listen: false).setUser(payload);
        await Provider.of<UserData.User>(context, listen: false)
            .saveUserOnPrefs();
        Navigator.pushNamedAndRemoveUntil(context, "/feed", (_) => false);
      } else {
        context.read<UserData.User>().setGoogleUser({
          "displayName": credentials.user.displayName,
          "photoURL": credentials.user.photoURL
        });
        Navigator.pushNamedAndRemoveUntil(context, "/onboard", (_) => false);
      }
    } catch (e) {
      _toast.showError(context, AppLocalizations.of(context).serverError);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    t.login,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                SizedBox(
                    height:
                        currentTheme.currentTheme == ThemeMode.dark ? 10 : 50),
                Center(
                  child: currentTheme.currentTheme != ThemeMode.dark
                      ? Image.asset(
                          'assets/images/logo.png',
                          width: 160,
                        )
                      : Image.asset(
                          "assets/images/dark-logo.png",
                          width: 240,
                        ),
                ),
                SizedBox(
                    height:
                        currentTheme.currentTheme == ThemeMode.dark ? 10 : 50),
                AuthForm(
                  buttonText: t.login,
                  action: login,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.dontHaveAnAccount,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        t.register,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async => loginWithGoogle(context),
                  child: Image.asset(
                    "assets/images/google.png",
                    width: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
