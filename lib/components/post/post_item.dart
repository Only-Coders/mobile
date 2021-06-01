import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/components/post/file_post.dart';
import 'package:mobile/components/post/image_post.dart';
import 'package:mobile/components/post/link_post.dart';
import 'package:mobile/components/post/text_post.dart';
import 'package:mobile/models/post.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/post.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({Key key, this.post}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

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
          style: TextStyle(color: Colors.black.withOpacity(0.8)),
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
                          backgroundImage: widget
                                  .post.publisher.imageURI.isEmpty
                              ? AssetImage("assets/images/default-avatar.png")
                              : NetworkImage(widget.post.publisher.imageURI),
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
                PopupMenuButton(
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    widget.post.isFavorite == true
                        ? PopupMenuItem(
                            value: widget.post.isFavorite,
                            padding: EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () async {
                                await _postService
                                    .removeFromFavorite(widget.post.id);
                                setState(() {
                                  widget.post.isFavorite = false;
                                });
                                Toast().showSuccess(
                                    context, t.removeFromFavoriteMessage);
                              },
                              child: ListTile(
                                leading: Icon(Icons.bookmark_remove),
                                title: Text(t.remove),
                              ),
                            ),
                          )
                        : PopupMenuItem(
                            padding: EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () async {
                                await _postService
                                    .addToFavorite(widget.post.id);
                                setState(() {
                                  widget.post.isFavorite = true;
                                });
                                print(widget.post.isFavorite);
                                Toast().showSuccess(
                                    context, t.addToFavoriteMessage);
                              },
                              child: ListTile(
                                leading: Icon(Icons.bookmark_add),
                                title: Text(
                                  t.save,
                                ),
                              ),
                            ),
                          ),
                    PopupMenuItem(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        leading: Icon(Icons.policy),
                        title: Text(
                          t.report,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Flexible(child: postType(widget.post.type, widgets)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
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
                                  widget.post.reactions[0].quantity.toString(),
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
                                  widget.post.reactions[1].quantity.toString(),
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
                  Text(widget.post.commentQuantity.toString() + t.comments),
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

  Widget postType(String type, List<Widget> widgets) {
    switch (type) {
      case "TEXT":
        return TextPost(
          post: widget.post,
          content: widgets,
        );
        break;
      case "IMAGE":
        return ImagePost(
          post: widget.post,
          content: widgets,
        );
        break;
      case "FILE":
        return FilePost(
          post: widget.post,
          content: widgets,
        );
        break;
      case "LINK":
        return LinkPost(
          post: widget.post,
          content: widgets,
        );
        break;
      default:
        return Text("Tipo no encontrado");
        break;
    }
  }
}
