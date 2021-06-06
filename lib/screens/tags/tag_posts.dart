import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class TagPosts extends StatefulWidget {
  final String canonicalName;

  const TagPosts({Key key, this.canonicalName}) : super(key: key);

  @override
  _TagPostsState createState() => _TagPostsState();
}

class _TagPostsState extends State<TagPosts> {
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
      final newItems =
          await _postService.getPostsByTag(widget.canonicalName, page);
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
                      Text(
                        t.emptyList,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // OutlinedButton.icon(
                      //   onPressed: () {
                      //     Navigator.of(context).pushNamed("/new-post");
                      //   },
                      //   style: OutlinedButton.styleFrom(
                      //     side: BorderSide(
                      //       width: 1.0,
                      //       color: Theme.of(context).primaryColor,
                      //       style: BorderStyle.solid,
                      //     ),
                      //   ),
                      //   icon: Icon(Icons.add, size: 18),
                      //   label: Text(
                      //     t.newPost,
                      //     style:
                      //         TextStyle(color: Theme.of(context).primaryColor),
                      //   ),
                      // )
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
