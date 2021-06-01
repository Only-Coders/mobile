import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/auth.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    var t = AppLocalizations.of(context);
    User user = Provider.of<User>(context);

    return Row(
      children: [
        Drawer(
          elevation: 0,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: user.imageURI.isEmpty
                            ? AssetImage("assets/images/default-avatar.png")
                            : NetworkImage(user.imageURI),
                      ),
                    ),
                    Text(
                      user.fullName,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(t.logout),
                onTap: _authService.logout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
