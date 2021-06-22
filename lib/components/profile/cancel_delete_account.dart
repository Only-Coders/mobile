import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/services/person.dart';

class CancelDeleteAccount extends StatelessWidget {
  const CancelDeleteAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.cancelRemoveAccount,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
      content: Container(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              t.areYouSure,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            primary: Theme.of(context).accentColor,
          ),
          child: Text(
            t.cancel.toUpperCase(),
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            final Toast _toast = Toast();
            final PersonService _personService = PersonService();

            try {
              await _personService.cancelUserElimination();
              _toast.showSuccess(context, t.cancelRemoveAccountMessage);
              Navigator.pop(context);
            } catch (error) {
              _toast.showError(context, t.serverError);
            }
          },
          style: TextButton.styleFrom(
            primary: Colors.orange,
          ),
          child: Text(
            t.confirm.toUpperCase(),
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
