import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Toast {
  void showError(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Theme.of(context).errorColor,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).close,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  void showSuccess(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).close,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  void showInfo(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.blue,
        action: SnackBarAction(
          textColor: Colors.white,
          label: AppLocalizations.of(context).close,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}
