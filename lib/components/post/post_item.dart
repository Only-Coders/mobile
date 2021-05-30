import 'package:flutter/material.dart';
import 'package:mobile/models/post.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({Key key, this.post}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    RegExp regExp = new RegExp(
      r"^```(?<lang>[\w\W]*?)\n(?<code>[^`][\W\w]*?)\n```$",
      multiLine: true,
    );
    List<Widget> widgets = [];
    int pos = 0;

    for (var x in regExp.allMatches(widget.post.message)) {
      widgets.add(
        Text(
          widget.post.message.substring(pos, x.start),
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      );
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Container(
            child: HighlightView(
              x.namedGroup("code"),
              language: x.namedGroup("lang"),
              theme: vs2015Theme,
              padding: EdgeInsets.all(10),
              textStyle: TextStyle(
                fontSize: 10,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xFF000000),
                  width: 4.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
      );
      pos = x.end;
    }
    if (pos < widget.post.message.length) {
      widgets.add(
        Text(
          widget.post.message.substring(pos, widget.post.message.length),
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("assets/images/default-avatar.png"),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "${widget.post.publisher.firstName} ${widget.post.publisher.lastName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (widget.post.publisher.currentPosition != null)
                            Text(
                                "${widget.post.publisher.currentPosition.workplace} ${widget.post.publisher.currentPosition.position}"),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgets,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 25,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_sharp,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 25,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.red,
                                ),
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("4 Comentarios"),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(primary: Colors.black54),
                    child: Row(
                      children: [
                        Icon(Icons.message),
                        Text("Comentar"),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
