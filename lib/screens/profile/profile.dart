import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/profile/personal_data.dart';
import 'package:mobile/components/profile/favorites_preview.dart';
import 'package:mobile/components/profile/nav_drawer.dart';
import 'package:mobile/components/profile/post_preview.dart';
import 'package:mobile/components/profile/profile_actions.dart';
import 'package:mobile/components/profile/profile_header.dart';
import 'package:mobile/components/profile/profile_qty_info.dart';
import 'package:mobile/components/profile/remove_account_alert.dart';
import 'package:mobile/components/profile/skills_preview.dart';
import 'package:mobile/components/profile/study_preview.dart';
import 'package:mobile/components/profile/tags_preview.dart';
import 'package:mobile/components/profile/work_experience_preview.dart';
import 'package:mobile/models/contact_request.dart';
import 'package:mobile/models/profile.dart' as ProfileType;
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  final String canonicalName;

  const Profile({Key key, this.canonicalName}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PersonService _personService = PersonService();
  Future getProfile;
  Future getContactRequests;
  int bronceMedals = 0;
  int silverMedals = 0;
  int goldMedals = 0;

  void refreshProfile() {
    setState(() {});
  }

  void calculateMedals(int approves) {
    int bronce = approves % 5;
    approves = (approves - bronce) ~/ 5;
    int silver = approves % 5;
    int gold = (approves - silver) ~/ 5;
    setState(() {
      bronceMedals = bronce;
      silverMedals = silver;
      goldMedals = gold;
    });
  }

  @override
  void initState() {
    getProfile = _personService.getPersonProfile(widget.canonicalName);
    getContactRequests = _personService.getContactRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: Future.wait([getProfile, getContactRequests]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                ProfileType.Profile user = snapshot.data[0];
                List<ContactRequest> contactRequests = snapshot.data[1];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileHeader(
                        imageURI: user.imageURI,
                        isMyProfile: user.canonicalName ==
                            context.read<User>().canonicalName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        user.currentPosition != null
                            ? "${user.currentPosition.position} ${t.at} ${user.currentPosition.workplace.name}"
                            : "",
                        style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                            fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/gold-medal.png",
                            width: 12,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            goldMedals.toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Image.asset(
                            "assets/images/silver-medal.png",
                            width: 12,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            silverMedals.toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Image.asset(
                            "assets/images/bronce-medal.png",
                            width: 12,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            bronceMedals.toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      if (user.canonicalName !=
                          context.read<User>().canonicalName)
                        ProfileActions(
                          connected: user.connected,
                          requestHasBeenSent: user.requestHasBeenSent,
                          pendingRequest: user.pendingRequest,
                          following: user.following,
                          canonicalName: user.canonicalName,
                        ),
                      if (user.canonicalName ==
                              context.read<User>().canonicalName &&
                          contactRequests.length > 0)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed("/profile/contact-requests"),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "${contactRequests.length} ${t.contactRequests}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ProfileQtyInfo(
                        postQty: user.postQty,
                        followerQty: user.followerQty,
                        follwingQty: user.followingQty,
                        isMyProfile: user.canonicalName ==
                            context.read<User>().canonicalName,
                      ),
                      if (Provider.of<User>(context).eliminationDate != null &&
                          context.read<User>().canonicalName ==
                              user.canonicalName)
                        RemoveAccountAlert(),
                      PersonalData(
                        description: user.description,
                        mail: user.email,
                        country: user.country.name,
                        birthDate: user.birthDate,
                        gitPlatform: user.gitProfile?.platform ?? null,
                        gitProfile: user.gitProfile?.userName ?? null,
                      ),
                      PostPreview(
                        canonicalName: user.canonicalName,
                      ),
                      if (user.canonicalName ==
                          context.read<User>().canonicalName)
                        FavoritesPreview(
                          canonicalName: user.canonicalName,
                        ),
                      WorkExperiencePreview(
                        canonicalName: user.canonicalName,
                      ),
                      StudyPreview(
                        canonicalName: user.canonicalName,
                      ),
                      SkillsPreview(
                        canonicalName: user.canonicalName,
                      ),
                      TagsPreview(
                        canonicalName: user.canonicalName,
                      )
                    ],
                  ),
                );
              } else {
                return ServerError(
                  refresh: refreshProfile,
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

    // return Scaffold(
    //   endDrawer: NavDrawer(),
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).secondaryHeaderColor,
    //     brightness: Brightness.dark,
    //     iconTheme: IconThemeData(color: Colors.white),
    //     elevation: 0,
    //   ),
    //   body: FutureBuilder(
    //       future: getProfile,
    //       builder: (ctx, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.done) {
    //           if (snapshot.hasError) {
    //             return Container(
    //               child: Center(
    //                 child: Text(
    //                   '${snapshot.error} occured',
    //                   style: TextStyle(color: Theme.of(context).accentColor),
    //                 ),
    //               ),
    //             );
    //           } else {
    //             ProfileType.Profile user = snapshot.data;
    //
    //             return SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Container(
    //                     color: Theme.of(context).secondaryHeaderColor,
    //                     width: double.infinity,
    //                     padding: EdgeInsets.all(20),
    //                     height: 235,
    //                     child: Stack(
    //                       clipBehavior: Clip.none,
    //                       children: [
    //                         Row(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.symmetric(
    //                                   horizontal: 10),
    //                               child: CircleAvatar(
    //                                 radius: 40,
    //                                 backgroundColor: Colors.grey.shade300,
    //                                 backgroundImage: user.imageURI.isEmpty
    //                                     ? AssetImage(
    //                                         "assets/images/default-avatar.png")
    //                                     : NetworkImage(user.imageURI),
    //                               ),
    //                             ),
    //                             Flexible(
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text(
    //                                       "${user.firstName} ${user.lastName}",
    //                                       style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 24),
    //                                     ),
    //                                     user.currentPosition != null
    //                                         ? Padding(
    //                                             padding: const EdgeInsets.only(
    //                                                 bottom: 5),
    //                                             child: Text(
    //                                               "${user.currentPosition.position} ${user.currentPosition.workplace.name}",
    //                                               style: TextStyle(
    //                                                   color: Colors.white,
    //                                                   fontSize: 14),
    //                                             ),
    //                                           )
    //                                         : Container(
    //                                             padding:
    //                                                 EdgeInsets.only(bottom: 5),
    //                                           ),
    //                                     if (user.gitProfile != null)
    //                                       GestureDetector(
    //                                         onTap: () {
    //                                           launchUrl(
    //                                               user.gitProfile.userName,
    //                                               user.gitProfile.platform);
    //                                         },
    //                                         child: Row(
    //                                           children: [
    //                                             GitPlatform(
    //                                                 platform: user
    //                                                     .gitProfile.platform),
    //                                             SizedBox(
    //                                               width: 5,
    //                                             ),
    //                                             Text(
    //                                               "@${user.gitProfile.userName}",
    //                                               style: TextStyle(
    //                                                   color: Colors.white,
    //                                                   fontSize: 12),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     SizedBox(
    //                                       height: 34,
    //                                       child: TextButton(
    //                                         onPressed: () {
    //                                           Navigator.of(context).pushNamed(
    //                                               "/profile/contacts");
    //                                         },
    //                                         child: Text(
    //                                           "${user.contactQty} ${t.contacts}",
    //                                           style: TextStyle(
    //                                               color: Colors.white),
    //                                         ),
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         if (user.description != null &&
    //                             user.description.isNotEmpty)
    //                           Positioned(
    //                             top: 140,
    //                             width: MediaQuery.of(context).size.width - 40,
    //                             child:
    //                                 Description(description: user.description),
    //                           ),
    //                       ],
    //                     ),
    //                   ),
    //                   PostPreview(
    //                     canonicalName: widget.canonicalName,
    //                   ),
    //                   FavoritesPreview(),
    //                   WorkExperiencePreview(
    //                     canonicalName: widget.canonicalName,
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.only(top: 5),
    //                     width: double.infinity,
    //                     child: Card(
    //                       elevation: 0,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(15),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               "Formacion academica",
    //                               style: TextStyle(
    //                                   color: Theme.of(context).accentColor),
    //                             ),
    //                             Center(
    //                               child: Column(
    //                                 children: [
    //                                   Image.asset(
    //                                     "assets/images/no-data-study.png",
    //                                     width: 128,
    //                                   ),
    //                                   SizedBox(
    //                                     height: 5,
    //                                   ),
    //                                   Text(
    //                                     "No hay educaciones recientes",
    //                                     style: TextStyle(
    //                                       color: Theme.of(context)
    //                                           .accentColor
    //                                           .withOpacity(0.6),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.only(top: 5),
    //                     width: double.infinity,
    //                     child: Card(
    //                       elevation: 0,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(15),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               "Habilidades",
    //                               style: TextStyle(
    //                                   color: Theme.of(context).accentColor),
    //                             ),
    //                             SizedBox(
    //                               height: 5,
    //                             ),
    //                             Text(
    //                               "No hay habilidades recientes",
    //                               style: TextStyle(
    //                                 color: Theme.of(context)
    //                                     .accentColor
    //                                     .withOpacity(0.6),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.only(top: 5),
    //                     width: double.infinity,
    //                     child: Card(
    //                       elevation: 0,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(15),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               "Intereses",
    //                               style: TextStyle(
    //                                   color: Theme.of(context).accentColor),
    //                             ),
    //                             SizedBox(
    //                               height: 5,
    //                             ),
    //                             Text(
    //                               "No hay intereses recientes",
    //                               style: TextStyle(
    //                                 color: Theme.of(context)
    //                                     .accentColor
    //                                     .withOpacity(0.6),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             );
    //           }
    //         }
    //         return Container(
    //           child: Center(
    //             child: CircularProgressIndicator(
    //               color: Theme.of(context).primaryColor,
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}
