import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/components/generic/git_platform.dart';
import 'package:mobile/components/profile/description.dart';
import 'package:mobile/components/profile/favorites_preview.dart';
import 'package:mobile/components/profile/nav_drawer.dart';
import 'package:mobile/components/profile/post_preview.dart';
import 'package:mobile/components/profile/work_experience_preview.dart';
import 'package:mobile/models/profile.dart' as ProfileType;
import 'package:mobile/services/person.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String canonicalName;

  const Profile({Key key, this.canonicalName}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PersonService _personService = PersonService();
  Future getProfile;

  @override
  void initState() {
    getProfile = _personService.getPersonProfile(widget.canonicalName);
    super.initState();
  }

  Future<void> launchUrl(String user, String gitPlatform) async {
    switch (gitPlatform) {
      case "GITHUB":
        String url = "https://github.com/$user";
        if (await canLaunch(url)) {
          await launch(url);
        }
        break;
      case "GITLAB":
        String url = "https://gitlab.com/$user";
        if (await canLaunch(url)) {
          await launch(url);
        }
        break;
      case "BITBUCKET":
        String url = "https://bitbucket.com/$user";
        if (await canLaunch(url)) {
          await launch(url);
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: getProfile,
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
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                            ),
                                      if (user.gitProfile != null)
                                        GestureDetector(
                                          onTap: () {
                                            launchUrl(user.gitProfile.userName,
                                                user.gitProfile.platform);
                                          },
                                          child: Row(
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
                                          ),
                                        )
                                    ],
                                  ),
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
                      PostPreview(
                        canonicalName: widget.canonicalName,
                      ),
                      FavoritesPreview(),
                      WorkExperiencePreview(
                        canonicalName: widget.canonicalName,
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 5),
                      //   width: double.infinity,
                      //   child: Card(
                      //     elevation: 0,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(15),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             "Experiencias",
                      //             style: TextStyle(
                      //                 color: Theme.of(context).accentColor),
                      //           ),
                      //           Center(
                      //             child: Column(
                      //               children: [
                      //                 Image.asset(
                      //                   "assets/images/no-data-work.png",
                      //                   width: 128,
                      //                 ),
                      //                 SizedBox(
                      //                   height: 5,
                      //                 ),
                      //                 Text(
                      //                   "No hay experiencias recientes",
                      //                   style: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .accentColor
                      //                         .withOpacity(0.6),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                                Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/no-data-study.png",
                                        width: 128,
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
