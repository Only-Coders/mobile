import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInput extends StatefulWidget {
  final updateKey;
  final String chatKey;
  final String to;
  final Chat chat;

  const ChatInput({
    Key key,
    @required this.chatKey,
    @required this.to,
    @required this.chat,
    @required this.updateKey,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  String message = "";

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: null,
            splashRadius: 20,
            icon: Icon(
              Icons.image,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                maxLines: null,
                controller: _textController,
                onChanged: (val) {
                  setState(() {
                    message = val;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: t.typeAMessage,
                  filled: true,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (message.isNotEmpty) {
                Map<String, dynamic> newMessage = {
                  "text": message,
                  "time": ServerValue.timestamp,
                  "from": context.read<User>().canonicalName,
                  "read": false
                };
                if (widget.chatKey != null) {
                  await FirebaseDatabase.instance
                      .reference()
                      .child("chats/${widget.chatKey}/messages")
                      .push()
                      .set(newMessage);
                  await FirebaseDatabase.instance
                      .reference()
                      .child("chats/${widget.chatKey}/lastMessage")
                      .update(newMessage);
                  _textController.text = "";
                  setState(() {
                    message = "";
                  });
                } else {
                  DatabaseReference newChatRef = FirebaseDatabase.instance
                      .reference()
                      .child("chats")
                      .push();
                  Map<String, dynamic> newChat = {
                    "toCanonicalName": widget.chat.toCanonicalName,
                    "to": widget.chat.to,
                    "from": widget.chat.from,
                    "fromImageURI": widget.chat.fromImageURI,
                    "toImageURI": widget.chat.toImageURI,
                    "key": newChatRef.key,
                    "lastMessage": newMessage
                  };
                  await FirebaseDatabase.instance
                      .reference()
                      .child("chats/${newChatRef.key}")
                      .update(newChat);
                  await FirebaseDatabase.instance
                      .reference()
                      .child("chats/${newChatRef.key}/messages")
                      .push()
                      .set(newMessage);
                  await FirebaseDatabase.instance
                      .reference()
                      .child("users/${widget.to}/chats")
                      .push()
                      .set({"key": newChatRef.key});
                  await FirebaseDatabase.instance
                      .reference()
                      .child(
                          "users/${context.read<User>().canonicalName}/chats")
                      .push()
                      .set({"key": newChatRef.key});
                  widget.updateKey(newChatRef.key);
                  _textController.text = "";
                  setState(() {
                    message = "";
                  });
                }
              }
            },
            splashRadius: 20,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
