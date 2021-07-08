import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/utils/consts/consts.dart';

class FirebaseStorage {
  Future<String> uploadFile(File file, String fileName,
      [firebase_storage.SettableMetadata metadata]) async {
    if (metadata == null)
      metadata = firebase_storage.SettableMetadata(
          cacheControl: 'private, max-age=0, no-transform');
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file, metadata);
    String fileURI = Constants.bucket + fileName;
    return fileURI;
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
