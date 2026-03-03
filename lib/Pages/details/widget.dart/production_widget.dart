import 'package:mojocinema/Pages/Production/production_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductionWidget extends StatelessWidget {
  const ProductionWidget({
    super.key,
    required this.movieDetails,
  });

  final List<Map<String, dynamic>> movieDetails;

  @override
  Widget build(BuildContext context) {
    if (movieDetails.isEmpty ||
        movieDetails[0]['production_companies'] == null) {
      return const SizedBox.shrink();
    }

    final companies = movieDetails[0]['production_companies'] as List;
    if (companies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Text(
                "Production",
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
          height: 110.h,
          child: ListView.builder(
            itemCount: companies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemBuilder: (context, index) {
              final company = companies[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductionPage(
                          companyId: company['id'],
                          companyName: company['name'] ?? "Production",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 130.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: company['logo_path'] == null
                              ? Icon(Icons.business_rounded,
                                  color: Colors.white24, size: 32.sp)
                              : CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/w200${company['logo_path']}",
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const SizedBox.shrink(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.business_rounded,
                                          color: Colors.white24),
                                ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          company['name'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
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
        SizedBox(height: 16.h),
      ],
    );
  }
}
