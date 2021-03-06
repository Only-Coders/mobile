import 'package:flutter/material.dart';
import 'package:mobile/components/comments/comment_list.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/comment.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/models/reaction.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewComment extends StatefulWidget {
  final Post post;
  final bool isNewComment;
  final int aprrovedAmount;
  final int rejectedAmount;

  const NewComment(
      {Key key,
      @required this.post,
      this.isNewComment,
      this.aprrovedAmount,
      this.rejectedAmount})
      : super(key: key);

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final PostService _postService = PostService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _messageController = TextEditingController();
  final Toast _toast = Toast();
  Post post;
  Future getComments;
  String comment = "";
  bool isLoading = false;
  bool newCommentIsOpen = false;
  List<Comment> comments = [];

  void refreshComment() {
    setState(() {});
  }

  void addCodeSnippet() {
    String snippet = "\n```javascript\n\n```";
    _messageController.text = comment + snippet;
    setState(() {
      comment = comment + snippet;
    });
  }

  void updateCommentsQty(int qty) {
    setState(() {
      post.commentQuantity = qty;
    });
  }

  Future<void> newComment(BuildContext context) async {
    if (comment.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        Comment data = await _postService.newComment(comment, widget.post.id);
        setState(() {
          comments.insert(0, data);
          post.commentQuantity++;
        });
        Navigator.of(context).pop();
        _toast.showSuccess(context, "Se creo el comentario correctamente");
      } catch (error) {
        print(error);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showNewComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scaffoldKey.currentState.showBottomSheet(
        (context) => Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1.5,
                color: currentTheme.currentTheme == ThemeMode.light
                    ? Colors.grey.shade200
                    : Theme.of(context).cardColor,
              ),
            ),
            color: currentTheme.currentTheme == ThemeMode.light
                ? Colors.white
                : Theme.of(context).cardColor,
          ),
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: context.read<User>().imageURI.isEmpty
                      ? AssetImage("assets/images/default-avatar.png")
                      : NetworkImage(context.read<User>().imageURI),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      maxLines: null,
                      controller: _messageController,
                      onChanged: (val) {
                        setState(() {
                          comment = val;
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
                        labelText: AppLocalizations.of(context).leaveAComment,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => addCodeSnippet(),
                  icon: Icon(Icons.code),
                ),
                isLoading
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
                    : IconButton(
                        onPressed: () async => newComment(context),
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    getComments = _postService.getComments(widget.post.id);
    post = widget.post;
    post.reactions[0] = Reaction(
        reaction: post.reactions[0].reaction,
        quantity: post.reactions[0].quantity + widget.aprrovedAmount);
    post.reactions[1] = Reaction(
        reaction: post.reactions[1].reaction,
        quantity: post.reactions[1].quantity + widget.rejectedAmount);
    if (widget.isNewComment) showNewComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: getComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              comments = snapshot.data;
              return ListView(
                children: [
                  PostItem(
                    post: post,
                    isNewComment: true,
                    openNewComment: showNewComment,
                  ),
                  CommentList(
                    ownerCanonicalName: post.publisher.canonicalName,
                    comments: comments,
                    postId: post.id,
                    updateCommentsQty: updateCommentsQty,
                  ),
                ],
              );
            } else {
              return ServerError(
                refresh: refreshComment,
              );
            }
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
