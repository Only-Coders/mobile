import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/models/oc_notification.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final PersonService _personService = PersonService();
  Future getNotificationsConfig;

  @override
  void initState() {
    getNotificationsConfig = _personService.getUserNotificationsConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        title: Text(
          t.settings,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getNotificationsConfig,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<OCNotification> config = snapshot.data;

              return Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.notifications,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newPostNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[4] = OCNotification(
                                    id: config[4].id,
                                    type: config[4].type,
                                    email: val,
                                    push: config[4].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[4]);
                              },
                              value: config[4].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[4] = OCNotification(
                                    id: config[4].id,
                                    type: config[4].type,
                                    email: config[4].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[4]);
                              },
                              value: config[4].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newCommentNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[3] = OCNotification(
                                    id: config[3].id,
                                    type: config[3].type,
                                    email: val,
                                    push: config[3].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[3]);
                              },
                              value: config[3].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[3] = OCNotification(
                                    id: config[3].id,
                                    type: config[3].type,
                                    email: config[3].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[3]);
                              },
                              value: config[3].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newMentionNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[2] = OCNotification(
                                    id: config[2].id,
                                    type: config[2].type,
                                    email: val,
                                    push: config[2].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[2]);
                              },
                              value: config[2].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[2] = OCNotification(
                                    id: config[2].id,
                                    type: config[2].type,
                                    email: config[2].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[2]);
                              },
                              value: config[2].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newContactRequestNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[0] = OCNotification(
                                    id: config[0].id,
                                    type: config[0].type,
                                    email: val,
                                    push: config[0].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[0]);
                              },
                              value: config[0].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[0] = OCNotification(
                                    id: config[0].id,
                                    type: config[0].type,
                                    email: config[0].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[0]);
                              },
                              value: config[0].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newContactAceptedNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[5] = OCNotification(
                                    id: config[5].id,
                                    type: config[5].type,
                                    email: val,
                                    push: config[5].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[5]);
                              },
                              value: config[5].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[5] = OCNotification(
                                    id: config[5].id,
                                    type: config[5].type,
                                    email: config[5].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[5]);
                              },
                              value: config[5].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.newFollowerNotification),
                        Row(
                          children: [
                            Text(
                              "Email",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[1] = OCNotification(
                                    id: config[1].id,
                                    type: config[1].type,
                                    email: val,
                                    push: config[1].push,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[1]);
                              },
                              value: config[1].email,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Push",
                            ),
                            Checkbox(
                              onChanged: (val) async {
                                setState(() {
                                  config[1] = OCNotification(
                                    id: config[1].id,
                                    type: config[1].type,
                                    email: config[1].email,
                                    push: val,
                                  );
                                });
                                await _personService
                                    .updateNotification(config[1]);
                              },
                              value: config[1].push,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      t.appearance,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.theme,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.bedtime,
                              color: currentTheme.currentTheme == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            Switch(
                              value:
                                  currentTheme.currentTheme != ThemeMode.dark,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) async {
                                await currentTheme.toggleTheme();
                              },
                            ),
                            Icon(
                              Icons.wb_sunny,
                              color: currentTheme.currentTheme == ThemeMode.dark
                                  ? Colors.grey
                                  : Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      t.language,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.language,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/english.png",
                              width: 30,
                            ),
                            Switch(
                              value: Provider.of<User>(context, listen: false)
                                          .language ==
                                      "es"
                                  ? true
                                  : false,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) async {
                                await Provider.of<User>(context, listen: false)
                                    .setLanguage(value ? "es" : "en");
                              },
                            ),
                            Image.asset(
                              "assets/images/spanish.png",
                              width: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Text("Error");
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
      ),
    );
  }
}
