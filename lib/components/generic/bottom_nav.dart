import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor.withOpacity(0.6),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          switch (value) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, "/new-post");
              break;
            case 2:
              Navigator.pushNamed(context, "/new-post");
              break;
            default:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    canonicalName: Provider.of<User>(context).canonicalName,
                  ),
                ),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            label: t.home,
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: t.newPost,
            icon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            label: t.notifications,
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: t.profile,
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
