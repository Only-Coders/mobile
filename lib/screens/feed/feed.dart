import 'package:flutter/material.dart';
import 'package:mobile/components/generic/bottom_nav.dart';
import 'package:mobile/components/post/post_item.dart';
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
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _postService.getFeedPosts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return PostItem(post: snapshot.data[0]);
            } else {
              return Text("Hola");
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
