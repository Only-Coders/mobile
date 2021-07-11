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
  List<OCNotification> ocNotifications = [];
  Map<String, Map<String, bool>> notifications = {
    "newPost": {"push": true, "email": true},
    "newComments": {"push": false, "email": true},
    "newMentions": {"push": true, "email": true},
    "newContactRequest": {"push": false, "email": true},
    "newContactAccepted": {"push": true, "email": true},
    "newFollower": {"push": false, "email": true},
  };

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
                // List<OCNotification> config = snapshot.data;
                ocNotifications = snapshot.data;
                // print(ocNotifications[0].type);
                // print(ocNotifications[1].type);
                // print(ocNotifications[2].type);
                // print(ocNotifications[3].type);
                // print(ocNotifications[4].type);
                // print(ocNotifications[5].type);

                return Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.notifications,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Post"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newPost"]["email"] = val;
                                  });
                                },
                                value: notifications["newPost"]["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newPost"]["push"] = val;
                                  });
                                },
                                value: notifications["newPost"]["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Comments"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newComments"]["email"] = val;
                                  });
                                },
                                value: notifications["newComments"]["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newComments"]["push"] = val;
                                  });
                                },
                                value: notifications["newComments"]["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Mentions"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newMentions"]["email"] = val;
                                  });
                                },
                                value: notifications["newMentions"]["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newMentions"]["push"] = val;
                                  });
                                },
                                value: notifications["newMentions"]["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Contact Request"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newContactRequest"]
                                        ["email"] = val;
                                  });
                                },
                                value: notifications["newContactRequest"]
                                    ["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newContactRequest"]["push"] =
                                        val;
                                  });
                                },
                                value: notifications["newContactRequest"]
                                    ["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Contact Accepted"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newContactAccepted"]
                                        ["email"] = val;
                                  });
                                },
                                value: notifications["newContactAccepted"]
                                    ["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newContactAccepted"]
                                        ["push"] = val;
                                  });
                                },
                                value: notifications["newContactAccepted"]
                                    ["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("New Follower"),
                          Row(
                            children: [
                              Text(
                                "Email",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newFollower"]["email"] = val;
                                  });
                                },
                                value: notifications["newFollower"]["email"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text(
                                "Push",
                              ),
                              Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    notifications["newFollower"]["push"] = val;
                                  });
                                },
                                value: notifications["newFollower"]["push"],
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        t.appearance,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                                color:
                                    currentTheme.currentTheme == ThemeMode.dark
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
                                color:
                                    currentTheme.currentTheme == ThemeMode.dark
                                        ? Colors.grey
                                        : Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        t.language,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                                  print("ACA");
                                  await Provider.of<User>(context,
                                          listen: false)
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
            return Text("Loading");
          }),
    );
  }
}
