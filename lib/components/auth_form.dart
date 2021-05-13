import "package:flutter/material.dart";

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
  String password = "";
  String email = "";
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
                    : "Ingresa un correo valido";
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelText: "Correo electronico",
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
                    : "Ingresa una contraseña mas segura";
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelText: "Contraseña",
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
