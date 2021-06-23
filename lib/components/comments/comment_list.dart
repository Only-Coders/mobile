import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/comments/comment_item.dart';
import 'package:mobile/models/comment.dart';
import 'package:mobile/theme/themes.dart';

class CommentList extends StatefulWidget {
  final List<Comment> comments;
  final String ownerCanonicalName;
  final String postId;
  final updateCommentsQty;

  const CommentList({
    Key key,
    @required this.comments,
    @required this.ownerCanonicalName,
    @required this.postId,
    @required this.updateCommentsQty,
  }) : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<Comment> comments;

  void removeComment(Comment comment) {
    setState(() {
      comments.remove(comment);
    });
    widget.updateCommentsQty(comments.length);
  }

  @override
  void initState() {
    setState(() {
      comments = widget.comments;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: currentTheme.currentTheme == ThemeMode.light
            ? Colors.white
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.comments,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CommentItem(
                  comment: comments[index],
                  ownerCanonicalName: widget.ownerCanonicalName,
                  postId: widget.postId,
                  removeComment: removeComment,
                ),
              );
            },
            itemCount: comments.length,
          ),
        ],
      ),
    );
  }
}
