import 'dart:convert';

import 'package:mojocinema/Pages/Discover/discover_page.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class generewidget extends StatefulWidget {
  final bool isTV;
  const generewidget({super.key, this.isTV = false});

  @override
  State<generewidget> createState() => _generewidgetState();
}

class _generewidgetState extends State<generewidget> {
  late Future<List<Map<String, dynamic>>> _genreFuture;

  Future<List<Map<String, dynamic>>> genrelist() async {
    var url = widget.isTV ? tvGenreUrl : genreurl;
    var genreresponse = await http.get(Uri.parse(url));

    if (genreresponse.statusCode == 200) {
      var tempdata = jsonDecode(genreresponse.body);
      var genrejson = tempdata["genres"] as List;
      return genrejson
          .map((e) => {
                'id': e["id"],
                'name': e["name"],
              })
          .toList();
    }
    return [];
  }

  @override
  void didUpdateWidget(generewidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTV != widget.isTV) {
      _genreFuture = genrelist();
    }
  }

  @override
  void initState() {
    super.initState();
    _genreFuture = genrelist();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _genreFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              final genres = snapshot.data!;
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: genres.length > 8 ? 8 : genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscoverPage(
                                initialGenreId: genre['id'],
                                initialGenreName: genre['name'],
                                mediaType: widget.isTV ? "tv" : "movie",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Center(
                            child: Text(
                              genre['name'],
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Apercu",
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
          }),
    );
  }
}
