import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/models/post_tag.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/screens/tags/tag_posts.dart';
import 'package:flutter/services.dart';

class PostParser {
  Widget parseMention(
      BuildContext context, String mention, List<Person> mentions) {
    String canonicalName = mention.substring(1, mention.length);
    if (mentions.isNotEmpty) {
      Iterable<Person> iterable =
          mentions.where((element) => element.canonicalName == canonicalName);
      if (iterable.isNotEmpty) {
        Person person = iterable.first;
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    canonicalName: canonicalName,
                  ),
                ),
              );
            },
            child: Text(
              "@${person.firstName} ${person.lastName}",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            mention,
            style: TextStyle(
              color: Theme.of(context).accentColor.withOpacity(0.8),
            ),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(
          mention,
          style: TextStyle(
            color: Theme.of(context).accentColor.withOpacity(0.8),
          ),
        ),
      );
    }
  }

  Widget parseTag(BuildContext context, String tag, List<PostTag> tags) {
    String displayName = tag.substring(1, tag.length);

    if (tags.isNotEmpty) {
      Iterable<PostTag> iterable =
          tags.where((element) => element.displayName == displayName);
      if (iterable.isNotEmpty) {
        PostTag tag = iterable.first;
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TagPosts(
                    canonicalName: tag.canonicalName,
                  ),
                ),
              );
            },
            child: Text(
              "#${tag.displayName}",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            tag,
            style: TextStyle(
              color: Theme.of(context).accentColor.withOpacity(0.8),
            ),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(
          tag,
          style: TextStyle(
            color: Theme.of(context).accentColor.withOpacity(0.8),
          ),
        ),
      );
    }
  }

  Widget parseCode(String code, String lang) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            HighlightView(
              code,
              language: lang,
              theme: tomorrowNightTheme,
              padding: EdgeInsets.all(20),
              textStyle: TextStyle(
                fontSize: 10,
              ),
            ),
            Positioned(
              right: -8,
              top: -8,
              child: IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                },
                splashRadius: 20,
                icon: Icon(
                  Icons.copy,
                  size: 22,
                  color: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color(0xff1d1f21),
              width: 4.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    );
  }

  List<Widget> parsePost(BuildContext context, String message,
      List<PostTag> tags, List<Person> mentions) {
    RegExp regExp = new RegExp(
      r"(^```(?<lang>[\w\W]*?)\n(?<code>[^`][\W\w]*?)\n```$)|((?<!\S)(?<tag>#\w+)(\s|$))|((?<!\S)(?<mention>@\w+-\w{5})(\s|$))",
      multiLine: true,
    );
    List<Widget> widgets = [];
    int pos = 0;

    for (var x in regExp.allMatches(message)) {
      if (message.substring(pos, x.start).contains("\n")) {
        if (message.substring(pos, x.start).indexOf("\n") > 0) {
          widgets.add(
            Text(
              message.substring(
                pos,
                pos + message.substring(pos, x.start).indexOf("\n"),
              ),
              style: TextStyle(
                  color: Theme.of(context).accentColor.withOpacity(0.8)),
            ),
          );
          widgets.add(
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.substring(
                        pos + message.substring(pos, x.start).indexOf("\n") + 1,
                        x.start),
                    style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          );
        } else {
          widgets.add(
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.substring(pos, x.start),
                    style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        widgets.add(
          Text(
            message.substring(pos, x.start),
            style: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.8)),
          ),
        );
      }
      if (x.namedGroup("code") != null)
        widgets.add(
          parseCode(
            x.namedGroup("code"),
            x.namedGroup("lang"),
          ),
        );
      if (x.namedGroup("tag") != null) {
        widgets.add(
          parseTag(context, x.namedGroup("tag"), tags),
        );
      }
      if (x.namedGroup("mention") != null) {
        widgets.add(
          parseMention(context, x.namedGroup("mention"), mentions),
        );
      }
      pos = x.end;
    }
    if (pos < message.length) {
      widgets.add(
        Text(
          message.substring(pos, message.length),
          style: TextStyle(
            color: Theme.of(context).accentColor.withOpacity(0.8),
          ),
        ),
      );
    }
    return widgets;
  }
}
