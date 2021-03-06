import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  final refreshFeed;
  final User user;

  const BottomNav({Key key, this.refreshFeed, this.user}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
              Navigator.pushNamed(context, "/new-post")
                  .then((value) => widget.refreshFeed());
              break;
            case 2:
              Navigator.pushNamed(context, "/notifications");
              break;
            default:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    canonicalName: widget.user.canonicalName,
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
            label: t.publish,
            icon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            label: t.notifications,
            icon: StreamBuilder<Event>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("notifications/${widget.user.canonicalName}")
                    .orderByChild("read")
                    .equalTo(false)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map data = snapshot.data.snapshot.value;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Icon(Icons.notifications),
                        if (data != null)
                          Positioned(
                            right: -3,
                            top: -3,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                "${data.length}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    );
                  }
                  return Icon(Icons.notifications);
                }),
          ),
          BottomNavigationBarItem(
            label: t.profile,
            icon: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Icon(Icons.person),
                if (Provider.of<User>(context).eliminationDate != null)
                  Positioned(
                    right: -3,
                    top: -3,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        "!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
