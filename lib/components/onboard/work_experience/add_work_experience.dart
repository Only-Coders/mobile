import 'package:flutter/material.dart';
import 'package:mobile/models/work.dart';
import 'package:mobile/models/workplace.dart';
import 'package:mobile/services/work.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return AlertDialog(
      title: Text(AppLocalizations.of(context).addWorkExperience),
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
                      title: Text(suggestion.name),
                    );
                  },
                  validator: (val) {
                    return val.isNotEmpty
                        ? null
                        : AppLocalizations.of(context).fieldRequired;
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
                      labelText: AppLocalizations.of(context).workName,
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
                      position = val;
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
                    labelText: AppLocalizations.of(context).position,
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
                    return val != null
                        ? null
                        : AppLocalizations.of(context).fieldRequired;
                  },
                  onTap: () async {
                    DateTime date = await showDatePicker(
                        context: context,
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
                    labelText: AppLocalizations.of(context).startDate,
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
                          : AppLocalizations.of(context).endDateValidation;
                    }
                  },
                  onTap: () async {
                    DateTime date = await showDatePicker(
                        context: context,
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
                    labelText: AppLocalizations.of(context).endDate,
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
            AppLocalizations.of(context).close.toUpperCase(),
            style: TextStyle(color: Colors.grey),
          ),
          style: TextButton.styleFrom(primary: Colors.grey),
        ),
        TextButton(
          onPressed: () async {
            Work work = Work.fromJson({
              "id": workplaceId,
              "name": workplace,
              "position": position,
              "since": _startDate.toIso8601String(),
              "until": _endDate.toIso8601String()
            });
            widget.addWork(work);
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context).add.toUpperCase(),
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
