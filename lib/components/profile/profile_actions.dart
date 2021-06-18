import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileActions extends StatefulWidget {
  final bool requestHasBeenSent;
  final bool connected;
  final bool following;
  final bool pendingRequest;
  final String canonicalName;

  const ProfileActions(
      {Key key,
      this.requestHasBeenSent,
      this.connected,
      this.following,
      this.pendingRequest,
      this.canonicalName})
      : super(key: key);

  @override
  _ProfileActionsState createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  final PersonService _personService = PersonService();
  final Toast _toast = Toast();
  bool requestHasBeenSent;
  bool connected;
  bool following;
  bool pendingRequest;

  Future<void> followContact() async {
    try {
      await _personService.followPerson(widget.canonicalName);
      setState(() {
        following = true;
      });
      _toast.showSuccess(context, AppLocalizations.of(context).followMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> unfollowContact() async {
    try {
      await _personService.unfollowPerson(widget.canonicalName);
      setState(() {
        following = false;
      });
      _toast.showSuccess(context, AppLocalizations.of(context).unfollowMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> sendContactRequest() async {
    try {
      await _personService.sendContactRequest(widget.canonicalName);
      setState(() {
        requestHasBeenSent = true;
      });
      _toast.showSuccess(
          context, AppLocalizations.of(context).sendContactRequestMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> cancelContactRequest() async {
    try {
      await _personService.cancelContactRequest(widget.canonicalName);
      setState(() {
        requestHasBeenSent = false;
      });
      _toast.showSuccess(
          context, AppLocalizations.of(context).cancelContactRequestMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> acceptContactRequest() async {
    try {
      await _personService.acceptContactRequest(widget.canonicalName);
      setState(() {
        connected = true;
        requestHasBeenSent = false;
      });
      _toast.showSuccess(
          context, "Se acepto la solicitud de contacto correctamente");
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  @override
  void initState() {
    requestHasBeenSent = widget.requestHasBeenSent;
    connected = widget.connected;
    following = widget.following;
    pendingRequest = widget.pendingRequest;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Row(
        children: [
          if (!connected && !pendingRequest && !requestHasBeenSent)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async => sendContactRequest(),
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    "Add Contact",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (!connected &&
              pendingRequest &&
              widget.canonicalName != context.read<User>().canonicalName)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async => acceptContactRequest(),
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (!connected &&
              requestHasBeenSent &&
              widget.canonicalName != context.read<User>().canonicalName)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async => cancelContactRequest(),
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text(
                    "Cancel Request",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          if (!following)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () async => followContact(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  child: Text(
                    "Follow",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          if (following)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () async => unfollowContact(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  child: Text(
                    "Unfollow",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
