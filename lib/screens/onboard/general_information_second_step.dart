import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/screens/onboard/provider/register_model.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/auth.dart';

class GeneralInformationSecondStep extends StatefulWidget {
  final increment;

  const GeneralInformationSecondStep({Key key, this.increment})
      : super(key: key);

  @override
  _GeneralInformationSecondStepState createState() =>
      _GeneralInformationSecondStepState();
}

class _GeneralInformationSecondStepState
    extends State<GeneralInformationSecondStep> {
  final Toast _toast = Toast();
  final _auth = AuthService();
  File _image;
  bool isLoading = false;
  String platform = "GITHUB";
  String description = "";
  String imageURI = "";
  String userName = "";
  List<String> _platforms = ["GITHUB", "GITLAB", "BITBUCKET"];

  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (image != null)
      setState(() {
        _image = File(image.path);
      });
  }

  Future uploadFile() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/" + path.basename(_image.path));
    await ref.putFile(_image).whenComplete(() async {
      String image = await ref.getDownloadURL();
      setState(() {
        imageURI = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).generalInformation,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    AppLocalizations.of(context).generalInformationDescription),
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
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: DropdownButton(
                        items: _platforms.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [platformItem(p)],
                            ),
                          );
                        }).toList(),
                        underline: SizedBox(),
                        value: platform,
                        isExpanded: true,
                        onChanged: (val) {
                          setState(() {
                            platform = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      child: TextField(
                        onChanged: (val) {
                          userName = val;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: "ej: jose",
                          labelText: AppLocalizations.of(context).gitProfile,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
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
                    labelText: AppLocalizations.of(context).aboutYourSelf,
                    filled: true,
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
          )
        ],
      ),
    );
  }

  Widget platformItem(String platform) {
    switch (platform) {
      case "GITHUB":
        return SvgPicture.asset(
          "assets/images/github.svg",
          width: 30,
        );
      case "GITLAB":
        return SvgPicture.asset(
          "assets/images/gitlab.svg",
          width: 30,
        );
      default:
        return SvgPicture.asset(
          "assets/images/bitbucket.svg",
          width: 30,
        );
    }
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
          : Text(AppLocalizations.of(context).next),
      onPressed: () async {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          try {
            if (imageURI.isNotEmpty) await uploadFile();
            Provider.of<RegisterModel>(context, listen: false)
                .setSecondStepData(imageURI, description,
                    userName.isEmpty ? null : platform, userName);
            await _auth
                .register(Provider.of<RegisterModel>(context, listen: false));
            widget.increment();
          } on DioError catch (e) {
            _toast.showError(context, e.response.data["error"]);
            Navigator.pushReplacementNamed(context, "/login");
          } finally {
            setState(() {
              isLoading = false;
            });
          }
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
