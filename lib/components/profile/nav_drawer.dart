import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/profile/cancel_delete_account.dart';
import 'package:mobile/components/profile/delete_account.dart';
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
                  Icons.settings,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  t.settings,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () =>
                    Navigator.of(context).pushNamed("/profile/settings"),
              ),
              if (user.eliminationDate == null)
                ListTile(
                  leading: Icon(
                    Icons.admin_panel_settings,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    t.removeAccount,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => DeleteAccount(),
                  ),
                ),
              if (user.eliminationDate != null)
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    t.cancelRemoveAccount,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CancelDeleteAccount(),
                  ),
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
