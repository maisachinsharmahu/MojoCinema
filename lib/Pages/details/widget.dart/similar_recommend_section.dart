import 'dart:convert';

import 'package:mojocinema/Pages/Home/Widgets/movieWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class SimilarAndRecommend extends StatefulWidget {
  final String title;
  final String links;

  // Constructor to take title and links as parameters
  const SimilarAndRecommend({
    Key? key,
    required this.title,
    required this.links,
  }) : super(key: key);

  @override
  State<SimilarAndRecommend> createState() => _SimilarAndRecommendState();
}

class _SimilarAndRecommendState extends State<SimilarAndRecommend> {
  List<Map<String, dynamic>> movieDataList = [];

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse(widget.links));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data["results"] as List;
      movieDataList.clear();
      for (int i = 0; i < results.length; i++) {
        movieDataList.add({
          'id': results[i]["id"],
          'backdrop_path': results[i]["backdrop_path"],
          'poster_path': results[i]["poster_path"],
          'name': results[i]["title"] ?? results[i]["name"],
          'vote_average': results[i]["vote_average"],
          'media_type': results[i]["media_type"],
          'index': i,
          'vote_count': results[i]["vote_count"],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Apercu",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220.h,
          width: 1.sw,
          child: FutureBuilder(
            future: fetchMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (movieDataList.isEmpty) {
                  return Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: movieDataList.length,
                  itemBuilder: (context, index) {
                    final movie = movieDataList[index];
                    if (movie['poster_path'] != null) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: moviecard(
                          backdrop:
                              movie['backdrop_path'] ?? movie['poster_path'],
                          movieid: movie['id'],
                          title: movie['name'],
                          imageurl: movie['poster_path'] ?? "",
                          rate: (movie['vote_average'] as num).toDouble(),
                          vote_count: movie['vote_count'],
                          heroTag: '${widget.title}_${movie['id']}',
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
