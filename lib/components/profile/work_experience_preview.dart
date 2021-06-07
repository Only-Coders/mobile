import 'package:flutter/material.dart';
import 'package:mobile/components/onboard/work_experience/work_experience_item.dart';
import 'package:mobile/models/work_position.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/work.dart';

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

    return FutureBuilder(
      future: getWorks,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 5),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.posts,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final List<WorkPosition> works =
                snapshot.data as List<WorkPosition>;

            return Container(
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
                        t.workExperience,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).accentColor),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Center(
                          child: works.length == 0
                              ? Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/no-data-work.png",
                                      width: 128,
                                    ),
                                    Text(
                                      t.postsNoData,
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: works
                                      .map(
                                        (work) => WorkExperienceItem(
                                          work: work,
                                          index: works.indexOf(work),
                                          inProfile: true,
                                          removeWork: removeWork,
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(top: 5),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.workExperience,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
