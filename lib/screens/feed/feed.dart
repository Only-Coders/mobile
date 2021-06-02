import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/generic/bottom_nav.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/person.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/person.dart';
import 'package:mobile/services/post.dart';
import 'package:mobile/theme/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Feed extends StatefulWidget {
  const Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  static const _pageSize = 10;
  final PostService _postService = PostService();
  final PersonService _personService = PersonService();
  final PagingController<int, Post> _pagingController =
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
      final newItems = await _postService.getFeedPosts(page);
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
        title: Container(
          height: 40,
          child: TypeAheadField<Person>(
            suggestionsCallback: _personService.searchPerson,
            onSuggestionSelected: (Person suggestion) {},
            itemBuilder: (context, Person suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: suggestion.imageURI.isEmpty
                      ? AssetImage("assets/images/default-avatar.png")
                      : NetworkImage(suggestion.imageURI),
                ),
                title: Text(
                  suggestion.firstName,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                subtitle: Text(
                  suggestion.currentPosition != null
                      ? "${suggestion.currentPosition.workplace.name} ${suggestion.currentPosition.position}"
                      : "",
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                  ),
                ),
              );
            },
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: currentTheme.currentTheme == ThemeMode.dark
                    ? Theme.of(context).cardColor.withOpacity(0.4)
                    : Theme.of(context).cardColor.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                labelText: t.search,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                filled: true,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: Icon(
                Icons.message,
                size: 30,
                color: Theme.of(context).accentColor,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, item, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: PostItem(
                  post: item,
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
