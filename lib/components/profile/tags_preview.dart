import 'package:flutter/material.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/models/tag.dart';
import 'package:mobile/screens/tags/tag_posts.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TagsPreview extends StatefulWidget {
  final String canonicalName;

  const TagsPreview({Key key, this.canonicalName}) : super(key: key);

  @override
  _TagsPreviewState createState() => _TagsPreviewState();
}

class _TagsPreviewState extends State<TagsPreview> {
  final PersonService _personService = PersonService();
  Future getTags;

  void refreshTags() {
    setState(() {});
  }

  @override
  void initState() {
    getTags = _personService.getPersonTags(widget.canonicalName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.orange,
              ),
              height: 10,
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                t.tags,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: getTags,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Tag> tags = snapshot.data;

                    if (tags.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          children: tags
                              .map((tag) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Card(
                                      elevation: 0,
                                      child: TextButton.icon(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TagPosts(
                                              canonicalName: tag.canonicalName,
                                            ),
                                          ),
                                        ),
                                        icon: Icon(Icons.tag),
                                        label: Text(
                                          tag.canonicalName,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    } else {
                      return NoData(
                        message: "No tags found",
                        img: "assets/images/no-data.png",
                      );
                    }
                  } else if (snapshot.hasError) {
                    return ServerError(
                      refresh: refreshTags,
                    );
                  }
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
