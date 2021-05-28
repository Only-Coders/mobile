import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/contact.dart';
import 'package:mobile/models/tag.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/fb_storage.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/services/tag.dart';
import 'package:mobile/services/user.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  final TagService _tagService = TagService();
  final FirebaseStorage _firebaseStorage = FirebaseStorage();
  final Toast _toast = Toast();
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  List<String> _postPrivacy = ["To anyone", "To my contacts"];
  String selectedPostPrivacy;
  String message = "";
  String type = "TEXT";
  File _image;
  File _file;
  bool showMentions = false;
  final imagePicker = ImagePicker();
  List<Contact> mentions = [];
  List<Tag> tags = [];
  List<String> mentionCanonicalNames = [];
  List<String> tagNames = [];

  Future<void> getImage(bool camera) async {
    final image = await imagePicker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 25);
    if (image != null)
      setState(() {
        _image = File(image.path);
      });
  }

  Future<List<Tag>> getTags(String name) async {
    List<Tag> tags = [];
    try {
      tags = await _tagService.getTags(name);
    } catch (error) {
      print(error);
    }
    return tags;
  }

  Future<List<Contact>> getUsersByFullName(String name) async {
    List<Contact> users = [];
    try {
      users = await _userService.getUsersByFullName(name);
    } catch (error) {
      print(error);
    }
    return users;
  }

  Future<void> getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        _file = file;
      });
    }
  }

  void addCodeSnippet() {
    String snippet = "\n```javascript\n\n```";
    key.currentState.controller.text = message + snippet;
    setState(() {
      message = message + snippet;
    });
  }

  Future<void> newPost() async {
    try {
      String uri = "";
      if (_image != null) {
        uri = await _firebaseStorage.uploadFile(_image, "images/");
      }
      if (_file != null) {
        uri = await _firebaseStorage.uploadFile(_file, "files/");
      }
      await _postService.createPost(
          message,
          type,
          selectedPostPrivacy == "To anyone",
          uri,
          mentionCanonicalNames,
          tagNames);
      Provider.of<User>(context, listen: false)
          .setDefaultPrivacy(selectedPostPrivacy == "To anyone");
      _toast.showSuccess(context, "Se compartio la publicacion");
    } catch (error) {
      print(error);
      _toast.showError(context, error.response.data["error"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    selectedPostPrivacy = Provider.of<User>(context).defaultPrivacy
        ? "To anyone"
        : "To my contacts";

    return Portal(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(
            "New Post",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await newPost();
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: Text(
                "Publish",
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (_) {
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                      "assets/images/default-avatar.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "Mathias Zunino",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.grey.shade600,
                                              style: BorderStyle.solid,
                                              width: 0.80),
                                        ),
                                        child: DropdownButton(
                                          items: _postPrivacy
                                              .map(
                                                (p) => DropdownMenuItem(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        p == "To anyone"
                                                            ? Icons.vpn_lock
                                                            : Icons.person,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(p == "To anyone"
                                                          ? t.toAnyone
                                                          : t.toMyContacts),
                                                    ],
                                                  ),
                                                  value: p,
                                                ),
                                              )
                                              .toList(),
                                          isDense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPostPrivacy = value;
                                            });
                                            Provider.of<User>(context,
                                                    listen: false)
                                                .setDefaultPrivacy(
                                                    selectedPostPrivacy ==
                                                        "To anyone");
                                          },
                                          value: Provider.of<User>(context)
                                                  .defaultPrivacy
                                              ? "To anyone"
                                              : "To my contacts",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                children: [
                                  FlutterMentions(
                                    key: key,
                                    suggestionPosition:
                                        SuggestionPosition.Bottom,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (val) {
                                      setState(() {
                                        message = val;
                                      });
                                    },
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintText: t.newPostMessage,
                                    ),
                                    onSearchChanged:
                                        (String trigger, String value) async {
                                      if (trigger == "@") {
                                        var users =
                                            await getUsersByFullName(value);
                                        setState(() {
                                          mentions = users;
                                        });
                                      } else {
                                        var tagList = await getTags(value);
                                        setState(() {
                                          tags = tagList;
                                        });
                                      }
                                    },
                                    onMentionAdd: (mention) {
                                      if (mention["type"] == "TAG") {
                                        setState(() {
                                          tagNames.add(mention["id"]);
                                        });
                                      } else {
                                        setState(() {
                                          mentionCanonicalNames
                                              .add(mention["id"]);
                                        });
                                      }
                                    },
                                    mentions: [
                                      Mention(
                                          trigger: "#",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                          data: tags
                                              .map((t) => {
                                                    "id": t.canonicalName,
                                                    "display": t.canonicalName,
                                                    "type": "TAG"
                                                  })
                                              .toList(),
                                          suggestionBuilder: (data) {
                                            return Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                          '#${data['display']}'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                      Mention(
                                          trigger: "@",
                                          style: TextStyle(color: Colors.blue),
                                          data: mentions
                                              .map((e) => {
                                                    "id": e.canonicalName,
                                                    "display":
                                                        '${e.firstName} ${e.lastName}',
                                                    "imageURI": e.imageURI
                                                  })
                                              .toList(),
                                          suggestionBuilder: (data) {
                                            return Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundImage: data[
                                                                'imageURI'] ==
                                                            ""
                                                        ? AssetImage(
                                                            "assets/images/default-avatar.png")
                                                        : NetworkImage(
                                                            data['imageURI'],
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Text(data['id']),
                                                      Text(
                                                          '@${data['display']}'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                  _image != null
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              child: Image.file(_image),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color:
                                                          Colors.grey.shade800),
                                                  child: IconButton(
                                                    splashRadius: 20,
                                                    onPressed: () {
                                                      setState(() {
                                                        _image = null;
                                                        type = "TEXT";
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _file != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file,
                                      size: 48,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _file = null;
                                            type = "TEXT";
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.red),
                                        child: Text(
                                          "Remover",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      path.basename(_file.path),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: type == "TEXT" || type == "IMAGE"
                                    ? () async {
                                        await getImage(true);
                                        setState(() {
                                          type = "IMAGE";
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.camera_alt),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT" || type == "IMAGE"
                                    ? () async {
                                        await getImage(false);
                                        setState(() {
                                          type = "IMAGE";
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.image),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT" || type == "FILE"
                                    ? () async {
                                        await getFile();
                                        setState(() {
                                          type = "FILE";
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.attach_file),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT"
                                    ? () {
                                        addCodeSnippet();
                                      }
                                    : null,
                                icon: Icon(Icons.code),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
