import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileQtyInfo extends StatelessWidget {
  final int postQty;
  final int followerQty;
  final int follwingQty;
  final bool isMyProfile;

  const ProfileQtyInfo(
      {Key key,
      @required this.postQty,
      @required this.followerQty,
      @required this.follwingQty,
      @required this.isMyProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Row(
        children: [
          SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "$postQty",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  textAlign: TextAlign.center,
                ),
                Text(
                  t.posts,
                  style: TextStyle(
                    color: Theme.of(context).accentColor.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "$followerQty",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  textAlign: TextAlign.center,
                ),
                Text(
                  t.followers,
                  style: TextStyle(
                    color: Theme.of(context).accentColor.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: isMyProfile
                  ? () => Navigator.of(context).pushNamed("/profile/followers")
                  : null,
              child: Column(
                children: [
                  Text(
                    "$follwingQty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    t.following,
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }
}
