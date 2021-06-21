import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/services/post.dart';

class DeletePost extends StatelessWidget {
  final String postId;
  final refreshPosts;

  const DeletePost(
      {Key key, @required this.postId, @required this.refreshPosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        t.removePost,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: Container(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(t.removePostMessage)],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            primary: Theme.of(context).accentColor,
          ),
          child: Text(
            t.cancel.toUpperCase(),
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            final Toast _toast = Toast();
            final PostService _postService = PostService();

            try {
              await _postService.removePost(postId);
              this.refreshPosts(context);
              _toast.showSuccess(context, t.removePostSuccess);
              Navigator.pop(context);
            } catch (error) {
              _toast.showError(context, t.serverError);
            }
          },
          style: TextButton.styleFrom(
            primary: Colors.orange,
          ),
          child: Text(
            t.remove.toUpperCase(),
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
