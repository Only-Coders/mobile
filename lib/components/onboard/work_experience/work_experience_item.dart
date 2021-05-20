import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/onboard/work_experience/edit_work_experience.dart';
import 'package:mobile/models/work.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkExperienceItem extends StatelessWidget {
  final Work work;
  final int index;
  final removeWork;
  final updateWork;

  const WorkExperienceItem(
      {Key key, this.work, this.index, this.removeWork, this.updateWork})
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
                work.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                work.position,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "${parseDate(work.since)} - ${work.until.isEmpty ? "" : parseDate(work.until)}",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    child: Text(AppLocalizations.of(context).delete),
                    onPressed: () {
                      removeWork(work);
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
                        builder: (_) => EditWorkExperience(
                          work: work,
                          index: index,
                          updateWork: updateWork,
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
