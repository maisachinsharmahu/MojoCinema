import 'dart:convert';

import 'package:mojocinema/Pages/Home/Widgets/movieWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class upcomingWidget extends StatefulWidget {
  final String links;
  final String? heroPrefix;
  final String mediaType;
  const upcomingWidget({
    super.key,
    required this.links,
    this.heroPrefix,
    this.mediaType = 'movie',
  });

  @override
  State<upcomingWidget> createState() => _upcomingWidgetState();
}

class _upcomingWidgetState extends State<upcomingWidget> {
  late Future<List<Map<String, dynamic>>> _upcomingFuture;

  Future<List<Map<String, dynamic>>> upcomingList() async {
    var upcomingListResponse = await http.get(Uri.parse(widget.links));
    if (upcomingListResponse.statusCode == 200) {
      var tempdata = jsonDecode(upcomingListResponse.body);
      var resultdata = tempdata["results"] as List;
      List<Map<String, dynamic>> data = [];

      for (var movie in resultdata) {
        if (movie["poster_path"] != null) {
          data.add({
            'id': movie["id"],
            'backdrop_path': movie["backdrop_path"],
            'poster_path': movie["poster_path"],
            'name': movie["title"] ?? movie["name"],
            'vote_average': (movie["vote_average"] as num).toDouble(),
            'media_type': movie["media_type"],
            'vote_count': movie["vote_count"],
          });
        }
      }
      return data;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _upcomingFuture = upcomingList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _upcomingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }
            final movies = snapshot.data!;
            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: movies.length > 10 ? 11 : movies.length,
                itemBuilder: (context, index) {
                  if (index == 10) {
                    return GestureDetector(
                      onTap: () {
                        // Optional: trigger navigation to see all
                      },
                      child: Container(
                        width: 140.w,
                        margin: EdgeInsets.only(right: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_forward_rounded,
                                  size: 28.sp, color: Colors.red),
                            ),
                            SizedBox(height: 12.h),
                            Text("See More",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Apercu')),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return moviecard(
                      backdrop: movies[index]['backdrop_path'] ??
                          movies[index]['poster_path'],
                      movieid: movies[index]['id'],
                      title: movies[index]['name'],
                      imageurl: movies[index]['poster_path'],
                      rate: movies[index]['vote_average'],
                      vote_count: movies[index]['vote_count'],
                      heroTag: widget.heroPrefix != null
                          ? '${widget.heroPrefix}_${movies[index]['id']}'
                          : null,
                      mediaType:
                          movies[index]['media_type'] ?? widget.mediaType,
                    );
                  }
                });
          } else {
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 2,
                ),
              ),
            );
          }
        });
  }
}
