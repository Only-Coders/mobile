import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String img;
  final String title;
  final String message;
  final Widget action;

  const NoData({Key key, this.img, this.title, this.message, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            img,
            width: 125,
          ),
          SizedBox(
            height: 15,
          ),
          if (title != null)
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(
            height: 5,
          ),
          if (message != null)
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          SizedBox(
            height: 10,
          ),
          if (action != null) action
        ],
      ),
    );
  }
}
