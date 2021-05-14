import 'package:flutter/material.dart';
import 'package:mobile/components/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/toast.dart';
import 'package:mobile/services/fb_auth.dart';
import 'package:mobile/services/auth.dart';

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
      await _auth.login(fbToken);
      Navigator.pushReplacementNamed(context, "/onboard");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _toast.showError(context, "No se encontro un usuario con ese correo");
      } else if (e.code == 'wrong-password') {
        _toast.showError(context, "Credenciales incorrectas");
      }
    } catch (e) {
      print(e);
      _toast.showError(context, "Uh algo salio mal :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Iniciar Sesion",
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
                  buttonText: "Iniciar Sesion",
                  action: login,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Aún no tienes cuenta?"),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "Regístrate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
