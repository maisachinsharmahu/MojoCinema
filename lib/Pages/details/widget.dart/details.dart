import 'dart:convert';
import 'package:mojocinema/Pages/details/widget.dart/collectionwidget.dart';
import 'package:mojocinema/api/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:url_launcher/url_launcher.dart';

class movienameandotherdetails extends StatefulWidget {
  const movienameandotherdetails({
    super.key,
    required this.movieDetails,
  });

  final List<Map<String, dynamic>> movieDetails;

  @override
  State<movienameandotherdetails> createState() =>
      _movienameandotherdetailsState();
}

class _movienameandotherdetailsState extends State<movienameandotherdetails> {
  List<Map<String, dynamic>> collectiondata = [];

  Future<void> fetchcollectionData(int id) async {
    var url = "https://api.themoviedb.org/3/collection/$id?api_key=${apikey}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var tempdata = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          collectiondata.clear();
          collectiondata.add(tempdata);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieDetails.isEmpty) return const SizedBox.shrink();
    final movie = widget.movieDetails[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata Row
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: Text(
                      getYearFromDate(movie['release_date'] ?? ''),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(Icons.timer_outlined,
                      color: Colors.white70, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    formatRuntime(movie['runtime'] ?? 0),
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                  ),
                  SizedBox(width: 12.w),
                  if ((movie['vote_average'] ?? 0) > 0) ...[
                    Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      (movie['vote_average']).toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " / 10",
                      style: TextStyle(color: Colors.white38, fontSize: 10.sp),
                    ),
                  ],
                  if (movie['certification'] != null &&
                      movie['certification'] != "N/A") ...[
                    SizedBox(width: 12.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: Text(
                        movie['certification'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 24.h),
              // Overview Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apercu',
                    ),
                  ),
                  _buildSocialLinks(movie['external_ids']),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                movie['about'] ?? "",
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Poppins',
                ),
              ),
              if (movie['keywords'] != null &&
                  (movie['keywords'] as List).isNotEmpty) ...[
                SizedBox(height: 20.h),
                _buildKeywords(movie['keywords']),
              ],
            ],
          ),
        ),

        SizedBox(height: 24.h),
        // Stats
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: _buildStat(
                  "Popularity",
                  movie['popularity'].toStringAsFixed(0),
                  Icons.trending_up,
                  Colors.greenAccent,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStat(
                  "Total Votes",
                  formatVoteCount(movie['vote_count']),
                  Icons.people_outline,
                  Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        // Collection
        if (movie['collection'] != null)
          FutureBuilder(
            future: fetchcollectionData(movie['collection']['id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CollectionWidget(collectiondata: collectiondata);
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Apercu',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white54,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywords(List<dynamic> keywords) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: keywords.take(6).map((k) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            "#${k['name']}",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11.sp,
              fontFamily: 'Poppins',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialLinks(Map<String, dynamic>? externalIds) {
    if (externalIds == null) return const SizedBox();

    return Row(
      children: [
        if (externalIds['instagram_id'] != null)
          _socialIcon(Icons.camera_alt_outlined,
              "https://instagram.com/${externalIds['instagram_id']}"),
        if (externalIds['twitter_id'] != null)
          _socialIcon(Icons.link_rounded,
              "https://twitter.com/${externalIds['twitter_id']}"),
        if (externalIds['facebook_id'] != null)
          _socialIcon(Icons.facebook_rounded,
              "https://facebook.com/${externalIds['facebook_id']}"),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Icon(icon, color: Colors.white54, size: 20.sp),
      ),
    );
  }
}

String formatVoteCount(int voteCount) {
  if (voteCount >= 1000000) {
    return (voteCount / 1000000).toStringAsFixed(1) + 'M';
  } else if (voteCount >= 1000) {
    return (voteCount / 1000).toStringAsFixed(1) + 'K';
  } else {
    return voteCount.toString();
  }
}
