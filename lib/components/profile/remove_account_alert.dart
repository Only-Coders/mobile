import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/providers/user.dart';
import 'package:provider/provider.dart';

class RemoveAccountAlert extends StatelessWidget {
  const RemoveAccountAlert({Key key}) : super(key: key);

  String parseDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return date.toLocal().toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25, right: 15, left: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.3),
        border: Border(
          left: BorderSide(
            width: 5,
            color: Color(0xffff9800),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber,
            size: 28,
            color: Color(0xffff9800),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              "${t.removeAccountAlert} ${parseDate(context.read<User>().eliminationDate)}",
              style: TextStyle(
                color: Color(0xffff9800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
