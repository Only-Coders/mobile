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
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
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
                          SizedBox(
                            height: 5,
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
                                margin: EdgeInsets.symmetric(horizontal: 20),
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
  }
}
