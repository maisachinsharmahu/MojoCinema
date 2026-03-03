import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeasonsWidget extends StatelessWidget {
  final List<dynamic> seasons;
  final String showName;

  const SeasonsWidget({
    super.key,
    required this.seasons,
    required this.showName,
  });

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Text(
            "Seasons",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Apercu",
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            itemCount: seasons.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemBuilder: (context, index) {
              final season = seasons[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: season['poster_path'] != null
                              ? "https://image.tmdb.org/t/p/w200${season['poster_path']}"
                              : "https://i.pinimg.com/736x/d6/64/b2/d664b27cca7eaf4d64c41622b5bb9b6c.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              season['name'] ??
                                  "Season ${season['season_number']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${season['episode_count']} Episodes",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
