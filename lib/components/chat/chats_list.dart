import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/models/message.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/chat/chat_messages.dart';
import 'package:mobile/theme/themes.dart';
import 'package:mobile/utils/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsList extends StatefulWidget {
  final List<String> chatsKeys;
  final Stream<Chat> newChatStream;

  const ChatsList(
      {Key key, @required this.chatsKeys, @required this.newChatStream})
      : super(key: key);

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Future getChats;
  List<Chat> chats = [];

  Future<void> getChatsByKeys() async {
    Iterable<Future<DataSnapshot>> futures = widget.chatsKeys.map((chatKey) {
      return FirebaseDatabase.instance
          .reference()
          .child("chats/$chatKey")
          .get();
    });
    List<DataSnapshot> snapshots = await Future.wait(futures);
    List<Chat> newChats = snapshots.map((snapshot) {
      Map<String, dynamic> chatJson = Map<String, dynamic>.from(snapshot.value);
      return Chat.fromJson({
        "to": chatJson["to"],
        "from": chatJson["from"],
        "key": chatJson["key"],
        "toCanonicalName": chatJson["toCanonicalName"],
        "toImageURI": chatJson["toImageURI"],
        "fromImageURI": chatJson["fromImageURI"],
        "lastMessage": Map<String, dynamic>.from(chatJson["lastMessage"]),
      });
    }).toList();
    setState(() {
      chats = newChats;
    });
    return newChats;
  }

  void refreshWidget() {
    setState(() {
      getChats = getChatsByKeys();
    });
  }

  @override
  void initState() {
    getChats = getChatsByKeys();
    widget.newChatStream.listen((chat) {
      setState(() {
        Chat findChat = chats.firstWhere(
            (c) =>
                c.toCanonicalName == chat.toCanonicalName &&
                c.from == chat.from,
            orElse: () => null);
        if (findChat == null) chats.insert(0, chat);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return FutureBuilder(
      future: getChats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            chats.sort((a, b) {
              if (a.lastMessage.time == 0 || b.lastMessage.time == 0) return 1;
              return b.lastMessage.time.compareTo(a.lastMessage.time);
            });

            if (chats.isEmpty)
              return NoData(
                message: t.noChats,
                img: "assets/images/no-data.png",
              );

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return StreamBuilder<Event>(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child("chats/${chats[index].key}/lastMessage")
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Message lastMessage;
                      if (snapshot.data.snapshot.value != null) {
                        Map<String, dynamic> json = Map<String, dynamic>.from(
                            snapshot.data.snapshot.value);
                        lastMessage = Message.fromJson(json);
                      }

                      return ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatMessages(
                                chat: chats[index],
                                chatKey: chats[index].key,
                                chatFrom: chats[index].toCanonicalName ==
                                        context.read<User>().canonicalName
                                    ? chats[index].from
                                    : chats[index].to,
                                chatFromImg: chats[index].toCanonicalName ==
                                        context.read<User>().canonicalName
                                    ? chats[index].fromImageURI
                                    : chats[index].toImageURI,
                                chatFromCanonicalName:
                                    chats[index].toCanonicalName),
                          ),
                        ).then((value) => refreshWidget()),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: context.read<User>().canonicalName ==
                                  chats[index].toCanonicalName
                              ? NetworkImage(chats[index].fromImageURI)
                              : chats[index].toImageURI.isNotEmpty
                                  ? NetworkImage(chats[index].toImageURI)
                                  : AssetImage(
                                      'assets/images/default-avatar.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(context.read<User>().canonicalName ==
                                chats[index].toCanonicalName
                            ? chats[index].from
                            : chats[index].to),
                        subtitle: Text(lastMessage != null
                            ? lastMessage.text
                            : "Start a conversation"),
                        trailing: Text(
                          lastMessage != null
                              ? DateFormatter().getVerboseDateTime(
                                  new DateTime.fromMicrosecondsSinceEpoch(
                                      lastMessage.time * 1000),
                                )
                              : "",
                          style: TextStyle(fontSize: 11),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SkeletonAnimation(
                            shimmerColor:
                                currentTheme.currentTheme == ThemeMode.light
                                    ? Colors.grey[400]
                                    : Colors.grey[800],
                            borderRadius: BorderRadius.circular(35),
                            shimmerDuration: 1000,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color:
                                    currentTheme.currentTheme == ThemeMode.light
                                        ? Colors.grey[200]
                                        : Colors.grey[800],
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: currentTheme.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.grey[200]
                                        : Colors.grey[850],
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                            ),
                          ),
                          SkeletonAnimation(
                            shimmerColor:
                                currentTheme.currentTheme == ThemeMode.light
                                    ? Colors.grey[400]
                                    : Colors.grey[800],
                            borderRadius: BorderRadius.circular(35),
                            shimmerDuration: 1000,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color:
                                    currentTheme.currentTheme == ThemeMode.light
                                        ? Colors.grey[200]
                                        : Colors.grey[800],
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: currentTheme.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.grey[200]
                                        : Colors.grey[850],
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width - 8,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }
}
