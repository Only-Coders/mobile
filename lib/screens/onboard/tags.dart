import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/tags/tag_item.dart';
import 'package:mobile/models/tag.dart';
import 'package:mobile/services/tag.dart';

class Tags extends StatefulWidget {
  final increment;

  const Tags({Key key, this.increment}) : super(key: key);

  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final TagService _tagService = TagService();
  List<Tag> tags = [];
  Future getTags;

  void removeTag(Tag tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Future<List<Tag>> fetchTags() async {
    try {
      tags = await _tagService.getTags();
    } catch (error) {
      Navigator.pushReplacementNamed(context, "/login");
    }
    return tags;
  }

  @override
  void initState() {
    getTags = fetchTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    Widget listTags() {
      return Container(
        height: MediaQuery.of(context).size.height - 325,
        child: SingleChildScrollView(
          child: new Column(
            children: tags
                .map((tag) => TagItem(
                      tag: tag,
                      removeTag: removeTag,
                    ))
                .toList(),
          ),
        ),
      );
    }

    Widget nextButton() {
      return ElevatedButton(
        child: Text(
          t.next,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          widget.increment();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: TextStyle(fontSize: 16),
          primary: Theme.of(context).primaryColor, // background
        ),
      );
    }

    return FutureBuilder(
        future: getTags,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height - 80,
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              t.tags,
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(t.tagsDescription),
                            SizedBox(
                              height: 35,
                            ),
                            snapshot.data != 0
                                ? listTags()
                                : SvgPicture.asset(
                                    "assets/images/tags.svg",
                                    width: 180,
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            nextButton(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 80,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.grey.shade200),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
