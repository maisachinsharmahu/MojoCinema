import 'package:mojocinema/Pages/Home/Widgets/upcominglist.dart';
import 'package:mojocinema/Pages/Infinite_page/infinite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final String links;
  final String mediaType;

  // Constructor to take title and links as parameters
  const SectionWidget({
    Key? key,
    required this.title,
    required this.links,
    this.mediaType = "movie",
  }) : super(key: key);

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
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Apercu",
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => InfiniteScrollMovies(
                        url: links,
                      ),
                    ),
                  );
                },
                child: Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220.h,
          child: upcomingWidget(
            links: links,
            heroPrefix: title,
            mediaType: mediaType,
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
