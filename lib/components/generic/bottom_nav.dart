import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: t.home,
            icon: Icon(Icons.home),
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
