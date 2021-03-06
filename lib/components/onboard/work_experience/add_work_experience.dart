import 'package:flutter/material.dart';
import 'package:mobile/models/work_position.dart';
import 'package:mobile/models/workplace.dart';
import 'package:mobile/services/work.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/theme/themes.dart';

class AddWorkExperience extends StatefulWidget {
  final addWork;

  const AddWorkExperience({Key key, this.addWork}) : super(key: key);

  @override
  _AddWorkExperienceState createState() => _AddWorkExperienceState();
}

class _AddWorkExperienceState extends State<AddWorkExperience> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  final WorkService _workService = WorkService();
  String position = "";
  String workplace = "";
  String workplaceId = "";
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
      title: Text(
        t.addWorkExperience,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(5),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TypeAheadFormField<Workplace>(
                  suggestionsCallback: _workService.getWorkplaces,
                  onSuggestionSelected: (Workplace suggestion) {
                    _typeAheadController.text = suggestion.name;
                    setState(() {
                      workplace = suggestion.name;
                      workplaceId = suggestion.id;
                    });
                  },
                  itemBuilder: (context, Workplace suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion.name,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    );
                  },
                  validator: (val) {
                    return val.isNotEmpty ? null : t.fieldRequired;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      labelText: t.workName,
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      filled: true,
                      fillColor: currentTheme.currentTheme == ThemeMode.dark
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.grey.shade200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      position = val;
                    });
                  },
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: t.position,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    filled: true,
                    fillColor: currentTheme.currentTheme == ThemeMode.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey.shade200,
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
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: t.startDate,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    filled: true,
                    fillColor: currentTheme.currentTheme == ThemeMode.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey.shade200,
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
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: t.endDate,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    filled: true,
                    fillColor: currentTheme.currentTheme == ThemeMode.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey.shade200,
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
            t.close.toUpperCase(),
            style: TextStyle(color: Colors.grey),
          ),
          style: TextButton.styleFrom(primary: Colors.grey),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState.validate()) {
              WorkPosition work = WorkPosition.fromJson({
                "workplace": {
                  "id": workplaceId,
                  "name":
                      workplace.isEmpty ? _typeAheadController.text : workplace,
                },
                "position": position,
                "since": _startDate.toIso8601String(),
                "until": _endDate == null ? null : _endDate.toIso8601String(),
              });
              widget.addWork(work);
              Navigator.pop(context);
            }
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
