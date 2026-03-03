import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class CollectionPage extends StatefulWidget {
  final int collectionId;
  final String? collectionName;

  const CollectionPage({
    super.key,
    required this.collectionId,
    this.collectionName,
  });

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  Map<String, dynamic>? _collectionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCollection();
  }

  void _fetchCollection() async {
    try {
      final response =
          await http.get(Uri.parse(getCollectionUrl(widget.collectionId)));
      if (response.statusCode == 200) {
        setState(() {
          _collectionData = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 0.4.sh,
                  pinned: true,
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      _collectionData?['name'] ??
                          widget.collectionName ??
                          "Collection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(blurRadius: 10, color: Colors.black)
                        ],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/original${_collectionData?['backdrop_path']}",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_collectionData?['overview'] != null &&
                            _collectionData!['overview'].isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.h),
                            child: Text(
                              _collectionData!['overview'],
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                          ),
                        Text(
                          "Movies in this series",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Apercu',
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = _collectionData!['parts'][index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => movieDetailPage(
                                  movieid: movie['id'],
                                  title: movie['title'] ?? "Movie",
                                  imageurl: movie['poster_path'] ?? "",
                                  posterpath: movie['poster_path'] ?? "",
                                  backdroppath: movie['backdrop_path'] ?? "",
                                  mediaType: "movie",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16.r)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                                    width: 100.w,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          movie['title'] ?? "Unknown",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          movie['release_date']
                                                  ?.split('-')[0] ??
                                              "",
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded,
                                                color: Colors.amber, size: 16),
                                            SizedBox(width: 4.w),
                                            Text(
                                              (movie['vote_average'] as num)
                                                  .toStringAsFixed(1),
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white24, size: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _collectionData?['parts']?.length ?? 0,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 40.h)),
              ],
            ),
    );
  }
}
