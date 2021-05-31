import 'package:flutter/material.dart';
import 'package:mobile/models/link.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatelessWidget {
  final Link link;
  final removeLink;

  const LinkPreview({Key key, @required this.link, @required this.removeLink})
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      link.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      splashRadius: 25,
                      onPressed: removeLink,
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(link.description),
                ),
                link.img != null ? Image.network(link.img) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
