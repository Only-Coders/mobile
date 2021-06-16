import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/notifications/notification_item.dart';
import 'package:mobile/services/notifications.dart';
import 'package:mobile/models/notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(
          t.notifications,
          style: TextStyle(color: Colors.white),
        ),
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
