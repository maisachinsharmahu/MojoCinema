import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class moviecard extends StatelessWidget {
  final String imageurl;
  final String backdrop;
  final double rate;
  final String title;
  final int vote_count;
  final int movieid;
  final String? heroTag;
  final String mediaType; // "movie" or "tv"
  const moviecard({
    super.key,
    required this.imageurl,
    required this.title,
    required this.rate,
    required this.vote_count,
    required this.movieid,
    required this.backdrop,
    this.heroTag,
    this.mediaType = "movie",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 14.w),
      child: Bounceable(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => movieDetailPage(
                title: title,
                backdroppath: backdrop,
                movieid: movieid,
                imageurl: imageurl,
                posterpath: imageurl.startsWith('https')
                    ? imageurl
                    : "https://image.tmdb.org/t/p/w500$imageurl",
                heroTag: heroTag ?? movieid.toString(),
                mediaType: mediaType,
              ),
            ),
          );
        },
        child: Hero(
          tag: heroTag ?? movieid.toString(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Image
                CachedNetworkImage(
                  imageUrl: imageurl.startsWith('https')
                      ? imageurl
                      : "https://image.tmdb.org/t/p/w500/$imageurl",
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 140.w,
                  placeholder: (context, url) => Container(
                    color: Colors.white.withOpacity(0.05),
                    child: const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.red)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.white.withOpacity(0.05),
                    child:
                        const Icon(Icons.broken_image, color: Colors.white24),
                  ),
                ),
                // Bottom Gradient for name
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Title at bottom
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  right: 8.w,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apercu',
                    ),
                  ),
                ),
                // Rating Badge
                if (rate > 0)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.white10, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            rate.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatNumber(int number) {
  if (number >= 1e9) {
    // Convert to Billion (B)
    return (number / 1e9).toStringAsFixed(1) + 'B';
  } else if (number >= 1e6) {
    // Convert to Million (M)
    return (number / 1e6).toStringAsFixed(1) + 'M';
  } else if (number >= 1e3) {
    // Convert to Thousand (K)
    return (number / 1e3).toStringAsFixed(1) + 'K';
  } else {
    // For numbers less than 1000, return as is
    return number.toStringAsFixed(0);
  }
}
