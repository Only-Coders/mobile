import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/theme/themes.dart';
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
                        backgroundImage:
                            user.imageURI == null || user.imageURI.isEmpty
                                ? AssetImage("assets/images/default-avatar.png")
                                : NetworkImage(user.imageURI),
                      ),
                    ),
                    Text(
                      user.fullName,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.brightness_6,
                  color: Theme.of(context).accentColor,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.theme,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.bedtime,
                          color: currentTheme.currentTheme == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey,
                        ),
                        Switch(
                          value: currentTheme.currentTheme != ThemeMode.dark,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) async {
                            await currentTheme.toggleTheme();
                          },
                        ),
                        Icon(
                          Icons.wb_sunny,
                          color: currentTheme.currentTheme == ThemeMode.dark
                              ? Colors.grey
                              : Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  t.contacts,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () =>
                    Navigator.of(context).pushNamed("/profile/contacts"),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  t.logout,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () async {
                  await _authService.logout();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
