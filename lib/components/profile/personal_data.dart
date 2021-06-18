import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/git_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalData extends StatefulWidget {
  final String description;
  final String mail;
  final String country;
  final String birthDate;
  final String gitProfile;
  final String gitPlatform;

  const PersonalData({
    Key key,
    @required this.description,
    @required this.mail,
    @required this.birthDate,
    @required this.country,
    @required this.gitProfile,
    @required this.gitPlatform,
  }) : super(key: key);

  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  String parseBirthDate(String date) {
    List<String> splittedDate = date.substring(0, 10).split("-");
    return "${splittedDate[2]}/${splittedDate[1]}/${splittedDate[0]}";
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
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 65),
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.orange,
              ),
              height: 10,
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                t.personalData,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.description,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Text(
                          widget.description.isEmpty
                              ? t.noDescription
                              : widget.description,
                          style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Text(
                          widget.mail,
                          style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Text(
                          widget.country,
                          style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Text(
                          parseBirthDate(widget.birthDate),
                          style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.gitProfile != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GitPlatform(
                          platform: widget.gitPlatform,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () =>
                              launchUrl(widget.gitProfile, widget.gitPlatform),
                          child: Text("@${widget.gitProfile}"),
                        )
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
