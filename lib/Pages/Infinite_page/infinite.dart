import 'dart:convert';
import 'package:mojocinema/Pages/Home/Widgets/movieWidget.dart';
import 'package:mojocinema/api/apikey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollMovies extends StatefulWidget {
  final String url;
  const InfiniteScrollMovies({super.key, required this.url});

  @override
  State<InfiniteScrollMovies> createState() => _InfiniteScrollMoviesState();
}

class _InfiniteScrollMoviesState extends State<InfiniteScrollMovies> {
  static const _pageSize = 20;

  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final String fullUrlWithPage = widget.url.contains('?')
          ? "${widget.url}&page=$pageKey"
          : "${widget.url}?api_key=$apikey&page=$pageKey";

      // Ensure apikey is present if not already in URL
      String requestUrl = fullUrlWithPage;
      if (!requestUrl.contains('api_key=')) {
        requestUrl =
            "$requestUrl${requestUrl.contains('?') ? '&' : '?'}api_key=$apikey";
      }

      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        final List<Map<String, dynamic>> newItems = results
            .map((item) => {
                  'id': item['id'],
                  'title': item['title'] ?? item['name'] ?? "Unknown",
                  'poster_path': item['poster_path'],
                  'backdrop_path': item['backdrop_path'],
                  'vote_average':
                      (item['vote_average'] as num?)?.toDouble() ?? 0.0,
                  'vote_count': item['vote_count'] ?? 0,
                })
            .toList();

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        _pagingController.error = "Failed to load data";
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Explore",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Apercu',
          ),
        ),
      ),
      body: PagedGridView<int, Map<String, dynamic>>(
        padding: EdgeInsets.all(16.w),
        pagingController: _pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, item, index) => moviecard(
            imageurl: item['poster_path'] ?? "",
            title: item['title'],
            rate: item['vote_average'],
            vote_count: item['vote_count'],
            movieid: item['id'],
            backdrop: item['backdrop_path'] ?? "",
            heroTag: 'infinite_${item['id']}_$index',
          ),
          firstPageProgressIndicatorBuilder: (_) =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          newPageProgressIndicatorBuilder: (_) =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
        ),
      ),
    );
  }
}
