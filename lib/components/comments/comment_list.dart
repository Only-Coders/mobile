import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/comments/comment_item.dart';
import 'package:mobile/models/comment.dart';

class CommentList extends StatelessWidget {
  final List<Comment> comments;

  const CommentList({Key key, @required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white),
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
                child: CommentItem(comment: comments[index]),
              );
            },
            itemCount: comments.length,
          ),
        ],
      ),
    );
  }
}
