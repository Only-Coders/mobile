import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  String firstName = "";
  String lastName = "";
  DateTime birthDate;
  String country = "UY";
  Future getCountries;
  bool isLoading = false;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    List<Country> countries = [];
    try {
      countries = await _countryService.getCountries();
    } catch (error) {
      Navigator.pushReplacementNamed(context, "/login");
    }
    return countries;
  }

  @override
  void initState() {
    getCountries = fetchCountries();
    super.initState();
  }

  String parseDate(String date) {
    List<String> splitedDate = date.split("-");
    return '${splitedDate[2]}/${splitedDate[1]}/${splitedDate[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCountries,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                  controller: _dateController,
                                  onTap: () async {
                                    DateTime date = await showDatePicker(
                                        context: context,
                                        initialDate: birthDate == null
                                            ? DateTime.now()
                                            : birthDate,
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime(2022));
                                    if (date != null) {
                                      _dateController.text = parseDate(
                                          date.toString().substring(0, 10));
                                      setState(() {
                                        birthDate = date;
                                      });
                                    }
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
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField(
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>(
                                          (Country c) {
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
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 80,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          valueColor:
                              AlwaysStoppedAnimation(Colors.grey.shade200),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
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
          Provider.of<RegisterModel>(context, listen: false).setFirstStepData(
              firstName, lastName, birthDate.toIso8601String(), country);
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
