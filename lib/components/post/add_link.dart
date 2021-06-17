import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/services/link_preview.dart';

class AddLink extends StatefulWidget {
  final addLink;

  const AddLink({Key key, this.addLink}) : super(key: key);

  @override
  _AddLinkState createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final LinkPreviewService _linkPreviewService = LinkPreviewService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegExp validUrl = new RegExp(
      r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
  String url = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        t.addLink,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: Container(
        width: 450,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    url = val;
                  });
                },
                validator: (val) {
                  return validUrl.hasMatch(val) ? null : t.invalidUrl;
                },
                style: TextStyle(color: Theme.of(context).accentColor),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Url",
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  filled: true,
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (formKey.currentState.validate()) {
              try {
                setState(() {
                  isLoading = true;
                });
                Link link = await _linkPreviewService.previewLink(url);
                widget.addLink(link);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              } catch (error) {
                setState(() {
                  isLoading = false;
                });
                Toast().showError(context, t.serverError);
              }
            }
          },
          child: Text(
            t.add.toUpperCase(),
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
