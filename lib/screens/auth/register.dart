import 'package:flutter/material.dart';
import 'package:mobile/components/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/services/fb_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/theme/themes.dart';

class Register extends StatelessWidget {
  final _auth = FBAuthService(FirebaseAuth.instance);
  final _toast = Toast();

  Future<void> register(
      BuildContext context, String email, String password) async {
    try {
      await _auth.register(email, password);
      _toast.showSuccess(
          context, AppLocalizations.of(context).emailVerificationMessage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _toast.showError(context, AppLocalizations.of(context).weakPassword);
      } else if (e.code == 'email-already-in-use') {
        _toast.showError(
            context, AppLocalizations.of(context).emailAlreadyInUse);
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
                    t.register,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                SizedBox(
                    height:
                        currentTheme.currentTheme == ThemeMode.dark ? 20 : 60),
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
                        currentTheme.currentTheme == ThemeMode.dark ? 20 : 60),
                AuthForm(
                  buttonText: t.register,
                  action: register,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.alreadyHaveAnAccount,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        t.login,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
