import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class ProfilePosts extends StatelessWidget {
  final String canonicalName;

  const ProfilePosts({Key key, this.canonicalName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _postService.getPostsByUser(canonicalName),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                final List<Post> posts = snapshot.data as List<Post>;
                return Column(
                  children: posts.map((post) => PostItem(post: post)).toList(),
                );
              }
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
