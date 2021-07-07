import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/fb_storage.dart';
import 'package:mobile/services/person.dart';
import 'package:uuid/uuid.dart';

class ProfileHeader extends StatefulWidget {
  final String imageURI;
  final bool isMyProfile;

  const ProfileHeader(
      {Key key, @required this.imageURI, @required this.isMyProfile})
      : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final imagePicker = ImagePicker();
  final PersonService _personService = PersonService();
  final FirebaseStorage _firebaseStorage = FirebaseStorage();
  String imageURI;
  bool isLoading = false;
  File _image;

  Future getImage() async {
    final image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (image != null)
      setState(() {
        _image = File(image.path);
      });
  }

  String getFileName() {
    RegExp regExp = new RegExp(
      r"\/images\/(?<fileName>.*)",
      multiLine: true,
    );
    String fileName = regExp.firstMatch(imageURI).namedGroup("fileName");
    return fileName;
  }

  Future<void> updatePhoto() async {
    try {
      setState(() {
        isLoading = true;
      });
      String img = imageURI.isEmpty
          ? await _firebaseStorage.uploadFile(_image, "images/${Uuid().v4()}")
          : await _firebaseStorage.uploadFile(
              _image, "images/${getFileName()}");
      final NetworkImage provider = NetworkImage(img);
      await provider.evict();
      await _personService.updateUserPhoto(img);
      setState(() {
        _image = null;
        imageURI = img;
      });
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      imageURI = widget.imageURI;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: 0,
            bottom: 65,
            child: Container(
              color: Theme.of(context).secondaryHeaderColor,
              height: 100,
            ),
          ),
          Positioned(
            top: 35,
            child: !isLoading
                ? GestureDetector(
                    onTap: widget.isMyProfile ? () async => getImage() : null,
                    child: CircleAvatar(
                      radius: 63,
                      backgroundColor: Colors.grey.shade100,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _image != null
                            ? FileImage(_image)
                            : imageURI.isEmpty
                                ? AssetImage("assets/images/default-avatar.png")
                                : NetworkImage(imageURI),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 63,
                    backgroundColor: Colors.grey.shade100,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
          ),
          if (widget.isMyProfile && _image == null)
            Positioned(
              top: 115,
              child: Container(
                margin: EdgeInsets.only(left: 95),
                child: GestureDetector(
                  onTap: () async => getImage(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade100,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.isMyProfile && _image != null)
            Positioned(
              top: 115,
              child: Container(
                margin: EdgeInsets.only(left: 95),
                child: GestureDetector(
                  onTap: () async => updatePhoto(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade100,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.isMyProfile && _image != null)
            Positioned(
              top: 75,
              child: Container(
                margin: EdgeInsets.only(left: 125),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade100,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor:
                          Theme.of(context).errorColor.withOpacity(0.6),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
