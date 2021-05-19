import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef ActionCallback = Future<void> Function(
    BuildContext context, String email, String password);

class AuthForm extends StatefulWidget {
  final String buttonText;
  final ActionCallback action;

  const AuthForm({Key key, this.buttonText, this.action}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  String password = "";
  String email = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
              validator: (val) {
                return emailRegex.hasMatch(val)
                    ? null
                    : AppLocalizations.of(context).invalidEmail;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelText: AppLocalizations.of(context).email,
                prefixIcon: Icon(Icons.email),
                filled: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
              validator: (val) {
                return val.length > 6
                    ? null
                    : AppLocalizations.of(context).login != widget.buttonText
                        ? AppLocalizations.of(context).weakPassword
                        : null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelText: AppLocalizations.of(context).password,
                prefixIcon: Icon(Icons.lock),
                filled: true,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate() && !isLoading) {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.action(context, email, password);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading
                    ? SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          valueColor:
                              AlwaysStoppedAnimation(Colors.grey.shade200),
                          strokeWidth: 3,
                        ),
                      )
                    : Text(widget.buttonText),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 18),
                  primary: Theme.of(context).primaryColor, // background
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
