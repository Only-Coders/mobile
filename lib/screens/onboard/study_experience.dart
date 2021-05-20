import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/onboard/study_experience/add_study_experience.dart';
import 'package:mobile/components/onboard/study_experience/study_experience_item.dart';
import 'package:mobile/components/toast.dart';
import 'package:mobile/models/study.dart';
import 'package:mobile/services/study.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudyExperience extends StatefulWidget {
  final increment;

  const StudyExperience({Key key, this.increment}) : super(key: key);

  @override
  _StudyExperienceState createState() => _StudyExperienceState();
}

class _StudyExperienceState extends State<StudyExperience> {
  final StudyService _studyService = StudyService();
  final Toast _toast = Toast();
  bool isLoading = false;
  List<Study> studies = [];

  void addStudy(Study study) {
    setState(() {
      studies.add(study);
    });
  }

  void removeStudy(Study study) {
    setState(() {
      studies.remove(study);
    });
  }

  void updateStudy(Study study, int index) {
    setState(() {
      studies[index] = study;
    });
  }

  Future<void> createStudies(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var futures = studies.map((study) {
        return _studyService.createStudy(study);
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
                  AppLocalizations.of(context).academicExperience,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    AppLocalizations.of(context).academicExperienceDescription),
                SizedBox(
                  height: 25,
                ),
                studies.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.height - 400,
                        child: listStudies(),
                      )
                    : SvgPicture.asset(
                        "assets/images/study.svg",
                        width: 180,
                      ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddStudyExperience(
                        addStudy: addStudy,
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
                      Text(AppLocalizations.of(context).addAcademic),
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

  Widget listStudies() {
    return new ListView(
      shrinkWrap: true,
      children: studies
          .map((study) => new StudyExperienceItem(
                study: study,
                index: studies.indexOf(study),
                removeStudy: removeStudy,
                updateStudy: updateStudy,
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
        await createStudies(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }
}
