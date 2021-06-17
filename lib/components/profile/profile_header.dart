import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String imageURI;

  const ProfileHeader({Key key, @required this.imageURI}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      width: double.infinity,
      height: 100,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 35,
            child: CircleAvatar(
              radius: 63,
              backgroundColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imageURI.isEmpty
                    ? AssetImage("assets/images/default-avatar.png")
                    : NetworkImage(imageURI),
              ),
            ),
          )
        ],
      ),
    );
  }
}
