import 'package:flutter/material.dart';
import 'package:mobile/models/work.dart';
import 'package:mobile/models/workplace.dart';
import 'package:mobile/services/work.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";

class EditWorkExperience extends StatefulWidget {
  final updateWork;
  final Work work;
  final int index;

  const EditWorkExperience({Key key, this.work, this.updateWork, this.index})
      : super(key: key);

  @override
  _EditWorkExperienceState createState() => _EditWorkExperienceState();
}

class _EditWorkExperienceState extends State<EditWorkExperience> {
  final WorkService _workService = WorkService();
  String position = "";
  String workplace = "";
  String workplaceId = "";
  DateTime _startDate;
  DateTime _endDate;
  final _positionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final TextEditingController _typeAheadController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      workplace = widget.work.name;
      workplaceId = widget.work.id;
      position = widget.work.position;
    });
    _typeAheadController.text = widget.work.name;
    _positionController.text = widget.work.position;
    _startDateController.text = parseDate(widget.work.since);
    _endDateController.text = parseDate(widget.work.until);
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _positionController.dispose();
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
      title: Text('Editar experiencia'),
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
                    return val.isNotEmpty ? null : "Este campo es obligatorio";
                  },
                  suggestionsCallback: (String suggestion) {
                    setState(() {
                      workplace = suggestion;
                    });
                    return _workService.getWorkplaces(suggestion);
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
                      labelText: "Nombre de trabajo",
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
                  controller: _positionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: "Posicion",
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
            Work work = Work.fromJson({
              "id": workplaceId,
              "name": workplace,
              "position": position,
              "since": _startDate == null
                  ? widget.work.since
                  : _startDate.toIso8601String(),
              "until": _endDate == null
                  ? widget.work.until
                  : _endDate.toIso8601String(),
            });
            widget.updateWork(work, widget.index);
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
