import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/fb_notification.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  final FBNotification notification;
  final refresh;

  const NotificationItem({Key key, this.notification, this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            canonicalName: notification.canonicalName,
          ),
        ),
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundImage: notification.imageURI.isEmpty
                ? AssetImage("assets/images/default-avatar.png")
                : NetworkImage(notification.imageURI),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      title: Text(
        "${notification.from}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        "${notification.message}",
        style: TextStyle(
          color: Theme.of(context).accentColor.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
      trailing: IconButton(
        splashRadius: 20,
        onPressed: () async {
          User user = Provider.of<User>(context, listen: false);
          await FirebaseDatabase.instance
              .reference()
              .child("notifications/${user.canonicalName}/${notification.key}")
              .update({"read": true});
          refresh();
        },
        icon: Icon(Icons.close),
      ),
    );
  }
}
