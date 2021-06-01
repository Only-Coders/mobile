import 'package:flutter/material.dart';
import 'package:mobile/models/link.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatelessWidget {
  final Link link;
  final removeLink;

  const LinkPreview({Key key, @required this.link, this.removeLink})
      : super(key: key);

  Future<void> launchUrl() async {
    if (link.url.isNotEmpty && await canLaunch(link.url)) {
      await launch(link.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: launchUrl,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                link.img != null
                    ? Container(
                        width: 95,
                        child: Image.network(link.img),
                      )
                    : Container(),
                Flexible(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              link.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          if (removeLink != null)
                            IconButton(
                              splashRadius: 25,
                              onPressed: removeLink,
                              icon: Icon(Icons.close),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(link.description),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
