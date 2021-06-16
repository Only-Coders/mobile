import 'package:flutter/material.dart';
import 'package:mobile/components/post/link_preview.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/link_preview.dart';

class LinkPost extends StatefulWidget {
  final Post post;
  final List<Widget> content;

  const LinkPost({Key key, @required this.post, this.content})
      : super(key: key);

  @override
  _LinkPostState createState() => _LinkPostState();
}

class _LinkPostState extends State<LinkPost> {
  Future renderContent;

  Future<List<Widget>> getContent() async {
    LinkPreviewService _linkPreviewService = LinkPreviewService();
    List<Widget> formatedContent = widget.content.map((item) => item).toList();
    Link linkPreview = await _linkPreviewService.previewLink(widget.post.url);
    formatedContent.add(new LinkPreview(link: linkPreview));
    return formatedContent;
  }

  @override
  void initState() {
    renderContent = getContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: renderContent,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
              ),
            );
          } else {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    children: snapshot.data,
                  ),
                ),
              ),
            );
          }
        }
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width - 8,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }
}
