import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/components/generic/git_platform.dart';
import 'package:mobile/components/profile/description.dart';
import 'package:mobile/components/profile/nav_drawer.dart';
import 'package:mobile/components/profile/post_preview.dart';
import 'package:mobile/models/profile.dart' as ProfileType;
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String canonicalName;

  const Profile({Key key, this.canonicalName}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PersonService _personService = PersonService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: _personService.getPersonProfile(widget.canonicalName != null
              ? widget.canonicalName
              : user.canonicalName),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      '${snapshot.error} occured',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                );
              } else {
                ProfileType.Profile user = snapshot.data;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        height: 200,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: user.imageURI.isEmpty
                                        ? AssetImage(
                                            "assets/images/default-avatar.png")
                                        : NetworkImage(user.imageURI),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${user.firstName} ${user.lastName}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    user.currentPosition != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              "${user.currentPosition.position} ${user.currentPosition.workplace.name}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.only(bottom: 5),
                                          ),
                                    if (user.gitProfile != null)
                                      Row(
                                        children: [
                                          GitPlatform(
                                              platform:
                                                  user.gitProfile.platform),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "@${user.gitProfile.userName}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ],
                            ),
                            if (user.description != null &&
                                user.description.isNotEmpty)
                              Positioned(
                                top: 140,
                                width: MediaQuery.of(context).size.width - 40,
                                child:
                                    Description(description: user.description),
                              ),
                          ],
                        ),
                      ),
                      PostPreview(),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Favoritos",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "No hay favoritos recientes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Experiencias",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "No hay experiencias recientes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Formacion academica",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "No hay educaciones recientes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Habilidades",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "No hay habilidades recientes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Intereses",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "No hay intereses recientes",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }),
    );
  }
}
