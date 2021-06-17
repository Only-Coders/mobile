import 'package:flutter/material.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/onboard/study_experience/add_study_experience.dart';
import 'package:mobile/components/onboard/study_experience/edit_study_experience.dart';
import 'package:mobile/models/study.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class StudyPreview extends StatefulWidget {
  final String canonicalName;

  const StudyPreview({Key key, this.canonicalName}) : super(key: key);

  @override
  _StudyPreviewState createState() => _StudyPreviewState();
}

class _StudyPreviewState extends State<StudyPreview> {
  final PersonService _personService = PersonService();
  Future getStudies;

  void refreshStudyExperience() {
    setState(() {});
  }

  String parseStudyDate(String date) {
    if (date != null) {
      List<String> splitedDate = date.substring(0, 10).split("-");
      return "${splitedDate[1]}/${splitedDate[0]}";
    } else {
      return "Actual";
    }
  }

  @override
  void initState() {
    getStudies = _personService.getPersonStudies(widget.canonicalName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (widget.canonicalName == context.read<User>().canonicalName)
                  IconButton(
                    splashRadius: 20,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AddStudyExperience(
                        addStudy: () {},
                      ),
                      barrierDismissible: true,
                    ),
                    icon: Icon(Icons.add),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                t.academicExperience,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: getStudies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Study> studies = snapshot.data;

                    if (studies.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: FixedTimeline.tileBuilder(
                          builder: TimelineTileBuilder(
                            nodePositionBuilder: (context, index) => 0,
                            indicatorBuilder: (context, index) => DotIndicator(
                              size: 24,
                              color: index.isEven
                                  ? Theme.of(context).primaryColor
                                  : Colors.orange,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            startConnectorBuilder: (context, index) =>
                                SolidLineConnector(
                              color: Colors.grey.shade300,
                            ),
                            endConnectorBuilder: (context, index) =>
                                SolidLineConnector(
                              color: Colors.grey.shade300,
                            ),
                            contentsBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${parseStudyDate(studies[index].since)}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        Text(
                                          "${parseStudyDate(studies[index].until)}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        studies[index].institute.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        studies[index].degree,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.canonicalName ==
                                      context.read<User>().canonicalName)
                                    Flexible(
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 20,
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (_) => EditStudyExperience(
                                            study: studies[index],
                                            index: index,
                                            updateStudy: () {},
                                          ),
                                          barrierDismissible: true,
                                        ),
                                        icon: Icon(Icons.edit),
                                      ),
                                    ),
                                  if (widget.canonicalName ==
                                      context.read<User>().canonicalName)
                                    Flexible(
                                      child: IconButton(
                                        splashRadius: 20,
                                        iconSize: 20,
                                        onPressed: () {},
                                        icon: Icon(Icons.delete),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            itemCount: studies.length,
                          ),
                        ),
                      );
                    } else {
                      return NoData(
                        message: "No studies found",
                        img: "assets/images/no-data-study.png",
                      );
                    }
                  } else if (snapshot.hasError) {
                    return ServerError(
                      refresh: refreshStudyExperience,
                    );
                  }
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
