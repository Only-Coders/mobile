import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

  Future<String> downloadFile(String url) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.refFromURL(url);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${ref.name}');
    print("${appDocDir.path}/${ref.name}");
    await ref.writeToFile(downloadToFile);
    return "${appDocDir.path}/${ref.name}";
  }

  String getFileName(String url) {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.refFromURL(url);
    return ref.name;
  }
}
