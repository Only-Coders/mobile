import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/onboard/work_experience/add_work_experience.dart';
import 'package:mobile/components/onboard/work_experience/work_experience_item.dart';
import 'package:mobile/components/toast.dart';
import 'package:mobile/models/work_position.dart';
import 'package:mobile/services/work.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkExperience extends StatefulWidget {
  final increment;

  const WorkExperience({Key key, this.increment}) : super(key: key);

  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  bool isLoading = false;
  final WorkService _workService = WorkService();
  final Toast _toast = Toast();
  List<WorkPosition> works = [];

  void addWork(WorkPosition work) {
    setState(() {
      works.add(work);
    });
  }

  void removeWork(WorkPosition work) {
    setState(() {
      works.remove(work);
    });
  }

  void updateWork(WorkPosition work, int index) {
    setState(() {
      works[index] = work;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).workExperience,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(AppLocalizations.of(context).workExperienceDescription),
                SizedBox(
                  height: 25,
                ),
                works.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.height - 400,
                        child: listWorks(),
                      )
                    : SvgPicture.asset(
                        "assets/images/work.svg",
                        width: 180,
                      ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddWorkExperience(
                        addWork: addWork,
                      ),
                      barrierDismissible: true,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(AppLocalizations.of(context).addWorkExperience),
                    ],
                  ),
                  style: TextButton.styleFrom(primary: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                nextButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listWorks() {
    return new ListView(
      shrinkWrap: true,
      children: works
          .map((work) => new WorkExperienceItem(
                work: work,
                index: works.indexOf(work),
                removeWork: removeWork,
                updateWork: updateWork,
              ))
          .toList(),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      child: isLoading
          ? SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                strokeWidth: 3,
              ),
            )
          : Text(AppLocalizations.of(context).next),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        try {
          var futures = works.map((work) {
            return _workService.createWork(work);
          });
          await Future.wait(futures);
          widget.increment();
        } catch (error) {
          _toast.showError(context, AppLocalizations.of(context).serverError);
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }
}
