import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/chat/chat_input.dart';
import 'package:mobile/components/chat/chat_message.dart';
import 'package:mobile/models/message.dart';

class ChatMessages extends StatelessWidget {
  final String chatKey;
  final String chatFrom;
  final String chatFromImg;

  const ChatMessages({
    Key key,
    @required this.chatKey,
    @required this.chatFrom,
    @required this.chatFromImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 15,
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(chatFromImg),
              ),
            ),
          ],
        ),
        title: Text(
          chatFrom,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("chats/$chatKey/messages")
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                List<Message> messages = [];
                Event messagesEvent = snapshot.data;
                Map messagesSnapshot = messagesEvent.snapshot.value;
                messagesSnapshot.forEach((messageKey, messageValue) {
                  Map<String, dynamic> messageJson =
                      Map<String, dynamic>.from(messageValue);
                  messages.add(Message.fromJson(messageJson));
                });

                return ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: ChatMessage(
                      message: messages[(messages.length - 1) - index],
                    ),
                  ),
                  itemCount: messages.length,
                );
              },
            ),
          ),
          ChatInput()
        ],
      ),
    );
  }
}
