import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Theme.of(context).errorColor),
          SizedBox(
            width: 5,
          ),
          Text(
            t.removeAccount,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
      content: Container(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.removeAccountMessage,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
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
              int eliminationDate = await _personService.removeMyAccount();
              context.read<User>().setEliminationDate(eliminationDate);
              _toast.showInfo(context, t.removeAccountInfo);
              Navigator.pop(context);
            } catch (error) {
              _toast.showError(context, t.serverError);
            }
          },
          style: TextButton.styleFrom(
            primary: Colors.orange,
          ),
          child: Text(
            t.remove.toUpperCase(),
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
