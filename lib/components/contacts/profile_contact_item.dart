import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: contact.imageURI.isEmpty
                    ? AssetImage("assets/images/default-avatar.png")
                    : NetworkImage(contact.imageURI),
                backgroundColor: Colors.transparent,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${contact.firstName} ${contact.lastName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${contact.currentPosition.position} ${contact.currentPosition.workplace.name}",
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _personService.removeMyContact(contact.canonicalName);
                    refreshContacts();
                    Toast().showSuccess(context, t.removeContactsMessage);
                  } catch (error) {
                    Toast().showSuccess(context, t.serverError);
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
            ],
          ),
        ),
      ),
    );
  }
}
