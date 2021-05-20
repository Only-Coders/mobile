import 'package:flutter/material.dart';
import 'package:mobile/components/onboard/study_experience/edit_study_experience.dart';
import 'package:mobile/models/study.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudyExperienceItem extends StatelessWidget {
  final Study study;
  final int index;
  final removeStudy;
  final updateStudy;

  const StudyExperienceItem(
      {Key key, this.study, this.removeStudy, this.updateStudy, this.index})
      : super(key: key);

  String parseDate(String date) {
    List<String> splitedDate = date.substring(0, 10).split("-");
    return '${splitedDate[2]}/${splitedDate[1]}/${splitedDate[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                study.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                study.degree,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "${parseDate(study.since)} - ${study.until.isEmpty ? "" : parseDate(study.until)}",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    child: Text(AppLocalizations.of(context).delete),
                    onPressed: () {
                      removeStudy(study);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 12),
                      primary: Theme.of(context).errorColor,
                      // background
                      side: BorderSide(color: Theme.of(context).errorColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    child: Text(AppLocalizations.of(context).edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditStudyExperience(
                          study: study,
                          index: index,
                          updateStudy: updateStudy,
                        ),
                        barrierDismissible: true,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 12),
                      primary: Theme.of(context).primaryColor,
                      // background
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
