import 'package:flutter/material.dart';
import 'package:mobile/components/auth_form.dart';
import 'package:mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService(FirebaseAuth.instance);
  final _toast = Toast();

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await _auth.login(email, password);
      Navigator.pushNamed(context, "/onboard");
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
