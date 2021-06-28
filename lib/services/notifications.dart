import 'package:firebase_database/firebase_database.dart';
import 'package:mobile/models/fb_notification.dart';
import 'package:mobile/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final fb = FirebaseDatabase.instance;

  NotificationService();

  Future<List<FBNotification>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(prefs.getString("user"));
    List<FBNotification> notifications = [];
    DataSnapshot snapshot = await fb
        .reference()
        .child("notifications/${user.canonicalName}")
        .orderByChild("read")
        .equalTo(false)
        .once();
    Map data = snapshot.value;
    if (data != null) {
      data.forEach((key, value) {
        FBNotification notification = FBNotification.fromJson({
          "imageURI": value["imageURI"],
          "canonicalName": value["canonicalName"],
          "createdAt": value["createdAt"],
          "message": value["message"],
          "key": key,
          "from": value["from"],
          "eventType": value["eventType"],
          "read": value["read"],
        });
        notifications.add(notification);
      });
    }
    notifications.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return notifications;
  }
}
