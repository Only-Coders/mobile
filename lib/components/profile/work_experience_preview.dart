import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/onboard/work_experience/add_work_experience.dart';
import 'package:mobile/components/onboard/work_experience/edit_work_experience.dart';
import 'package:mobile/models/work_position.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/work.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class WorkExperiencePreview extends StatefulWidget {
  final String canonicalName;

  const WorkExperiencePreview({Key key, this.canonicalName}) : super(key: key);

  @override
  _WorkExperiencePreviewState createState() => _WorkExperiencePreviewState();
}

class _WorkExperiencePreviewState extends State<WorkExperiencePreview> {
  final PersonService _personService = PersonService();
  final WorkService _workService = WorkService();
  Future getWorks;

  void refreshWorkExperiences() {
    setState(() {});
  }

  String parseWorkDate(String date) {
    if (date != null) {
      List<String> splitedDate = date.substring(0, 10).split("-");
      return "${splitedDate[1]}/${splitedDate[0]}";
    } else {
      return "Actual";
    }
  }

  @override
  void initState() {
    getWorks = _personService.getPersonWorks(widget.canonicalName);
    super.initState();
  }

  Future<void> removeWork(WorkPosition work) async {
    try {
      await _workService.deleteWork(work.id);
    } catch (error) {
      print(error);
    }
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
                      builder: (_) => AddWorkExperience(
                        addWork: () {},
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
                t.workExperience,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: getWorks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<WorkPosition> works = snapshot.data;

                    if (works.isNotEmpty) {
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
                            contentsBuilder: (context, index) => Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${parseWorkDate(works[index].since)}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      Text(
                                        "${parseWorkDate(works[index].until)}",
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      works[index].workplace.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      works[index].position,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (widget.canonicalName ==
                                          context.read<User>().canonicalName)
                                        IconButton(
                                          splashRadius: 20,
                                          iconSize: 20,
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (_) => EditWorkExperience(
                                              work: works[index],
                                              index: index,
                                              updateWork: () {},
                                            ),
                                            barrierDismissible: true,
                                          ),
                                          icon: Icon(Icons.edit),
                                        ),
                                      if (widget.canonicalName ==
                                          context.read<User>().canonicalName)
                                        IconButton(
                                          splashRadius: 20,
                                          iconSize: 20,
                                          onPressed: () {},
                                          icon: Icon(Icons.delete),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            itemCount: works.length,
                          ),
                        ),
                      );
                    } else {
                      return NoData(
                        message: "No works found",
                        img: "assets/images/no-data-work.png",
                      );
                    }
                  } else if (snapshot.hasError) {
                    return ServerError(
                      refresh: refreshWorkExperiences,
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
