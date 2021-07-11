import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/chat/chat_input.dart';
import 'package:mobile/components/chat/chat_message.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/models/message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessages extends StatefulWidget {
  final String chatKey;
  final String chatFrom;
  final String chatFromCanonicalName;
  final String chatFromImg;
  final Chat chat;

  const ChatMessages({
    Key key,
    @required this.chatKey,
    @required this.chatFrom,
    @required this.chatFromImg,
    @required this.chatFromCanonicalName,
    @required this.chat,
  }) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  String chatKey;

  void updateKey(String newKey) {
    setState(() {
      chatKey = newKey;
    });
  }

  @override
  void initState() {
    setState(() {
      chatKey = widget.chatKey;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

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
                backgroundImage: NetworkImage(widget.chatFromImg),
              ),
            ),
          ],
        ),
        title: Text(
          widget.chatFrom,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatKey != null
                ? StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .reference()
                        .child("chats/$chatKey/messages")
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.of(context).size.width - 8,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      List<Message> messages = [];
                      Event messagesEvent = snapshot.data;
                      Map messagesSnapshot = messagesEvent.snapshot.value;
                      messagesSnapshot.forEach((messageKey, messageValue) {
                        Map<String, dynamic> messageJson =
                            Map<String, dynamic>.from(messageValue);
                        messages.add(Message.fromJson(messageJson));
                      });

                      if (messages.isEmpty) {
                        return NoData(
                          message: t.noMessages,
                          img: "assets/images/no-messages.png",
                        );
                      } else {
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
                      }
                    },
                  )
                : NoData(
                    message: t.noMessages,
                    img: "assets/images/no-messages.png",
                  ),
          ),
          ChatInput(
            chatKey: chatKey,
            to: widget.chatFromCanonicalName,
            chat: widget.chat,
            updateKey: updateKey,
          )
        ],
      ),
    );
  }
}
