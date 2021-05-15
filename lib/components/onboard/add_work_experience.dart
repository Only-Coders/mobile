import 'package:flutter/material.dart';

class AddWorkExperience extends StatefulWidget {
  const AddWorkExperience({Key key}) : super(key: key);

  @override
  _AddWorkExperienceState createState() => _AddWorkExperienceState();
}

class _AddWorkExperienceState extends State<AddWorkExperience> {
  String position = "";
  String name = "";
  DateTime _startDate;
  DateTime _endDate;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String parseDate(String date) {
    List<String> splitedDate = date.split("-");
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
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {},
                validator: (val) {
                  return val.isNotEmpty ? null : "Este campo es obligatorio";
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
                onChanged: (val) {},
                validator: (val) {
                  return val.isNotEmpty ? null : "Este campo es obligatorio";
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
              TextField(
                readOnly: true,
                controller: _startDateController,
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
              TextField(
                readOnly: true,
                controller: _endDateController,
                onTap: () async {
                  DateTime date = await showDatePicker(
                      context: context,
                      initialDate: _endDate == null ? DateTime.now() : _endDate,
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
          onPressed: () {},
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
