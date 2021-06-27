import 'package:flutter/material.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/screens/profile/profile.dart';
import 'package:mobile/services/person.dart';

class ProfileFollowerItem extends StatelessWidget {
  final Person person;
  final refreshFollowings;

  const ProfileFollowerItem({Key key, this.person, this.refreshFollowings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            canonicalName: person.canonicalName,
          ),
        ),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: person.imageURI.isEmpty
            ? AssetImage("assets/images/default-avatar.png")
            : NetworkImage(person.imageURI),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        "${person.firstName} ${person.lastName}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: person.currentPosition != null
          ? Text(
              "${person.currentPosition.position} ${person.currentPosition.workplace.name}",
              style: TextStyle(
                color: Theme.of(context).accentColor.withOpacity(0.6),
                fontSize: 12,
              ),
            )
          : Container(),
      trailing: ElevatedButton(
        onPressed: () async {
          final Toast _toast = Toast();
          final PersonService _personService = PersonService();

          try {
            await _personService.unfollowPerson(person.canonicalName);
            this.refreshFollowings();
            _toast.showSuccess(
                context, AppLocalizations.of(context).unfollowMessage);
          } catch (error) {
            _toast.showError(context, error.response.data["error"]);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        child: Text(
          t.unfollow,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
