import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/models/institute.dart';
import 'package:mobile/models/study.dart';
import 'package:mobile/services/study.dart';

class EditStudyExperience extends StatefulWidget {
  final int index;
  final Study study;
  final updateStudy;

  const EditStudyExperience({Key key, this.index, this.study, this.updateStudy})
      : super(key: key);

  @override
  _EditStudyExperienceState createState() => _EditStudyExperienceState();
}

class _EditStudyExperienceState extends State<EditStudyExperience> {
  final StudyService _studyService = StudyService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final _degreeController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String degree = "";
  String institute = "";
  String instituteId = "";
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    setState(() {
      institute = widget.study.name;
      instituteId = widget.study.id;
      degree = widget.study.degree;
    });
    _typeAheadController.text = widget.study.name;
    _degreeController.text = widget.study.degree;
    _startDateController.text = parseDate(widget.study.since);
    _endDateController.text = parseDate(widget.study.until);
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _degreeController.dispose();
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
      title: Text('Editar Formacion'),
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
                    return val.isNotEmpty ? null : "Este campo es obligatorio";
                  },
                  suggestionsCallback: (String suggestion) {
                    setState(() {
                      institute = suggestion;
                    });
                    return _studyService.getInstitutes(suggestion);
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
                      labelText: "Nombre de Institucion",
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
                  controller: _degreeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: "Titulo",
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
                    return val != null ? null : "Este campo es obligatorio";
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
                    labelText: "Fecha de Inicio",
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
                          : "La fecha de fin debe ser mayor a la de inicio";
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
                    labelText: "Fecha de Fin",
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
            'CANCELAR',
            style: TextStyle(color: Colors.grey),
          ),
          style: TextButton.styleFrom(primary: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Study study = Study.fromJson({
              "id": instituteId,
              "name": institute,
              "degree": degree,
              "since": _startDate == null
                  ? widget.study.since
                  : _startDate.toIso8601String(),
              "until": _endDate == null
                  ? widget.study.until
                  : _endDate.toIso8601String(),
            });
            widget.updateStudy(study, widget.index);
            Navigator.pop(context);
          },
          child: Text(
            'EDITAR',
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
