import 'package:flutter/material.dart';
import 'package:mobile/components/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/services/fb_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatelessWidget {
  final _auth = FBAuthService(FirebaseAuth.instance);
  final _toast = Toast();

  Future<void> register(
      BuildContext context, String email, String password) async {
    try {
      await _auth.register(email, password);
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
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
                    Text(t.alreadyHaveAnAccount),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        t.login,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
