import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/models/institute.dart';
import 'package:mobile/models/study.dart';
import 'package:mobile/services/study.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/theme/themes.dart';

class AddStudyExperience extends StatefulWidget {
  final addStudy;

  const AddStudyExperience({Key key, this.addStudy}) : super(key: key);

  @override
  _AddStudyExperienceState createState() => _AddStudyExperienceState();
}

class _AddStudyExperienceState extends State<AddStudyExperience> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _studyService = StudyService();
  final TextEditingController _typeAheadController = TextEditingController();
  final _endDateController = TextEditingController();
  final _startDateController = TextEditingController();
  String institute = "";
  String instituteId = "";
  String degree = "";
  DateTime _startDate;
  DateTime _endDate;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _typeAheadController.dispose();
    super.dispose();
  }

  String parseDate(String date) {
    List<String> splitedDate = date.substring(0, 10).split("-");
    return '${splitedDate[2]}/${splitedDate[1]}/${splitedDate[0]}';
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(t.addAcademic),
      content: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(5),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TypeAheadFormField<Institute>(
                  suggestionsCallback: _studyService.getInstitutes,
                  onSuggestionSelected: (Institute suggestion) {
                    _typeAheadController.text = suggestion.name;
                    setState(() {
                      institute = suggestion.name;
                      instituteId = suggestion.id;
                    });
                  },
                  itemBuilder: (context, Institute suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  validator: (val) {
                    return val.isNotEmpty ? null : t.fieldRequired;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      labelText: t.instituteName,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      degree = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: t.degree,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _startDateController,
                  validator: (val) {
                    return val != null ? null : t.fieldRequired;
                  },
                  onTap: () async {
                    DateTime date = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: currentTheme.currentTheme == ThemeMode.light
                                ? CustomTheme.lightTheme.copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : CustomTheme.darkTheme.copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  ),
                            child: child,
                          );
                        },
                        initialDate:
                            _startDate == null ? DateTime.now() : _startDate,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2022));
                    if (date != null) {
                      _startDateController.text =
                          parseDate(date.toString().substring(0, 10));
                      setState(() {
                        _startDate = date;
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
                    labelText: t.startDate,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _endDateController,
                  validator: (val) {
                    if (_endDate == null) {
                      return null;
                    } else {
                      return _endDate.isAfter(_startDate)
                          ? null
                          : t.endDateValidation;
                    }
                  },
                  onTap: () async {
                    DateTime date = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: currentTheme.currentTheme == ThemeMode.light
                                ? CustomTheme.lightTheme.copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : CustomTheme.darkTheme.copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                  ),
                            child: child,
                          );
                        },
                        initialDate:
                            _endDate == null ? DateTime.now() : _endDate,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2022));
                    if (date != null) {
                      _endDateController.text =
                          parseDate(date.toString().substring(0, 10));
                      setState(() {
                        _endDate = date;
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
                    labelText: t.endDate,
                    filled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            t.cancel.toUpperCase(),
            style: TextStyle(color: Colors.grey),
          ),
          style: TextButton.styleFrom(primary: Colors.grey),
        ),
        TextButton(
          onPressed: () async {
            Study study = Study.fromJson({
              "institute": {
                "id": instituteId,
                "name":
                    institute.isEmpty ? _typeAheadController.text : institute,
              },
              "id": instituteId,
              "degree": degree,
              "since": _startDate.toIso8601String(),
              "until": _endDate == null ? null : _endDate.toIso8601String(),
            });
            widget.addStudy(study);
            Navigator.pop(context);
          },
          child: Text(
            t.add.toUpperCase(),
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          style: TextButton.styleFrom(primary: Colors.orange),
        ),
      ],
    );
  }
}
