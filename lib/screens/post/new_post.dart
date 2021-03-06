import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/components/post/add_link.dart';
import 'package:mobile/components/post/link_preview.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/models/tag.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/fb_storage.dart';
import 'package:mobile/services/link_preview.dart';
import 'package:mobile/services/person.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/services/tag.dart';
import 'package:mobile/theme/themes.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class NewPost extends StatefulWidget {
  final refreshFeed;
  final Post post;

  const NewPost({Key key, this.refreshFeed, this.post}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final PostService _postService = PostService();
  final PersonService _personService = PersonService();
  final TagService _tagService = TagService();
  final LinkPreviewService _linkPreviewService = LinkPreviewService();
  final FirebaseStorage _firebaseStorage = FirebaseStorage();
  final Toast _toast = Toast();
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  List<String> _postPrivacy = ["To anyone", "To my contacts"];
  String selectedPostPrivacy;
  String message = "";
  String type = "TEXT";
  bool isLoading = false;
  File _image;
  File _file;
  String postUrl = "";
  Future previewLink;
  bool showMentions = false;
  final imagePicker = ImagePicker();
  Link linkPreview;
  List<Person> mentions = [];
  List<Tag> tags = [];
  List<Map<String, dynamic>> mentionCanonicalNames = [];
  List<String> tagNames = [];

  Future<void> getImage(bool camera) async {
    final image = await imagePicker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 25);
    if (image != null) {
      int bytes = File(image.path).lengthSync();
      if ((bytes / 1000 / 1000) < 1) {
        setState(() {
          type = "IMAGE";
          _image = File(image.path);
        });
      }
    }
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

  Future<List<Person>> getUsersByFullName(String name) async {
    List<Person> users = [];
    try {
      users = await _personService.getPersonsByFullName(name);
    } catch (error) {
      print(error);
    }
    return users;
  }

  Future<void> getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      int bytes = file.lengthSync();
      if ((bytes / 1000 / 1000) < 5) {
        setState(() {
          type = "FILE";
          _file = file;
        });
      }
    }
  }

  void addCodeSnippet() {
    String snippet = "\n```javascript\n\n```";
    key.currentState.controller.text = message + snippet;
    setState(() {
      message = message + snippet;
    });
  }

  void addLinkPreview(Link link) {
    setState(() {
      type = "LINK";
      linkPreview = link;
    });
  }

  void removeLinkPreview() {
    setState(() {
      type = "TEXT";
      linkPreview = null;
      postUrl = "";
    });
  }

  void addNewTags() {
    RegExp regex = new RegExp(r'(?<!\S)#(\w+)(\s|$)');
    var matches = regex.allMatches(message);
    setState(() {
      tagNames = [];
    });
    matches.forEach((match) {
      setState(() {
        tagNames.add(match.group(1));
      });
    });
  }

  Future<void> editPost() async {
    try {
      setState(() {
        isLoading = true;
      });
      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(
              cacheControl: 'public,max-age=4000');
      if (_image != null) {
        postUrl = await _firebaseStorage.uploadFile(
            _image, "images/${Uuid().v4()}", metadata);
      }
      if (_file != null) {
        postUrl = await _firebaseStorage.uploadFile(
            _file, "files/${Uuid().v4()}", metadata);
      }
      if (linkPreview != null && type == "LINK") {
        postUrl = linkPreview.url;
      }
      List<Map<String, dynamic>> filteredMentions = mentionCanonicalNames
          .where((mention) => message.contains("@${mention['display']}"))
          .toList();

      List<String> mentionsNames = filteredMentions.map((element) {
        message =
            message.replaceAll("@${element['display']}", "@${element['id']}");
        return element["id"] as String;
      }).toList();

      addNewTags();
      Provider.of<User>(context, listen: false)
          .setDefaultPrivacy(selectedPostPrivacy == "To anyone");
      await _postService.editPost(widget.post.id, message, type,
          selectedPostPrivacy == "To anyone", postUrl, mentionsNames, tagNames);
      setState(() {
        isLoading = false;
      });
      _toast.showSuccess(context, AppLocalizations.of(context).editPostMessage);
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> newPost() async {
    try {
      setState(() {
        isLoading = true;
      });
      String uri = "";
      if (_image != null) {
        uri =
            await _firebaseStorage.uploadFile(_image, "images/${Uuid().v4()}");
      }
      if (_file != null) {
        uri = await _firebaseStorage.uploadFile(_file, "files/${Uuid().v4()}");
      }
      if (linkPreview != null && type == "LINK") {
        uri = linkPreview.url;
      }
      List<Map<String, dynamic>> filteredMentions = mentionCanonicalNames
          .where((mention) => message.contains("@${mention['display']}"))
          .toList();

      List<String> mentionsNames = filteredMentions.map((element) {
        message =
            message.replaceAll("@${element['display']}", "@${element['id']}");
        return element["id"] as String;
      }).toList();

      addNewTags();
      Provider.of<User>(context, listen: false)
          .setDefaultPrivacy(selectedPostPrivacy == "To anyone");
      await _postService.createPost(message, type,
          selectedPostPrivacy == "To anyone", uri, mentionsNames, tagNames);
      setState(() {
        isLoading = false;
      });
      _toast.showSuccess(
          context, AppLocalizations.of(context).newPostOkMessage);
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _toast.showError(context, error.response.data["error"]);
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      message = widget.post.message;
      type = widget.post.type;
      postUrl = widget.post.url;
      if (widget.post.mentions.isNotEmpty) {
        mentionCanonicalNames = widget.post.mentions.map((mention) {
          message = message.replaceAll("@${mention.canonicalName}",
              "@${mention.firstName} ${mention.lastName}");
          return {
            "display": '${mention.firstName} ${mention.lastName}',
            "id": mention.canonicalName
          };
        }).toList();
      }
      previewLink = _linkPreviewService.previewLink(widget.post.url);
      selectedPostPrivacy =
          widget.post.isPublic ? "To anyone" : "To my contacts";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    User user = Provider.of<User>(context);

    return Portal(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          brightness: Brightness.dark,
          title: Text(
            widget.post != null ? t.editPost : t.newPost,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            widget.post != null
                ? TextButton(
                    onPressed: () async {
                      await editPost();
                    },
                    style: TextButton.styleFrom(primary: Colors.white),
                    child: isLoading
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.grey.shade200),
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            t.edit,
                            style: TextStyle(color: Colors.white),
                          ),
                  )
                : TextButton(
                    onPressed: () async {
                      await newPost();
                    },
                    style: TextButton.styleFrom(primary: Colors.white),
                    child: isLoading
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.grey.shade200),
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            t.publish,
                            style: TextStyle(color: Colors.white),
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
                                  backgroundImage: user.imageURI == null ||
                                          user.imageURI.isEmpty
                                      ? AssetImage(
                                          "assets/images/default-avatar.png")
                                      : NetworkImage(user.imageURI),
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
                                          user.fullName,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
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
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        p == "To anyone"
                                                            ? t.toAnyone
                                                            : t.toMyContacts,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                      ),
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
                                          value: selectedPostPrivacy != null
                                              ? selectedPostPrivacy
                                              : Provider.of<User>(context)
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
                                    defaultText: message,
                                    suggestionPosition:
                                        SuggestionPosition.Bottom,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (val) {
                                      setState(() {
                                        message = val;
                                      });
                                    },
                                    maxLines: null,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintText: t.newPostMessage,
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).accentColor),
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
                                      if (mention["type"] == null) {
                                        setState(() {
                                          mentionCanonicalNames.add(mention);
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
                                              color:
                                                  Theme.of(context).cardColor,
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
                                              color:
                                                  Theme.of(context).cardColor,
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                  linkPreview != null
                                      ? LinkPreview(
                                          link: linkPreview,
                                          removeLink: removeLinkPreview,
                                        )
                                      : Container(),
                                  if (type == "LINK" && postUrl.isNotEmpty)
                                    FutureBuilder(
                                        future: previewLink,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              return LinkPreview(
                                                link: snapshot.data,
                                                removeLink: removeLinkPreview,
                                              );
                                            }
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SkeletonAnimation(
                                                  shimmerColor: currentTheme
                                                              .currentTheme ==
                                                          ThemeMode.light
                                                      ? Colors.grey[400]
                                                      : Colors.grey[800],
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  shimmerDuration: 1000,
                                                  child: Container(
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: currentTheme
                                                                  .currentTheme ==
                                                              ThemeMode.light
                                                          ? Colors.grey[200]
                                                          : Colors.grey[800],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: currentTheme
                                                                      .currentTheme ==
                                                                  ThemeMode
                                                                      .light
                                                              ? Colors.grey[200]
                                                              : Colors
                                                                  .grey[850],
                                                          blurRadius: 15,
                                                        )
                                                      ],
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 5),
                                                  ),
                                                ),
                                                SkeletonAnimation(
                                                  shimmerColor: currentTheme
                                                              .currentTheme ==
                                                          ThemeMode.light
                                                      ? Colors.grey[400]
                                                      : Colors.grey[800],
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  shimmerDuration: 1000,
                                                  child: Container(
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: currentTheme
                                                                  .currentTheme ==
                                                              ThemeMode.light
                                                          ? Colors.grey[200]
                                                          : Colors.grey[800],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: currentTheme
                                                                      .currentTheme ==
                                                                  ThemeMode
                                                                      .light
                                                              ? Colors.grey[200]
                                                              : Colors
                                                                  .grey[850],
                                                          blurRadius: 15,
                                                        )
                                                      ],
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  if (type == "IMAGE" && postUrl.isNotEmpty)
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          child: Image.network(postUrl),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.grey.shade800),
                                              child: IconButton(
                                                splashRadius: 20,
                                                onPressed: () {
                                                  setState(() {
                                                    postUrl = "";
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
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).accentColor,
                                ),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT" || type == "IMAGE"
                                    ? () async {
                                        await getImage(false);
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.image,
                                  color: Theme.of(context).accentColor,
                                ),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT" || type == "FILE"
                                    ? () async {
                                        await getFile();
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Theme.of(context).accentColor,
                                ),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT" || type == "LINK"
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              AddLink(addLink: addLinkPreview),
                                          barrierDismissible: true,
                                        );
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.link,
                                  color: Theme.of(context).accentColor,
                                ),
                                splashRadius: 20,
                              ),
                              IconButton(
                                onPressed: type == "TEXT"
                                    ? () {
                                        addCodeSnippet();
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.code,
                                  color: Theme.of(context).accentColor,
                                ),
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
