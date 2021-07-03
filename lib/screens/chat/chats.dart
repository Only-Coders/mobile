import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/components/chat/chats_list.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:mobile/theme/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chats extends StatefulWidget {
  final User user;

  const Chats({Key key, @required this.user}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final PersonService _personService = PersonService();
  StreamController<Chat> _controller = StreamController();
  List<Chat> newChats = [];

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        title: Container(
          height: 40,
          child: TypeAheadField<Person>(
            suggestionsCallback: (String name) {
              return _personService.getMyContacts(0, name, 4);
            },
            onSuggestionSelected: (Person suggestion) {
              setState(() {
                _controller.add(Chat.fromJson({
                  "to": "${suggestion.firstName} ${suggestion.lastName}",
                  "from": "${widget.user.fullName}",
                  "toCanonicalName": suggestion.canonicalName,
                  "toImageURI": suggestion.imageURI,
                  "fromImageURI": widget.user.imageURI,
                  "lastMessage": {
                    "text": "Start a conversation",
                    "time": 0,
                    "read": false,
                    "from": widget.user.canonicalName
                  }
                }));
              });
            },
            itemBuilder: (ctx, Person suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: suggestion.imageURI.isEmpty
                      ? AssetImage("assets/images/default-avatar.png")
                      : NetworkImage(suggestion.imageURI),
                ),
                title: Text(
                  suggestion.firstName,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                subtitle: Text(
                  suggestion.currentPosition != null
                      ? "${suggestion.currentPosition.workplace.name} ${suggestion.currentPosition.position}"
                      : "",
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                  ),
                ),
              );
            },
            noItemsFoundBuilder: (ctx) => NoData(
              message: t.usersNotFound,
              img: "assets/images/no-data.png",
            ),
            textFieldConfiguration: TextFieldConfiguration(
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
                labelText: t.search,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users/${widget.user.canonicalName}/chats")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> chatsKeys = [];

            if (snapshot.data.snapshot.value != null)
              (snapshot.data.snapshot.value as Map).forEach((key, value) {
                chatsKeys.add(value["key"]);
              });
            return ChatsList(
              chatsKeys: chatsKeys,
              newChatStream: _controller.stream,
            );
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
      ),
    );
  }
}
