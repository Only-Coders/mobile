import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/services/person.dart';

class ProfileContactItem extends StatelessWidget {
  final Person contact;
  final refreshContacts;

  const ProfileContactItem(
      {Key key, @required this.contact, this.refreshContacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PersonService _personService = PersonService();
    var t = AppLocalizations.of(context);

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            canonicalName: contact.canonicalName,
          ),
        ),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: contact.imageURI.isEmpty
            ? AssetImage("assets/images/default-avatar.png")
            : NetworkImage(contact.imageURI),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        "${contact.firstName} ${contact.lastName}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: contact.currentPosition != null
          ? Text(
              "${contact.currentPosition.position} ${t.at} ${contact.currentPosition.workplace.name}",
              style: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.6),
                fontSize: 12,
              ),
            )
          : Container(),
      trailing: ElevatedButton(
        onPressed: () async {
          try {
            await _personService.removeMyContact(contact.canonicalName);
            refreshContacts();
            Toast().showSuccess(context, t.removeContactsMessage);
          } catch (error) {
            Toast().showError(context, t.serverError);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).errorColor,
        ),
        child: Text(
          t.remove,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
