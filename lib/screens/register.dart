import 'package:flutter/material.dart';
import 'package:mobile/components/auth_form.dart';
import 'package:mobile/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/components/toast.dart';

class Register extends StatelessWidget {
  final _auth = AuthService(FirebaseAuth.instance);
  final _toast = Toast();

  Future<void> register(
      BuildContext context, String email, String password) async {
    try {
      await _auth.register(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _toast.showError(context, "La contrasena debe ser mas segura");
      } else if (e.code == 'email-already-in-use') {
        _toast.showError(context, "Ya existe una cuenta con ese correo");
      }
    } catch (e) {
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
                    "Registrarse",
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
                  buttonText: "Registrarse",
                  action: register,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿Ya tienes cuenta?"),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        "Inicia Sesion",
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
