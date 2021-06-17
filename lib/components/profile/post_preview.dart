import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/screens/post/profile_posts.dart';
import 'package:mobile/services/post.dart';

class PostPreview extends StatefulWidget {
  final String canonicalName;

  const PostPreview({Key key, this.canonicalName}) : super(key: key);

  @override
  _PostPreviewState createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  final PostService _postService = PostService();
  Future getPostPreview;

  void refreshPostPreview() {
    setState(() {});
  }

  @override
  void initState() {
    getPostPreview = _postService.getPostsByUser(widget.canonicalName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.orange,
              ),
              height: 10,
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                t.posts,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: getPostPreview,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final List<Post> posts = snapshot.data as List<Post>;

                    if (posts.isEmpty) {
                      return NoData(
                        message: t.postsNoData,
                        img: "assets/images/no-data.png",
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            PostItem(
                              post: posts[0],
                            ),
                            if (posts.length > 1)
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: OutlinedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePosts(
                                        canonicalName: widget.canonicalName,
                                      ),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(t.seeMore),
                                ),
                              )
                          ],
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return ServerError(
                      refresh: refreshPostPreview,
                    );
                  }
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
