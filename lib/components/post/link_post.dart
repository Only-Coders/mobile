import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/post/link_preview.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/link_preview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LinkPost extends StatefulWidget {
  final Post post;
  final List<Widget> content;

  const LinkPost({Key key, @required this.post, this.content})
      : super(key: key);

  @override
  _LinkPostState createState() => _LinkPostState();
}

class _LinkPostState extends State<LinkPost> {
  final LinkPreviewService _linkPreviewService = LinkPreviewService();
  Future renderContent;
  RegExp regExp = new RegExp(
    r"^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.*",
    multiLine: true,
  );

  Future<List<Widget>> getContent() async {
    List<Widget> formatedContent = widget.content.map((item) => item).toList();
    if (regExp.hasMatch(widget.post.url)) {
      try {
        String videoID = YoutubePlayer.convertUrlToId(widget.post.url);
        formatedContent.add(YoutubePlayerBuilder(
          player: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: YoutubePlayerController(
              initialVideoId: videoID,
              flags: YoutubePlayerFlags(
                hideControls: false,
                controlsVisibleAtStart: true,
                autoPlay: false,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) => Column(
            children: [
              player,
            ],
          ),
        ));
        return formatedContent;
      } catch (error) {
        Link linkPreview =
            await _linkPreviewService.previewLink(widget.post.url);
        formatedContent.add(new LinkPreview(link: linkPreview));
        return formatedContent;
      }
    } else {
      Link linkPreview = await _linkPreviewService.previewLink(widget.post.url);
      formatedContent.add(new LinkPreview(link: linkPreview));
      return formatedContent;
    }
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
