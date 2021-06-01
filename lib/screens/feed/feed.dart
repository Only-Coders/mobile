import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/components/generic/bottom_nav.dart';
import 'package:mobile/components/post/post_item.dart';
import 'package:mobile/models/post.dart';
import 'package:mobile/services/post.dart';

class Feed extends StatefulWidget {
  const Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              fillColor: Color(0xff494C62),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
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
                color: Colors.white,
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
