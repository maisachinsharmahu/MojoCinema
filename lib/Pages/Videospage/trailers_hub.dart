import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/Videospage/vid.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class TrailersHubPage extends StatefulWidget {
  const TrailersHubPage({super.key});

  @override
  State<TrailersHubPage> createState() => _TrailersHubPageState();
}

class _TrailersHubPageState extends State<TrailersHubPage> {
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpcomingTrailers();
  }

  Future<void> _fetchUpcomingTrailers() async {
    try {
      final response = await http.get(Uri.parse(upcomingmoviesurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _movies = List<Map<String, dynamic>>.from(data['results']);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : null,
        title: Text(
          "Latest Trailers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'Apercu',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return _buildTrailerCard(movie);
              },
            ),
    );
  }

  Widget _buildTrailerCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPage(
              movieId: movie['id'],
              backdropPath: movie['backdrop_path'] ?? "",
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w780${movie['backdrop_path'] ?? movie['poster_path']}",
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 32.sp),
                ),
                Positioned(
                  bottom: 12.h,
                  right: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      movie['release_date'] ?? "Coming Soon",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? movie['name'] ?? "Unknown",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apercu',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    movie['overview'] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
