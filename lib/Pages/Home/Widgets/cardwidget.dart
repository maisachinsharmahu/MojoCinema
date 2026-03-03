import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieCardWidget extends StatelessWidget {
  final int movieId;
  final String posterPath;
  const MovieCardWidget(
      {super.key, required this.movieId, required this.posterPath});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 32,
      borderRadius: BorderRadius.circular(16.r),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CachedNetworkImage(
            imageUrl: '$posterPath',
            // height: Screensize.screenHeight(context) * 0.,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
