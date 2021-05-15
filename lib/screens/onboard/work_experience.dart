import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/onboard/add_work_experience.dart';

class WorkExperience extends StatefulWidget {
  final increment;

  const WorkExperience({Key key, this.increment}) : super(key: key);

  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              "Ingresa tus experiencias laborales para que los reclutradores se comuniquen contigo."),
          SizedBox(
            height: 25,
          ),
          SvgPicture.asset(
            "assets/images/work.svg",
            width: 180,
          ),
          // WorkExperienceItem(),
          SizedBox(
            height: 25,
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddWorkExperience(),
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
          SizedBox(
            height: 75,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              nextButton(),
            ],
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
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }
}
