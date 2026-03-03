import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductionPage extends StatefulWidget {
  final int companyId;
  final String companyName;

  const ProductionPage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 1);
  Map<String, dynamic>? _companyDetails;

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void _fetchCompanyDetails() async {
    try {
      final response =
          await http.get(Uri.parse(getProductionDetailsUrl(widget.companyId)));
      if (response.statusCode == 200) {
        setState(() {
          _companyDetails = jsonDecode(response.body);
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await http
          .get(Uri.parse(getProductionMoviesUrl(widget.companyId, pageKey)));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        final List<Map<String, dynamic>> newItems =
            results.cast<Map<String, dynamic>>();

        final isLastPage = newItems.length < 20;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, pageKey + 1);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              widget.companyName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Apercu',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  if (_companyDetails?['logo_path'] != null)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/w200${_companyDetails?['logo_path']}",
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.companyName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        if (_companyDetails?['headquarters'] != null)
                          Text(
                            _companyDetails!['headquarters'],
                            style: TextStyle(
                                color: Colors.white54, fontSize: 13.sp),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: PagedSliverGrid<int, Map<String, dynamic>>(
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, item, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => movieDetailPage(
                          movieid: item['id'],
                          title: item['title'] ?? 'Movie',
                          imageurl: item['poster_path'] ?? "",
                          posterpath: item['poster_path'] ?? "",
                          backdroppath: item['backdrop_path'] ?? "",
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${item['poster_path']}",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.movie, color: Colors.white24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
