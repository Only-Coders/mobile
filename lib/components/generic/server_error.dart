import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServerError extends StatelessWidget {
  final refresh;

  const ServerError({Key key, @required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/server-error.svg",
          width: 220,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          t.somethingWentWrong,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        SizedBox(
          height: 10,
        ),
        Text(t.unknownError),
        Text(t.tryAgainMessage),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(15),
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => refresh(),
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            label: Text(
              t.tryAgain,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
