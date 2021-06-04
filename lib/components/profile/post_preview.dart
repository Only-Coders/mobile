import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class PostPreview extends StatelessWidget {
  final String canonicalName;

  const PostPreview({Key key, this.canonicalName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    var t = AppLocalizations.of(context);

    return FutureBuilder(
      future: _postService.getPostsByUser(canonicalName),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 65),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.posts,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final List<Post> posts = snapshot.data as List<Post>;

            return Container(
              margin: EdgeInsets.only(top: 65),
              width: double.infinity,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.posts,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).accentColor),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Center(
                          child: posts.length == 0
                              ? Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/no-data.png",
                                      width: 128,
                                    ),
                                    Text(
                                      t.postsNoData,
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    PostItem(
                                      post: posts[0],
                                    )
                                  ],
                                ),
                        ),
                      ),
                      if (posts.length > 1)
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/profile/posts");
                            },
                            style: TextButton.styleFrom(primary: Colors.orange),
                            child: Text(t.seeMore),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Container(
          margin: EdgeInsets.only(top: 65),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.posts,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
