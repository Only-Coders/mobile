import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/fb_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilePost extends StatelessWidget {
  final Post post;
  final List<Widget> content;

  const FilePost({Key key, @required this.post, this.content})
      : super(key: key);

  List<Widget> getContent(BuildContext context) {
    final FirebaseStorage _firebaseStorage = FirebaseStorage();
    List<Widget> formatedContent = content.map((item) => item).toList();
    formatedContent.add(
      new Tooltip(
        message: AppLocalizations.of(context).download.toString(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  String path = await _firebaseStorage.downloadFile(post.url);
                  Toast().showInfo(context, path);
                },
                child: Icon(
                  Icons.insert_drive_file,
                  size: 48,
                  color: Colors.blue,
                ),
              ),
              Text(
                _firebaseStorage.getFileName(post.url),
              ),
            ],
          ),
        ),
      ),
    );
    return formatedContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getContent(context),
        ),
      ),
    );
  }
}
