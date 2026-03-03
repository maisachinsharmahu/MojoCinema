import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/Actor/actor_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CrewDeatilswidget extends StatelessWidget {
  const CrewDeatilswidget({
    super.key,
    required this.crewdata,
  });

  final List<Map<String, dynamic>> crewdata;

  @override
  Widget build(BuildContext context) {
    if (crewdata.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Text(
                "Top Cast",
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
          height: 180.h,
          child: ListView.builder(
            itemCount: crewdata.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemBuilder: (context, index) {
              final member = crewdata[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActorDetailPage(
                          actorId: member['id'] ?? 0,
                          actorName: member['name'] ?? '',
                          profilePath: member['profile_path'] != null
                              ? member['profile_path'].toString().replaceAll(
                                  'https://image.tmdb.org/t/p/w500', '')
                              : '',
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white.withOpacity(0.02),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 85.w,
                          height: 85.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "${member['profile_path']}",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade900,
                                child: const Icon(Icons.person,
                                    color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            member['name'] ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Apercu',
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            member['character'] ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white54,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
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
