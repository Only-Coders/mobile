import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart' as path;

class FirebaseStorage {
  Future<String> uploadFile(File image, String folder) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(folder + path.basename(image.path));
    String imageURI;
    await ref.putFile(image).whenComplete(() async {
      imageURI = await ref.getDownloadURL();
    });
    return imageURI;
  }
}
