import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/components/contacts/contact_item.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/services/person.dart';

class SuggestedContacts extends StatefulWidget {
  const SuggestedContacts({Key key}) : super(key: key);

  @override
  _SuggestedContactsState createState() => _SuggestedContactsState();
}

class _SuggestedContactsState extends State<SuggestedContacts> {
  final PersonService _personService = PersonService();
  Future getContacts;
  List<Person> contacts = [];

  void removeContact(Person contact) {
    setState(() {
      contacts.remove(contact);
    });
  }

  Future<List<Person>> fetchContacts() async {
    try {
      contacts = await _personService.getSuggestedContacts();
    } catch (error) {
      Navigator.pushReplacementNamed(context, "/login");
    }
    return contacts;
  }

  @override
  void initState() {
    getContacts = fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    Widget listTags() {
      return Container(
        height: MediaQuery.of(context).size.height - 325,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new Column(
            children: contacts
                .map((contact) =>
                    ContactItem(contact: contact, remove: removeContact))
                .toList(),
          ),
        ),
      );
    }

    Widget finishButton() {
      return ElevatedButton(
        child: Text(t.finish),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/feed");
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: TextStyle(fontSize: 16),
          primary: Theme.of(context).primaryColor, // background
        ),
      );
    }

    return FutureBuilder(
        future: getContacts,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height - 80,
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              t.suggestedContacts,
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(t.suggestedContactsDescription),
                            SizedBox(
                              height: 35,
                            ),
                            snapshot.data != 0
                                ? listTags()
                                : SvgPicture.asset(
                                    "assets/images/contacts.svg",
                                    width: 180,
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            finishButton(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 80,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.grey.shade200),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
