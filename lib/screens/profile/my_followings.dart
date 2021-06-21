import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/contacts/profile_follower_item.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyFollowings extends StatefulWidget {
  const MyFollowings({Key key}) : super(key: key);

  @override
  _MyFollowingState createState() => _MyFollowingState();
}

class _MyFollowingState extends State<MyFollowings> {
  static const _pageSize = 10;
  final PersonService _personService = PersonService();
  final PagingController<int, Person> _pagingController =
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
      int page = pageKey ~/ 10;
      final newItems = await _personService.getMyFollowers(page);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
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
        title: Text(
          t.following,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Person>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Person>(
            itemBuilder: (ctx, item, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ProfileFollowerItem(
                  person: item,
                  refreshFollowings: _pagingController.refresh,
                ),
              );
            },
            firstPageErrorIndicatorBuilder: (ctx) => ServerError(
              refresh: _pagingController.refresh,
            ),
            noItemsFoundIndicatorBuilder: (ctx) => NoData(
              title: t.followingNotFound,
              img: "assets/images/no-data-contacts.png",
            ),
          ),
        ),
      ),
    );
  }
}
