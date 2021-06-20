import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile/models/chat.dart';

class ChatService {
  final fb = FirebaseDatabase.instance;

  ChatService();

  Future<StreamSubscription<Event>> getUserChats(String userCanonical) async {
    DatabaseReference usersRef =
        fb.reference().child("users/$userCanonical/chats");
    return usersRef.onValue.listen((userEvent) {
      Map userSnapshot = userEvent.snapshot.value;
      if (userSnapshot != null) {
        userSnapshot.forEach((userKey, userData) {
          DatabaseReference chatsRef =
              fb.reference().child("chats/${userData['key']}");
          chatsRef.onValue.listen((chatEvent) {
            Map chatSnapshot = chatEvent.snapshot.value;
            if (chatSnapshot != null) {
              Chat chat = Chat.fromJson({
                "toImageURI": chatSnapshot["toImageURI"],
                "fromImageURI": chatSnapshot["fromImageURI"],
                "lastMessage": {
                  "read": chatSnapshot["lastMessage"]["read"],
                  "from": chatSnapshot["lastMessage"]["from"],
                  "text": chatSnapshot["lastMessage"]["text"],
                  "time": chatSnapshot["lastMessage"]["time"],
                },
                "to": chatSnapshot["to"],
                "from": chatSnapshot["from"],
                "toCanonicalName": chatSnapshot["toCanonicalName"],
                "key": chatSnapshot["key"],
              });
              print(chat);
            }
          });
        });
      }
    });
  }
}
