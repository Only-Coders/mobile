import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<String> _postPrivacy = ["To anyone", "To my contacts"];
  String selectedPostPrivacy = "To anyone";
  String message = "";

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          "New Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text(
              "Publish",
            ),
          ),
        ],
      ),
      body: Container(
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
                            backgroundImage:
                                AssetImage("assets/images/default-avatar.png"),
                            backgroundColor: Colors.transparent,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(15),
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
                                    },
                                    value: selectedPostPrivacy,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          onChanged: (val) {
                            setState(() {
                              message = val;
                            });
                          },
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
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(t.addHashtag),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.videocam_sharp),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.image),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {},
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
      ),
    );
  }
}
