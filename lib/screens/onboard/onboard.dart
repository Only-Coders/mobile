import 'package:flutter/material.dart';
import 'package:mobile/screens/onboard/general_information_first_step.dart';
import 'package:mobile/screens/onboard/general_information_second_step.dart';
import 'package:im_stepper/stepper.dart';
import 'package:mobile/screens/onboard/register_model.dart';
import 'package:mobile/screens/onboard/work_experience.dart';
import 'package:provider/provider.dart';

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int activeStep = 0;
  int dotCount = 7;

  void incrementActiveStep() {
    setState(() {
      activeStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Image.asset(
          'assets/images/logo-onboard.png',
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Provider(
              create: (_) => RegisterModel(),
              child: steps(),
            ),
            Positioned(
              bottom: 95,
              child: Center(
                child: DotStepper(
                  dotCount: dotCount,
                  dotRadius: 6,
                  activeStep: activeStep,
                  tappingEnabled: false,
                  shape: Shape.circle,
                  spacing: 10,
                  indicator: Indicator.blink,
                  fixedDotDecoration: FixedDotDecoration(
                    color: Colors.grey.shade300,
                  ),
                  indicatorDecoration: IndicatorDecoration(
                    strokeWidth: 2,
                    strokeColor: Color(0xffFFEDE1),
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget steps() {
    switch (activeStep) {
      case 1:
        return GeneralInformationSecondStep(
          increment: incrementActiveStep,
        );
      case 2:
        return WorkExperience(
          increment: incrementActiveStep,
        );
      case 3:
        return Text("Formacion Academica");
      case 4:
        return Text("Habilidades");
      case 5:
        return Text("Red de Contactos");
      case 6:
        return Text("Temas");
      default:
        return GeneralInformationFirstStep(
          increment: incrementActiveStep,
        );
    }
  }
}
