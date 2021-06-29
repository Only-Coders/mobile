import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/generic/toast.dart';
import 'package:mobile/models/report_type.dart';
import 'package:mobile/services/post.dart';

class ReportPost extends StatefulWidget {
  final String postId;

  const ReportPost({Key key, @required this.postId}) : super(key: key);

  @override
  _ReportPostState createState() => _ReportPostState();
}

class _ReportPostState extends State<ReportPost> {
  final PostService _postService = PostService();
  final Toast _toast = Toast();
  String reportType = "";
  String reason = "";
  bool isLoading = false;
  Future getReportTypes;

  @override
  void initState() {
    getReportTypes = _postService.getReportTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        t.reportPost,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        textAlign: TextAlign.center,
      ),
      content: FutureBuilder(
        future: getReportTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final List<ReportType> reportTypes = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  width: 450,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < reportTypes.length; i++)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          title: Text(
                            reportTypes[i].name,
                            style: TextStyle(fontSize: 13),
                          ),
                          leading: Radio(
                            value: reportTypes[i].id,
                            groupValue: reportType,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (val) {
                              setState(() {
                                reportType = val;
                              });
                            },
                          ),
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        maxLines: null,
                        onChanged: (val) {
                          setState(() {
                            reason = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: t.reason,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ServerError(
                      refresh: () {},
                    ),
                  ],
                ),
              );
            }
          }
          return Container(
            width: 450,
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            primary: Theme.of(context).accentColor,
          ),
          child: Text(
            t.cancel.toUpperCase(),
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (reportType.isNotEmpty) {
              try {
                setState(() {
                  isLoading = true;
                });
                await _postService.reportPost(
                    widget.postId, reportType, reason);
                _toast.showSuccess(context, t.reportSuccess);
                Navigator.of(context).pop();
              } catch (error) {
                _toast.showError(context, t.serverError);
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
          style: TextButton.styleFrom(
            primary: Colors.orange,
          ),
          child: !isLoading
              ? Text(t.report.toUpperCase(),
                  style: TextStyle(
                    color: Colors.orange,
                  ))
              : SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                    strokeWidth: 3,
                  ),
                ),
        ),
      ],
    );
  }
}
