import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/services/fb_auth.dart';
import 'package:mobile/theme/themes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _fbAuth = FBAuthService(FirebaseAuth.instance);
  final _toast = new Toast();
  final emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = "";
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/no-data-work.png",
                    width: 140,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    t.forgotPassword,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    t.dontWorry,
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    t.sendLink,
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      controller: emailController,
                      validator: (val) {
                        return emailRegex.hasMatch(val) ? null : t.invalidEmail;
                      },
                      style: TextStyle(color: Theme.of(context).accentColor),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: t.email,
                        labelStyle: TextStyle(
                          color: Theme.of(context).accentColor.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).accentColor.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: currentTheme.currentTheme == ThemeMode.dark
                            ? Theme.of(context).cardColor
                            : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate() && !isLoading) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await _fbAuth.resetPassword(email);
                            emailController.text = "";
                            _toast.showSuccess(
                                context, t.forgotPasswordMessage);
                          } catch (error) {
                            _toast.showError(context, t.serverError);
                          } finally {
                            setState(() {
                              email = "";
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: isLoading
                          ? SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                valueColor: AlwaysStoppedAnimation(
                                    Colors.grey.shade200),
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              t.confirm,
                              style: TextStyle(color: Colors.white),
                            ),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                        primary: Theme.of(context).primaryColor, // background
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
