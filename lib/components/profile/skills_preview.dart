import 'package:flutter/material.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/models/skill.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/services/skill.dart';
import 'package:provider/provider.dart';

class SkillsPreview extends StatefulWidget {
  final String canonicalName;

  const SkillsPreview({Key key, this.canonicalName}) : super(key: key);

  @override
  _SkillsPreviewState createState() => _SkillsPreviewState();
}

class _SkillsPreviewState extends State<SkillsPreview> {
  final PersonService _personService = PersonService();
  final SkillService _skillService = SkillService();
  Future getSkills;

  void refreshSkillExperience() {
    setState(() {});
  }

  @override
  void initState() {
    getSkills = _personService.getPersonSkills(widget.canonicalName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.orange,
              ),
              height: 10,
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                t.skills,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder(
              future: getSkills,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Skill> skills = snapshot.data;

                    if (skills.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          children: skills
                              .map((skill) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Chip(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.green.shade400,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      deleteIcon: Icon(
                                        Icons.close_rounded,
                                        color: Colors.green.shade400,
                                        size: 15,
                                      ),
                                      label: Text(
                                        skill.name,
                                        style: TextStyle(
                                            color: Colors.green.shade400),
                                      ),
                                      onDeleted: widget.canonicalName ==
                                              context.read<User>().canonicalName
                                          ? () async {
                                              await _skillService.removeSkill(
                                                  skill.canonicalName);
                                              setState(() {
                                                skills.remove(skill);
                                              });
                                            }
                                          : null,
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    } else {
                      return NoData(
                        message: "No skills found",
                        img: "assets/images/no-data-contacts.png",
                      );
                    }
                  } else if (snapshot.hasError) {
                    return ServerError(
                      refresh: refreshSkillExperience,
                    );
                  }
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
