import 'dart:ui';
import 'package:mojocinema/Pages/Collection/collection_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionWidget extends StatelessWidget {
  const CollectionWidget({
    super.key,
    required this.collectiondata,
  });

  final List<Map<String, dynamic>> collectiondata;

  @override
  Widget build(BuildContext context) {
    if (collectiondata.isEmpty) return const SizedBox.shrink();

    final item = collectiondata[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                "Collection",
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
        Padding(
          padding: EdgeInsets.all(16.w),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollectionPage(
                    collectionId: item['id'],
                    collectionName: item['name'],
                  ),
                ),
              );
            },
            child: Container(
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Backdrop as background
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w780${item['backdrop_path'] ?? item['poster_path']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item['name'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "Apercu",
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item['overview'] ?? '',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.white70,
                                  height: 1.4,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // Poster on the right
                        Container(
                          width: 90.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://image.tmdb.org/t/p/w342${item['poster_path']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
