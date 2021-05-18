import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/onboard/add_work_experience.dart';
import 'package:mobile/components/onboard/work_experience_item.dart';
import 'package:mobile/components/toast.dart';
import 'package:mobile/models/work.dart';
import 'package:mobile/services/work.dart';

class WorkExperience extends StatefulWidget {
  final increment;

  const WorkExperience({Key key, this.increment}) : super(key: key);

  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  bool isLoading = false;
  List<Work> works = [];

  void addWork(Work work) {
    setState(() {
      works.add(work);
    });
  }

  void removeWork(Work work) {
    setState(() {
      works.remove(work);
    });
  }

  void updateWork(Work work, int index) {
    print(work);
    print(index);
    setState(() {
      works[index] = work;
    });
  }

  Future<void> register(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      WorkService _workService = WorkService();
      works.forEach((work) async {
        await _workService.createWork(work);
      });
      widget.increment();
    } catch (error) {
      Toast().showError(context, "Ups, algo salio mal :(");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  "Experiencia Laboral",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "Ingresa tus experiencias laborales para que los usuarios se comuniquen contigo."),
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
                      Text("Agregar experiencia"),
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
          : Text("Siguiente"),
      onPressed: () async {
        await register(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }
}
