import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/chat/chat_messages.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatefulWidget {
  final User user;

  const ChatsList({Key key, @required this.user}) : super(key: key);

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  DatabaseReference usersRef;

  @override
  void initState() {
    setState(() {
      usersRef =
          db.reference().child("users/${widget.user.canonicalName}/chats");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Container(
          height: 44,
          child: TextField(
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              fillColor: currentTheme.currentTheme == ThemeMode.dark
                  ? Theme.of(context).cardColor.withOpacity(0.4)
                  : Theme.of(context).cardColor.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              labelText: "Search contacts...",
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              filled: true,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: usersRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Event userEvent = snapshot.data;
              Map userSnapshot = userEvent.snapshot.value;
              List<String> chatKeys = [];
              List<Chat> chats = [];
              userSnapshot.forEach((userKey, userValue) {
                chatKeys.add(userValue['key']);
              });
              return ListView.separated(
                itemCount: chatKeys.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: db
                        .reference()
                        .child("chats/${chatKeys[index]}")
                        .onValue,
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.hasData) {
                        Event chatEvent = chatSnapshot.data;
                        Map<String, dynamic> chatJson =
                            Map<String, dynamic>.from(chatEvent.snapshot.value);
                        chatJson["lastMessage"] =
                            Map<String, dynamic>.from(chatJson["lastMessage"]);
                        Chat chat = Chat.fromJson(chatJson);
                        String myCanonicalName =
                            context.read<User>().canonicalName;
                        return ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatMessages(
                                chatKey: chat.key,
                                chatFrom: chat.toCanonicalName ==
                                        context.read<User>().canonicalName
                                    ? chat.from
                                    : chat.to,
                                chatFromImg: chat.toCanonicalName ==
                                        context.read<User>().canonicalName
                                    ? chat.fromImageURI
                                    : chat.toImageURI,
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                myCanonicalName == chat.toCanonicalName
                                    ? NetworkImage(chat.fromImageURI)
                                    : chat.toImageURI.isNotEmpty
                                        ? NetworkImage(chat.toImageURI)
                                        : AssetImage(
                                            'assets/images/default-avatar.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(myCanonicalName == chat.toCanonicalName
                              ? chat.from
                              : chat.to),
                          subtitle: Text(chat.lastMessage != null
                              ? chat.lastMessage.text
                              : "Start a conversation"),
                        );
                      }
                      return Text("");
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("ERROR");
            } else {
              return Text("LOADING");
            }
          }),
      // future builder sobre el service del chat que va a tener el on sbore la collecion de chats del usuario
      // eso va a renderizar un chat item widget
      // el chat item widget se va a poder clickear para ir hacia el chat y ahi tener otra vista
    );
  }
}
