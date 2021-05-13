import 'package:flutter/material.dart';
import 'package:mobile/screens/onboard/general_information_first_step.dart';
import 'package:mobile/screens/onboard/general_information_second_step.dart';
import 'package:im_stepper/stepper.dart';

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
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: steps(),
              ),
              Positioned.fill(
                bottom: 90,
                child: Align(
                  alignment: Alignment.bottomCenter,
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
      ),
    );
  }

  Widget steps() {
    switch (activeStep) {
      case 1:
        return GeneralInformationSecondStep();
      case 2:
        return Text("Experiencia Laboral");
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
