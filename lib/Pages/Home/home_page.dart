import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mojocinema/Pages/Home/Widgets/genere.dart';
import 'package:mojocinema/Pages/Home/Widgets/section.dart';

import 'package:mojocinema/Pages/Videospage/vid.dart';

import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:mojocinema/api/apikey.dart';
import 'package:mojocinema/Pages/Home/Widgets/drawer_widget.dart';
import 'package:mojocinema/Pages/Search/search_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> trendinglist = [];
  late CarouselSliderController _carouselController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  late Future<void> _trendingFuture;

  @override
  void initState() {
    super.initState();
    _currentPageNotifier.value = 0;
    _trendingFuture = trendinglisthome();
    _carouselController = CarouselSliderController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int uval = 1; // 1: Week, 2: Day
  int categoryIndex = 0; // 0: All, 1: Movies, 2: TV
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  Future<void> trendinglisthome() async {
    String url = "";
    if (categoryIndex == 0) {
      url = upcomingindianurl;
    } else if (categoryIndex == 1) {
      url = indianmovieurl;
    } else {
      url = indianTVurl;
    }

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var tempdata = jsonDecode(response.body);
      var results = tempdata["results"];
      List<Map<String, dynamic>> newList = [];
      for (int i = 0; i < results.length; i++) {
        if (results[i]["poster_path"] != null) {
          newList.add({
            'id': results[i]["id"],
            'backdrop_path': results[i]["backdrop_path"],
            'poster_path': results[i]["poster_path"],
            'name': results[i]["original_name"] ??
                results[i]["title"] ??
                results[i]["name"],
            'vote_average': results[i]["vote_average"],
            'media_type': results[i]["media_type"] ??
                (categoryIndex == 1 ? 'movie' : 'tv'),
            'index': i,
          });
        }
      }

      setState(() {
        trendinglist = newList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const MojocinemaDrawer(),
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor:
                _isScrolled ? Colors.black.withOpacity(1) : Colors.transparent,
            centerTitle: true,
            floating: false,
            pinned: true,
            elevation: 0,
            expandedHeight: 0.65.sh,
            titleSpacing: 0,
            title: _isScrolled
                ? Text("MOJOCINEMA",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20.sp,
                        color: Colors.red,
                        letterSpacing: 2,
                        fontFamily: 'Apercu'))
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCategoryTab("All", 0),
                            SizedBox(width: 25.w),
                            _buildCategoryTab("Movies", 1),
                            SizedBox(width: 25.w),
                            _buildCategoryTab("TV", 2),
                          ],
                        ),
                      ],
                    ),
                  ),
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Iconsax.menu_1, size: 24.sp, color: Colors.white),
              );
            }),
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: _trendingFuture,
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
                                  placeholder: (context, url) => Container(
                                    color: Colors.black,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.black,
                                  ),
                                ),
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // Glassmorphic Overlay for Pinned State
                        if (_isScrolled)
                          Positioned.fill(
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        // Top Gradient
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
                        // Content positioned from bottom to avoid overflow
                        // Content positioned from bottom to avoid overflow
                        Positioned(
                          bottom: 25.h,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  height: 0.38.sh,
                                  viewportFraction: 0.65,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.38,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.zoom,
                                  autoPlay: true,
                                  autoPlayCurve: Curves.fastOutSlowIn,
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
                                            mediaType: movie['media_type'] ??
                                                (categoryIndex == 2
                                                    ? "tv"
                                                    : "movie"),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        // color: const Color(0xFF1a1a1a),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color:
                                        //         Colors.black.withOpacity(0.5),
                                        //     blurRadius: 15,
                                        //     offset: const Offset(0, 8),
                                        //   ),
                                        // ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        child: Hero(
                                          tag: 'carousel_${movie['id']}',
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) =>
                                                Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white10,
                                                    const Color(0xFF1a1a1a),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.05),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                    Icons.movie_filter_rounded,
                                                    color: Colors.white24,
                                                    size: 40),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 30.h),
                              ValueListenableBuilder<int>(
                                valueListenable: _currentPageNotifier,
                                builder: (context, index, child) {
                                  if (trendinglist.isEmpty)
                                    return const SizedBox();
                                  final movie =
                                      trendinglist[index % trendinglist.length];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.w),
                                        child: Text(
                                          movie['name'] ?? "Title",
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.sp,
                                            letterSpacing: -0.5,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Apercu',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 18.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // NEW Premium Play/Trailer Button
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPage(
                                                    movieId: movie['id'],
                                                    backdropPath: movie[
                                                            'backdrop_path'] ??
                                                        "",
                                                    mediaType:
                                                        movie['media_type'] ??
                                                            (categoryIndex == 2
                                                                ? 'tv'
                                                                : 'movie'),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 10.h),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE50914),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFFE50914)
                                                            .withOpacity(0.4),
                                                    blurRadius: 15,
                                                    spreadRadius: 2,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 22.sp),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    "Trailer",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontFamily: 'Apercu',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 10.w),
                                          // NEW Premium Glassmorphic Details Button
                                          GestureDetector(
                                            onTap: () {
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
                                                    mediaType:
                                                        movie['media_type'] ??
                                                            (categoryIndex == 2
                                                                ? 'tv'
                                                                : 'movie'),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 12, sigmaY: 12),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.15),
                                                        width: 1),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .info_outline_rounded,
                                                          color: Colors.white,
                                                          size: 20.sp),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        "Details",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Apercu',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
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
                SizedBox(height: 16.h),
                generewidget(isTV: categoryIndex == 2),
                SizedBox(height: 20.h),
                if (categoryIndex == 0)
                  Column(
                    children: [
                      SectionWidget(
                        title: "Trending Worldwide",
                        links: trendingday,
                      ),
                      SectionWidget(
                          title: "Bollywood Hits", links: indianmovieurl),
                      SectionWidget(
                          title: "Desi Web Series",
                          links: indianTVurl,
                          mediaType: "tv"),
                      SectionWidget(
                          title: "Indian Animation", links: indianAnimationUrl),
                      SectionWidget(
                          title: "Indian Action Hits", links: indianActionUrl),
                      SectionWidget(
                          title: "Hindi Comedy", links: indianComedyUrl),
                      SectionWidget(
                          title: "Soon in Cinema", links: upcomingindianurl),
                      SectionWidget(
                          title: "Worldwide Upcoming",
                          links: upcomingmoviesurl),
                      SectionWidget(
                          title: "Popular Choice", links: popularmovieurl),
                      SectionWidget(
                          title: "Bollywood Horror", links: hindihorrorurl),
                      SectionWidget(title: "Top Rated", links: topratedmovie),
                    ],
                  )
                else if (categoryIndex == 1)
                  Column(
                    children: [
                      SectionWidget(
                        title: "Trending Movies Worldwide",
                        links: trendingmovieurl,
                      ),
                      SectionWidget(
                          title: "Now Playing",
                          links:
                              "https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey"),
                      SectionWidget(title: "Popular", links: popularmovieurl),
                      SectionWidget(title: "Top Rated", links: topratedmovie),
                      SectionWidget(
                          title: "Upcoming", links: upcomingmoviesurl),
                    ],
                  )
                else if (categoryIndex == 2)
                  Column(
                    children: [
                      SectionWidget(
                        title: "Trending TV Worldwide",
                        links: trendingtvurl,
                        mediaType: "tv",
                      ),
                      SectionWidget(
                          title: "Indian TV",
                          links: indianTVurl,
                          mediaType: "tv"),
                      SectionWidget(
                          title: "Airing Today",
                          links: airingTodayTV,
                          mediaType: "tv"),
                      SectionWidget(
                          title: "On The Air",
                          links: onTheAirTV,
                          mediaType: "tv"),
                      SectionWidget(
                          title: "Popular TV",
                          links: populartv,
                          mediaType: "tv"),
                      SectionWidget(
                          title: "Top Rated TV",
                          links: topratedtv,
                          mediaType: "tv"),
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

  Widget _buildCategoryTab(String title, int index) {
    bool isSelected = categoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          categoryIndex = index;
          _trendingFuture = trendinglisthome();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.white10,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white38,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Apercu',
          ),
        ),
      ),
    );
  }
}
