import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mojocinema/Pages/Home/Widgets/genere.dart';
import 'package:mojocinema/Pages/Home/Widgets/section.dart';

import 'package:mojocinema/Pages/Videospage/vid.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:mojocinema/Pages/Search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

// import '../../../slider/carousel_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trendinglist = [];
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }

  int uval = 1;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  Future<void> trendinglisthome() async {
    if (uval == 1) {
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata["results"];
        trendinglist.clear();
        for (int i = 0; i < trendingweekjson.length; i++) {
          // List<Color> posterColors;
          // final PaletteGenerator paletteGenerator =
          //     await PaletteGenerator.fromImageProvider(
          //   NetworkImage(
          //       "https://image.tmdb.org/t/p/w500/${trendingweekjson[i]["poster_path"]}"),
          // );
          trendinglist.add({
            'id': trendingweekjson[i]["id"],
            'backdrop_path': trendingweekjson[i]["backdrop_path"],
            'poster_path': trendingweekjson[i]["poster_path"],
            'name': trendingweekjson[i]["original_name"],
            'vote_average': trendingweekjson[i]["vote_average"],
            'media_type': trendingweekjson[i]["media_type"],
            'index': i,
            // 'posterColors': [
            //   paletteGenerator.dominantColor?.color ?? Colors.transparent,
            //   paletteGenerator.darkVibrantColor?.color ?? Colors.transparent,
            // ]
          });
        }
      }
    } else if (uval == 2) {
      // print(uval);
      var trendingdayresponse = await http.get(Uri.parse(trendingday));
      if (trendingdayresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingdayresponse.body);
        var trendingdayjson = tempdata["results"];
        trendinglist.clear();
        for (int i = 0; i < trendingdayjson.length; i++) {
          trendinglist.add({
            'id': trendingdayjson[i]["id"],
            'backdrop_path': trendingdayjson[i]["backdrop_path"],
            'poster_path': trendingdayjson[i]["poster_path"],
            'name': trendingdayjson[i]["original_name"],
            'vote_average': trendingdayjson[i]["vote_average"],
            'media_type': trendingdayjson[i]["media_type"],
            'index': i,
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            pinned: true,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Image.network(
                "https://i.pinimg.com/736x/d6/64/b2/d664b27cca7eaf4d64c41622b5bb9b6c.jpg", // Placeholder for Logo
                height: 30.h,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                icon: Icon(Iconsax.search_normal,
                    size: 24.sp, color: Colors.white),
              ),
            ],
            expandedHeight: 0.55.sh,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendinglisthome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        // Dynamic Blurred Background
                        ValueListenableBuilder<int>(
                          valueListenable: _currentPageNotifier,
                          builder: (context, index, child) {
                            if (trendinglist.isEmpty) return const SizedBox();
                            final movie =
                                trendinglist[index % trendinglist.length];
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                                  fit: BoxFit.cover,
                                ),
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // Top Gradient for status bar
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.9),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 60.h),
                              CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  height: 0.42.sh,
                                  viewportFraction: 0.7,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  onPageChanged: (index, reason) {
                                    _currentPageNotifier.value = index;
                                  },
                                ),
                                items: trendinglist.map((movie) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              movieDetailPage(
                                            title: movie['name'] ?? "Movie",
                                            backdroppath:
                                                movie['backdrop_path'],
                                            movieid: movie['id'],
                                            imageurl: movie['poster_path'],
                                            posterpath:
                                                "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                                            heroTag: 'carousel_${movie['id']}',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                        child: Hero(
                                          tag: 'carousel_${movie['id']}',
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 20.h),
                              ValueListenableBuilder<int>(
                                valueListenable: _currentPageNotifier,
                                builder: (context, index, child) {
                                  if (trendinglist.isEmpty)
                                    return const SizedBox();
                                  final movie =
                                      trendinglist[index % trendinglist.length];
                                  return Column(
                                    children: [
                                      Text(
                                        movie['name'] ?? "Title",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Apercu',
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPage(
                                                    movieId: movie['id'],
                                                    backdropPath:
                                                        movie['backdrop_path'],
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 10.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            icon: Icon(Icons.play_arrow,
                                                size: 24.sp),
                                            label: Text("Trailer",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          SizedBox(width: 12.w),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          movieDetailPage(
                                                    title: movie['name'] ??
                                                        "Movie",
                                                    backdroppath:
                                                        movie['backdrop_path'],
                                                    movieid: movie['id'],
                                                    imageurl:
                                                        movie['poster_path'],
                                                    posterpath:
                                                        "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                                                    heroTag:
                                                        'carousel_${movie['id']}',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white
                                                  .withOpacity(0.15),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 10.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            icon: Icon(Icons.info_outline,
                                                size: 24.sp),
                                            label: Text("Details",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: 0.6.sh,
                      color: Colors.black,
                      child: const Center(
                          child: CircularProgressIndicator(color: Colors.red)),
                    );
                  }
                },
              ),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.flash, color: Colors.redAccent, size: 16.sp),
                  SizedBox(width: 8.w),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: const Color(0xFF1a1a1a),
                    ),
                    child: DropdownButton<int>(
                      underline: const SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Colors.white70, size: 18.sp),
                      value: uval,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Apercu',
                      ),
                      onChanged: (value) {
                        setState(() {
                          trendinglist.clear();
                          uval = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Weekly")),
                        DropdownMenuItem(value: 2, child: Text("Daily")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Genres",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Apercu",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                generewidget(),
                SizedBox(height: 10.h),
                Column(
                  children: [
                    SectionWidget(
                        title: "Indian Movies", links: indianmovieurl),
                    SectionWidget(
                        title: "Upcoming Indian", links: upcomingindianurl),
                    SectionWidget(
                        title: "Upcoming WorldWide", links: upcomingmoviesurl),
                    SectionWidget(title: "Popular", links: popularmovieurl),
                    SectionWidget(
                        title: "Horror Movies", links: hindihorrorurl),
                    SectionWidget(title: "Top Rated", links: topratedmovie),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
