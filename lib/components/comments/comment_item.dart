import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/components/post/post_parser.dart';
import 'package:mobile/components/post/text_post.dart';
import 'package:mobile/models/comment.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/theme/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String ownerCanonicalName;
  final String postId;
  final removeComment;

  const CommentItem({
    Key key,
    @required this.comment,
    @required this.ownerCanonicalName,
    @required this.postId,
    @required this.removeComment,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final PostService _postService = PostService();
  final PostParser _postParser = PostParser();
  final Toast _toast = Toast();
  int approvedAmount = 0;
  int rejectedAmount = 0;
  bool disabledApprove = false;
  bool disabledReject = false;
  String myReaction;

  Future<void> reactToComment(String reaction) async {
    setState(() {
      this.disabledApprove = reaction == "REJECT";
      this.disabledReject = reaction == "APPROVE";
    });
    if (reaction == this.myReaction) {
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
        if (this.myReaction != null) {
          setState(() {
            this.rejectedAmount--;
          });
        }
      } else {
        setState(() {
          this.rejectedAmount++;
        });
        if (this.myReaction != null) {
          setState(() {
            this.approvedAmount--;
          });
        }
      }
    }
    setState(() {
      this.myReaction = reaction;
    });
    await _postService.reactToComment(widget.comment.id, reaction);
    setState(() {
      this.disabledApprove = false;
      this.disabledReject = false;
    });
  }

  @override
  void initState() {
    setState(() {
      this.myReaction = widget.comment.myReaction;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    List<Widget> widgets =
        _postParser.parsePost(context, widget.comment.message, [], []);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: widget.comment.publisher.imageURI.isEmpty
              ? AssetImage("assets/images/default-avatar.png")
              : NetworkImage(widget.comment.publisher.imageURI),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: currentTheme.currentTheme == ThemeMode.light
                  ? Colors.grey.shade200
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              canonicalName:
                                  widget.comment.publisher.canonicalName,
                            ),
                          ),
                        ),
                        child: Text(
                          "${widget.comment.publisher.firstName} ${widget.comment.publisher.lastName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (context.read<User>().canonicalName ==
                            widget.comment.publisher.canonicalName ||
                        context.read<User>().canonicalName ==
                            widget.ownerCanonicalName)
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).accentColor,
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  await _postService.removeComment(
                                      widget.postId, widget.comment.id);
                                  widget.removeComment(widget.comment);
                                  _toast.showSuccess(
                                      context, t.deleteCommentMessage);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  _toast.showError(context, t.serverError);
                                }
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(
                                  t.delete,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (widget.comment.publisher.currentPosition != null)
                  Text(
                    "${widget.comment.publisher.currentPosition.position} ${widget.comment.publisher.currentPosition.workplace.name}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: TextPost(
                    content: widgets,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: disabledApprove
                          ? null
                          : () async => await reactToComment('APPROVE'),
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: myReaction == "APPROVE"
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                        minimumSize: Size(10, 10),
                      ),
                      label: Text(
                        (widget.comment.reactions[0].quantity + approvedAmount)
                            .toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_up_sharp,
                        size: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: disabledReject
                          ? null
                          : () async => await reactToComment('REJECT'),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).errorColor,
                        backgroundColor: myReaction == "REJECT"
                            ? Theme.of(context).errorColor.withOpacity(0.1)
                            : null,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(10, 10),
                      ),
                      label: Text(
                        (widget.comment.reactions[1].quantity + rejectedAmount)
                            .toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
