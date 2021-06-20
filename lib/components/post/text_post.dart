import 'package:flutter/material.dart';
import 'package:mobile/models/post.dart';

class TextPost extends StatelessWidget {
  final Post post;
  final List<Widget> content;

  const TextPost({Key key, this.post, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: content,
          ),
        ),
      ),
    );
  }
}
