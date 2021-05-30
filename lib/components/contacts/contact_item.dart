import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/services/person.dart';

class ContactItem extends StatefulWidget {
  final Person contact;
  final remove;

  const ContactItem({Key key, this.contact, this.remove}) : super(key: key);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  final PersonService _personService = PersonService();
  final Toast _toast = Toast();
  bool followed = false;
  bool added = false;

  Future<void> followContact() async {
    try {
      await _personService.followPerson(widget.contact.canonicalName);
      setState(() {
        followed = true;
      });
      _toast.showSuccess(context, AppLocalizations.of(context).followMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> unfollowContact() async {
    try {
      await _personService.unfollowPerson(widget.contact.canonicalName);
      setState(() {
        followed = false;
      });
      _toast.showSuccess(context, AppLocalizations.of(context).unfollowMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> sendContactRequest() async {
    try {
      await _personService.sendContactRequest(widget.contact.canonicalName);
      setState(() {
        added = true;
      });
      _toast.showSuccess(
          context, AppLocalizations.of(context).sendContactRequestMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  Future<void> cancelContactRequest() async {
    try {
      await _personService.cancelContactRequest(widget.contact.canonicalName);
      setState(() {
        added = false;
      });
      _toast.showSuccess(
          context, AppLocalizations.of(context).cancelContactRequestMessage);
    } catch (error) {
      _toast.showError(context, error.response.data["error"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: double.infinity,
      child: Card(
        shape: Border(left: BorderSide(color: Colors.orange, width: 5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage("assets/images/default-avatar.png"),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contact.canonicalName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            widget.contact.currentPosition == null
                                ? ""
                                : "${widget.contact.currentPosition.workplace.name} ${widget.contact.currentPosition.position}",
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: -15,
                    right: -15,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        widget.remove(widget.contact);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 25,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (followed) {
                            await unfollowContact();
                          } else {
                            await followContact();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1),
                        ),
                        child: Text(
                          followed
                              ? AppLocalizations.of(context).unfollow
                              : AppLocalizations.of(context).follow,
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (added) {
                            await cancelContactRequest();
                          } else {
                            await sendContactRequest();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        child: Text(
                          added
                              ? AppLocalizations.of(context)
                                  .cancelContactRequest
                              : AppLocalizations.of(context).add,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
