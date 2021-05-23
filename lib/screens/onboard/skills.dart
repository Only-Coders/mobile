import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/skill.dart';
import 'package:mobile/services/skill.dart';

class Skills extends StatefulWidget {
  final increment;

  const Skills({Key key, this.increment}) : super(key: key);

  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  final SkillService _skillService = SkillService();
  final Toast _toast = Toast();
  final TextEditingController _typeAheadController = TextEditingController();
  bool isLoading = false;
  List<Skill> skills = [];

  @override
  void dispose() {
    _typeAheadController.dispose();
    super.dispose();
  }

  bool skillAlreadyExists(String skillName) {
    Skill skill = skills.firstWhere((skill) {
      return skill.name.toLowerCase() == skillName.toLowerCase();
    }, orElse: () => null);
    return skill != null;
  }

  void addSkill() {
    if (_typeAheadController.text.isNotEmpty &&
        !skillAlreadyExists(_typeAheadController.text)) {
      setState(() {
        skills.add(
          new Skill(name: _typeAheadController.text, canonicalName: ""),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).skills,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(AppLocalizations.of(context).skillsDescription),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 4,
                        child: TypeAheadField<Skill>(
                          suggestionsCallback: _skillService.getSkills,
                          onSuggestionSelected: (Skill suggestion) {
                            if (!skillAlreadyExists(suggestion.name)) {
                              setState(() {
                                skills.add(suggestion);
                              });
                            }
                          },
                          itemBuilder: (context, Skill suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _typeAheadController,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: AppLocalizations.of(context).addSkills,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 12),
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            onPressed: () {
                              addSkill();
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                skills.length != 0
                    ? listSkills()
                    : SvgPicture.asset(
                        "assets/images/skills.svg",
                        width: 180,
                      ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                nextButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listSkills() {
    return SizedBox(
      height: 230,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Wrap(
          children: skills
              .map((s) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        side:
                            BorderSide(color: Colors.green.shade400, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.grey.shade50,
                      deleteIcon: Icon(
                        Icons.close_rounded,
                        color: Colors.green.shade400,
                        size: 15,
                      ),
                      label: Text(
                        s.name,
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                      onDeleted: () {
                        setState(() {
                          skills.remove(s);
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      child: isLoading
          ? SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                strokeWidth: 3,
              ),
            )
          : Text(AppLocalizations.of(context).next),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        try {
          var futures = skills.map((skill) {
            return _skillService.createSkill(skill);
          });
          await Future.wait(futures);
          widget.increment();
        } catch (error) {
          _toast.showError(context, AppLocalizations.of(context).serverError);
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: TextStyle(fontSize: 16),
        primary: Theme.of(context).primaryColor, // background
      ),
    );
  }
}
