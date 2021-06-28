import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/post/link_preview.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/link_preview.dart';
import 'package:mobile/theme/themes.dart';
import 'package:skeleton_text/skeleton_text.dart';
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
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
            ],
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
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SkeletonAnimation(
                    shimmerColor: currentTheme.currentTheme == ThemeMode.light
                        ? Colors.grey[400]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(35),
                    shimmerDuration: 1000,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: currentTheme.currentTheme == ThemeMode.light
                            ? Colors.grey[200]
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: currentTheme.currentTheme == ThemeMode.light
                                ? Colors.grey[200]
                                : Colors.grey[850],
                            blurRadius: 15,
                          )
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    ),
                  ),
                  SkeletonAnimation(
                    shimmerColor: currentTheme.currentTheme == ThemeMode.light
                        ? Colors.grey[400]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(35),
                    shimmerDuration: 1000,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: currentTheme.currentTheme == ThemeMode.light
                            ? Colors.grey[200]
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: currentTheme.currentTheme == ThemeMode.light
                                ? Colors.grey[200]
                                : Colors.grey[850],
                            blurRadius: 15,
                          )
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    ),
                  ),
                ],
              ),
            );
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
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SkeletonAnimation(
                shimmerColor: Colors.grey[400],
                borderRadius: BorderRadius.circular(35),
                shimmerDuration: 1000,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                ),
              ),
              SkeletonAnimation(
                shimmerColor: Colors.grey[400],
                borderRadius: BorderRadius.circular(35),
                shimmerDuration: 1000,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
