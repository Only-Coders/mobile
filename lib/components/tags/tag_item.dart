import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/tag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/tag.dart';

class TagItem extends StatelessWidget {
  final Tag tag;
  final removeTag;

  const TagItem({Key key, this.tag, this.removeTag}) : super(key: key);

  Future<void> followTag(BuildContext context) async {
    try {
      TagService _tagService = TagService();
      await _tagService.followTag(tag.canonicalName);
      removeTag(tag);
    } catch (error) {
      Toast().showError(context, AppLocalizations.of(context).serverError);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: double.infinity,
      child: Card(
        shape: Border(left: BorderSide(color: Colors.orange, width: 5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag.canonicalName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        tag.followerQuantity.toString() + t.followsTags,
                        style: TextStyle(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.6),
                            fontSize: 12),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await followTag(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                    ),
                    child: Text(
                      t.follow,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
