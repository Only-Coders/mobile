import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProfileQtyInfo extends StatelessWidget {
  final int postQty;
  final int followerQty;
  final int contactQty;
  final bool isMyProfile;

  const ProfileQtyInfo(
      {Key key,
      @required this.postQty,
      @required this.followerQty,
      @required this.contactQty,
      @required this.isMyProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  "Posts",
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
                  "Followers",
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
                  ? () => Navigator.of(context).pushNamed("/profile/contacts")
                  : null,
              child: Column(
                children: [
                  Text(
                    "$contactQty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Contacts",
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
