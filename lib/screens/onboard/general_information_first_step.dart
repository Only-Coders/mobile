import 'package:flutter/material.dart';
import 'package:mobile/models/country.dart';
import 'package:mobile/screens/onboard/register_model.dart';
import 'package:mobile/services/country.dart';
import 'package:provider/provider.dart';

class GeneralInformationFirstStep extends StatefulWidget {
  final increment;

  const GeneralInformationFirstStep({Key key, this.increment})
      : super(key: key);

  @override
  _GeneralInformationFirstStepState createState() =>
      _GeneralInformationFirstStepState();
}

class _GeneralInformationFirstStepState
    extends State<GeneralInformationFirstStep> {
  CountryService _countryService = CountryService();
  String firstName = "";
  String lastName = "";
  String birthDate = "";
  String country = "UY";
  List<Country> _countries = [];
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));

    if (_datePicker != null) {
      setState(() {
        birthDate = _datePicker.toString();
      });
    }
  }

  String parseDate(String date) {
    if (date.isEmpty) {
      return "";
    } else {
      String parsedDate = date.substring(0, 10);
      List<String> splitedDate = parsedDate.split("-");
      return '${splitedDate[2]}/${splitedDate[1]}/${splitedDate[0]}';
    }
  }

  Future<List<Country>> getCountries() async {
    List<Country> countries = [];
    try {
      countries = await _countryService.getCountries();
      _countries = countries;
    } catch (e) {
      print(e);
    }
    return countries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: [
              Text(
                "Informacion General",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Ingresa tu información con la que deseas que los otros usuarios te vean."),
              SizedBox(
                height: 60,
              ),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          firstName = val;
                        });
                      },
                      validator: (val) {
                        return val.isNotEmpty
                            ? null
                            : "Este campo es obligatorio";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: "Nombre",
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          lastName = val;
                        });
                      },
                      validator: (val) {
                        return val.isNotEmpty
                            ? null
                            : "Este campo es obligatorio";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: "Apellido",
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: "Fecha de Nacimiento",
                        hintText: parseDate(birthDate),
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      items: _countries.map((c) {
                        return DropdownMenuItem(
                          value: c.code,
                          child: Text(c.name),
                        );
                      }).toList(),
                      validator: (val) {
                        return val.isNotEmpty
                            ? null
                            : "Este campo es obligatorio";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelText: "Pais",
                        filled: true,
                      ),
                      value: country,
                      isExpanded: true,
                      onChanged: (val) {
                        setState(() {
                          country = val;
                        });
                      },
                    ),
                  ],
                ),
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
          );
        },
        future: getCountries(),
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
      onPressed: () {
        if (formKey.currentState.validate() && !isLoading) {
          setState(() {
            isLoading = true;
          });
          Provider.of<RegisterModel>(context, listen: false)
              .setFirstStepData(firstName, lastName, birthDate, country);
          widget.increment();
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
