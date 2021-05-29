import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/post.dart';
import 'package:provider/provider.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    String canonicalName = Provider.of<User>(context).canonicalName;
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
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(fontSize: 18),
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
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Center(
                        child: posts.length == 0
                            ? Column(
                                children: [
                                  Image.asset(
                                    "assets/images/no-data.png",
                                    width: 180,
                                  ),
                                  Text(
                                    t.postsNoData,
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text("Posts"),
                                ],
                              ),
                      ),
                      if (posts.length > 1)
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {},
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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