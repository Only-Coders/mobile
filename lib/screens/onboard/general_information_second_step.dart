import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class GeneralInformationSecondStep extends StatefulWidget {
  @override
  _GeneralInformationSecondStepState createState() =>
      _GeneralInformationSecondStepState();
}

class _GeneralInformationSecondStepState
    extends State<GeneralInformationSecondStep> {
  File _image;

  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadFile() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/" + path.basename(_image.path));
    await ref.putFile(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: 40,
          ),
          InkWell(
            onTap: () async {
              await getImage();
            },
            child: _image == null
                ? CircleAvatar(
                    radius: 55,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 38,
                    ),
                  )
                : CircleAvatar(
                    radius: 55,
                    backgroundImage: FileImage(_image),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            onChanged: (val) {
              print(val);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              labelText: "Perfil de git",
              filled: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (val) {},
            maxLines: 4,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              labelText: "Cuentanos sobre ti",
              filled: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              skipButton(),
              SizedBox(
                width: 20,
              ),
              nextButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      child: Text('Siguiente'),
      onPressed: () async {
        await uploadFile();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }

  Widget skipButton() {
    return OutlinedButton(
      child: Text(
        'Omitir',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
