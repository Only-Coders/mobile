import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  MessagingService(this._messaging);

  Future<void> registerNotification() async {
    await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Got a message in the background");
  }
}
