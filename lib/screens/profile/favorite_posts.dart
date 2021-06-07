import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class FavoritePosts extends StatefulWidget {
  const FavoritePosts({Key key}) : super(key: key);

  @override
  _FavoritePostsState createState() => _FavoritePostsState();
}

class _FavoritePostsState extends State<FavoritePosts> {
  static const _pageSize = 10;
  final PostService _postService = PostService();
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
      final newItems = await _postService.getFavoritesPost(page);
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
          t.favorites,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (ctx, item, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: PostItem(
                  post: item,
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (ctx) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-data.png",
                        width: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        t.postsNotFound,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
