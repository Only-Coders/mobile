import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/notifications/notification_item.dart';
import 'package:mobile/providers/user.dart';
import 'package:mobile/services/notifications.dart';
import 'package:mobile/models/fb_notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationService _notificationService = NotificationService();
  final PagingController<int, FBNotification> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _notificationService.getNotifications();
      _pagingController.appendLastPage(newItems);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        title: Text(
          t.notifications,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: _pagingController.itemList.length > 0
                ? () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: ListTile(
                                onTap: () async {
                                  Iterable<Future<void>> futures =
                                      _pagingController.itemList.map(
                                    (notification) => FirebaseDatabase.instance
                                        .reference()
                                        .child(
                                            "notifications/${context.read<User>().canonicalName}/${notification.key}")
                                        .update({"read": true}),
                                  );
                                  await Future.wait(futures);
                                  Navigator.of(context).pop();
                                  _pagingController.refresh();
                                },
                                leading: Icon(Icons.delete),
                                title: Text(t.deleteAllNotifications),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: PagedListView<int, FBNotification>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<FBNotification>(
              itemBuilder: (ctx, item, index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      NotificationItem(
                          notification: item,
                          refresh: _pagingController.refresh),
                      SizedBox(
                        height: 5,
                      ),
                      Divider()
                    ],
                  ),
                );
              },
              firstPageErrorIndicatorBuilder: (ctx) => ServerError(
                refresh: _pagingController.refresh,
              ),
              noItemsFoundIndicatorBuilder: (ctx) => NoData(
                title: t.notificationsNotFound,
                img: "assets/images/no-data.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
