import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/generic/no_data.dart';
import 'package:mobile/components/generic/server_error.dart';
import 'package:mobile/components/profile/contact_request_item.dart';
import 'package:mobile/models/contact_request.dart';
import 'package:mobile/services/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactRequests extends StatefulWidget {
  const ContactRequests({Key key}) : super(key: key);

  @override
  _ContactRequestsState createState() => _ContactRequestsState();
}

class _ContactRequestsState extends State<ContactRequests> {
  static const _pageSize = 10;
  final PersonService _personService = PersonService();
  final PagingController<int, ContactRequest> _pagingController =
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
      final newItems = await _personService.getContactRequests(page);
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
          t.contactRequests,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, ContactRequest>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ContactRequest>(
            itemBuilder: (ctx, item, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ContactRequestItem(
                  contact: item.requester,
                  message: item.message,
                  refresh: _pagingController.refresh,
                ),
              );
            },
            firstPageErrorIndicatorBuilder: (ctx) => ServerError(
              refresh: _pagingController.refresh,
            ),
            noItemsFoundIndicatorBuilder: (ctx) => NoData(
              title: t.contactsNotFound,
              img: "assets/images/no-data-contacts.png",
            ),
          ),
        ),
      ),
    );
  }
}
