import 'package:flutter/material.dart';
import 'package:mobile/models/work.dart';
import 'package:mobile/models/workplace.dart';
import 'package:mobile/services/work.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";

class AddWorkExperience extends StatefulWidget {
  final addWork;

  const AddWorkExperience({Key key, this.addWork}) : super(key: key);

  @override
  _AddWorkExperienceState createState() => _AddWorkExperienceState();
}

class _AddWorkExperienceState extends State<AddWorkExperience> {
  final WorkService _workService = WorkService();
  String position = "";
  String workplace = "";
  String workplaceId = "";
  DateTime _startDate;
  DateTime _endDate;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      title: Text('Agregar experiencia'),
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
                    return val.isNotEmpty ? null : "Este campo es obligatorio";
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
            'AGREGAR',
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
