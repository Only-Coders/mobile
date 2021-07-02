import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/models/message.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/utils/date_formatter.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  const ChatMessage({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: context.read<User>().canonicalName == message.from
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: context.read<User>().canonicalName == message.from
                  ? EdgeInsets.only(left: 45)
                  : EdgeInsets.only(right: 45),
              decoration: BoxDecoration(
                color: Color(0xff00C2A3),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomLeft: context.read<User>().canonicalName == message.from
                      ? Radius.circular(10)
                      : Radius.circular(0),
                  bottomRight:
                      context.read<User>().canonicalName == message.from
                          ? Radius.circular(0)
                          : Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 4),
              child: Column(
                crossAxisAlignment:
                    context.read<User>().canonicalName == message.from
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    DateFormatter().getVerboseDateTime(
                      new DateTime.fromMicrosecondsSinceEpoch(
                          message.time * 1000),
                    ),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
