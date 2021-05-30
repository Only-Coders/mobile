import 'package:flutter/material.dart';
import 'package:mobile/components/generic/bottom_nav.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class Feed extends StatelessWidget {
  const Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: FutureBuilder(
        future: _postService.getFeedPosts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.data.map<Widget>((Post p) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: PostItem(
                        post: p,
                      ),
                    );
                  }).toList(),
                ),
              );
              // return PostItem(post: snapshot.data[0]);
            } else {
              return Container(
                child: Center(
                  child: Text(
                    '${snapshot.error} occured',
                  ),
                ),
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
      bottomNavigationBar: BottomNav(),
    );
  }
}
