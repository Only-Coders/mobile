import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/auth/login.dart';
import 'package:mobile/screens/feed/feed.dart';
import 'package:mobile/storage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserStorage.getToken(),
      builder: (ctx, snapshot) {
        if (snapshot.data != null) {
          Provider.of<User>(context).setUser(Jwt.parseJwt(snapshot.data));
          return Feed();
        } else {
          return Login();
        }
      },
    );
  }
}
