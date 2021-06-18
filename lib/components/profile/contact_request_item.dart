import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/person.dart';

class ContactRequestItem extends StatefulWidget {
  final refresh;
  final String message;
  final Person contact;

  const ContactRequestItem({Key key, this.contact, this.refresh, this.message})
      : super(key: key);

  @override
  _ContactRequestItemState createState() => _ContactRequestItemState();
}

class _ContactRequestItemState extends State<ContactRequestItem> {
  final PersonService _personService = PersonService();
  final Toast _toast = Toast();

  Future<void> cancelContactRequest(String canonicalName) async {
    try {
      await _personService.cancelContactRequest(canonicalName);
      widget.refresh();
      _toast.showSuccess(
          context, AppLocalizations.of(context).cancelContactRequestMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> acceptContactRequest(String canonicalName) async {
    try {
      await _personService.acceptContactRequest(canonicalName);
      widget.refresh();
      _toast.showSuccess(
          context, "Se acepto la solicitud de contacto correctamente");
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: widget.contact.imageURI.isEmpty
            ? AssetImage("assets/images/default-avatar.png")
            : NetworkImage(widget.contact.imageURI),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        "${widget.contact.firstName} ${widget.contact.lastName}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: widget.contact.currentPosition != null
          ? Text(
              widget.message != null
                  ? ""
                  : "${widget.contact.currentPosition.position} ${widget.contact.currentPosition.workplace.name}",
              style: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.6),
                fontSize: 12,
              ),
            )
          : Container(),
      trailing: Wrap(
        children: [
          SizedBox(
            width: 70,
            height: 30,
            child: ElevatedButton(
              onPressed: () async =>
                  cancelContactRequest(widget.contact.canonicalName),
              style: ElevatedButton.styleFrom(primary: Colors.grey.shade300),
              child: Text(
                t.cancel,
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 70,
            height: 30,
            child: ElevatedButton(
              onPressed: () async =>
                  acceptContactRequest(widget.contact.canonicalName),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
