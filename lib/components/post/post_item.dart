import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/components/post/file_post.dart';
import 'package:mobile/components/post/image_post.dart';
import 'package:mobile/components/post/link_post.dart';
import 'package:mobile/components/post/post_parser.dart';
import 'package:mobile/components/post/text_post.dart';
import 'package:mobile/models/post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/theme/themes.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({Key key, this.post}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PostService _postService = PostService();
  final PostParser _postParser = PostParser();
  bool disabledApprove = false;
  bool disabledReject = false;
  int bronceMedals = 0;
  int silverMedals = 0;
  int goldMedals = 0;
  int approvedAmount = 0;
  int rejectedAmount = 0;

  void calculateMedals(int approves) {
    int bronce = approves % 5;
    approves = (approves - bronce) ~/ 5;
    int silver = approves % 5;
    int gold = (approves - silver) ~/ 5;
    setState(() {
      bronceMedals = bronce;
      silverMedals = silver;
      goldMedals = gold;
    });
  }

  Future<void> reactToPost(String reaction) async {
    setState(() {
      this.disabledApprove = reaction == "REJECT";
      this.disabledReject = reaction == "APPROVE";
    });
    if (reaction == widget.post.myReaction) {
      if (reaction == "APPROVE") {
        setState(() {
          this.approvedAmount--;
        });
      } else {
        setState(() {
          this.rejectedAmount--;
        });
      }
      reaction = null;
    } else {
      if (reaction == "APPROVE") {
        setState(() {
          this.approvedAmount++;
        });
        if (widget.post.myReaction != null) {
          setState(() {
            this.rejectedAmount--;
          });
        }
      } else {
        setState(() {
          this.rejectedAmount++;
        });
        if (widget.post.myReaction != null) {
          setState(() {
            this.approvedAmount--;
          });
        }
      }
    }
    widget.post.myReaction = reaction;
    await _postService.reactToPost(widget.post.id, reaction);
    setState(() {
      this.disabledApprove = false;
      this.disabledReject = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    List<Widget> widgets = _postParser.parsePost(
        context, widget.post.message, widget.post.tags, widget.post.mentions);

    calculateMedals(widget.post.publisher.amountOfMedals);

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
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: widget
                                  .post.publisher.imageURI.isEmpty
                              ? AssetImage("assets/images/default-avatar.png")
                              : NetworkImage(widget.post.publisher.imageURI),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(
                                        canonicalName:
                                            widget.post.publisher.canonicalName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "${widget.post.publisher.firstName} ${widget.post.publisher.lastName}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                "assets/images/gold-medal.png",
                                width: 12,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                goldMedals.toString(),
                                style: TextStyle(fontSize: 11),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Image.asset(
                                "assets/images/silver-medal.png",
                                width: 12,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                silverMedals.toString(),
                                style: TextStyle(fontSize: 11),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Image.asset(
                                "assets/images/bronce-medal.png",
                                width: 12,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                bronceMedals.toString(),
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          if (widget.post.publisher.currentPosition != null)
                            Text(
                              "${widget.post.publisher.currentPosition.workplace.name} ${widget.post.publisher.currentPosition.position}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).accentColor,
                  ),
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
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.bookmark_remove,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(
                                  t.removeFavorite,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
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
                                Toast().showSuccess(
                                    context, t.addToFavoriteMessage);
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.bookmark_add,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(
                                  t.save,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    PopupMenuItem(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        leading: Icon(
                          Icons.policy,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text(
                          t.report,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            postType(widget.post.type, widgets),
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
                          child: OutlinedButton.icon(
                            onPressed: disabledApprove
                                ? null
                                : () async => await reactToPost('APPROVE'),
                            icon: Icon(
                              Icons.arrow_drop_up_sharp,
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: widget.post.myReaction ==
                                      "APPROVE"
                                  ? currentTheme.currentTheme == ThemeMode.light
                                      ? Color(0xffD2F6F1)
                                      : Color(0xff1e353b)
                                  : null,
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.4),
                                  width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            label: Text(
                              (widget.post.reactions[0].quantity +
                                      approvedAmount)
                                  .toString(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 25,
                          child: OutlinedButton.icon(
                            onPressed: disabledApprove
                                ? null
                                : () async => await reactToPost('REJECT'),
                            icon: Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Colors.red,
                            ),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.red,
                              backgroundColor: widget.post.myReaction ==
                                      "REJECT"
                                  ? currentTheme.currentTheme == ThemeMode.light
                                      ? Color(0xffFEE3E1)
                                      : Color(0xff291818)
                                  : null,
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.4),
                                  width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            label: Text(
                              (widget.post.reactions[1].quantity +
                                      rejectedAmount)
                                  .toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.post.commentQuantity.toString() + t.comments,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
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
                        Icon(
                          Icons.message,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          "Comentar",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
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
