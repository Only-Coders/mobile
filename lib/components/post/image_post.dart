import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/models/post.dart';

class ImagePost extends StatelessWidget {
  final Post post;
  final List<Widget> content;

  const ImagePost({Key key, @required this.post, this.content})
      : super(key: key);

  List<Widget> getContent() {
    List<Widget> formatedContent = content.map((item) => item).toList();
    formatedContent.add(
      new Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            post.url,
          ),
        ),
      ),
    );
    return formatedContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getContent(),
        ),
      ),
    );
  }
}
