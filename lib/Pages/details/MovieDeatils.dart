import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/widget.dart/crew.dart';
import 'package:mojocinema/Pages/details/widget.dart/details.dart';
import 'package:mojocinema/Pages/details/widget.dart/production_widget.dart';
import 'package:mojocinema/Pages/details/widget.dart/seasons_widget.dart';
import 'package:mojocinema/Pages/details/widget.dart/similar_recommend_section.dart';

import 'package:mojocinema/Pages/Videospage/vid.dart';
import 'package:mojocinema/helpers/watchlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
// import 'package:iconsax/iconsax.dart'; // Removed unused import
import '../../api/apikey.dart';

class movieDetailPage extends StatefulWidget {
  final int movieid;
  final String? imageurl; // Made nullable
  final String? posterpath; // Made nullable
  final String? backdroppath; // Made nullable
  final String? title; // Made nullable
  final String? heroTag;
  final String mediaType; // "movie" or "tv"
  const movieDetailPage({
    super.key,
    required this.movieid,
    this.imageurl,
    this.posterpath,
    this.backdroppath,
    this.title,
    this.heroTag,
    this.mediaType = "movie",
  });

  @override
  State<movieDetailPage> createState() => _movieDetailPageState();
}

class _movieDetailPageState extends State<movieDetailPage> {
  bool isLoading = true;
  bool isInWatchlist = false;
  List<Map<String, dynamic>> movieDetails = [];
  List<Map<String, dynamic>> userReviews = [];
  List<Map<String, dynamic>> crewdata = [];
  final WatchlistService _watchlistService = WatchlistService();

  final ValueNotifier<List<Color>> posterColors = ValueNotifier<List<Color>>([
    Colors.transparent,
    Colors.transparent,
  ]);

  @override
  void initState() {
    super.initState();
    _fetchAllDetails();
  }

  Future<void> _fetchAllDetails() async {
    setState(() => isLoading = true);
    await Future.wait([
      fetchMovieDetails(),
      fetchCrewData(),
      _extractPosterColors(),
      _checkWatchlistStatus(),
    ]);

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchMovieDetails() async {
    final String type = widget.mediaType;
    final String base = "https://api.themoviedb.org/3/$type/${widget.movieid}";
    final String query =
        "?api_key=$apikey&append_to_response=${type == 'movie' ? 'release_dates' : 'content_ratings'},external_ids,keywords";
    var response = await http.get(Uri.parse(base + query));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      movieDetails.clear();
      movieDetails.add({
        'id': data["id"],
        'backdrop_path': data["backdrop_path"],
        'poster_path': data["poster_path"],
        'name': data["title"] ?? data["name"],
        'vote_average': data["vote_average"],
        'vote_count': data["vote_count"],
        'collection': data["belongs_to_collection"] != null
            ? {
                'id': data["belongs_to_collection"]["id"],
                'name': data["belongs_to_collection"]["name"],
                'poster_path': data["belongs_to_collection"]["poster_path"],
                'backdrop_path': data["belongs_to_collection"]["backdrop_path"],
              }
            : null,
        'genres': data["genres"],
        'origin_country': data["origin_country"],
        'original_language': data["original_language"],
        'about': data["overview"],
        'release_date': data['release_date'] ?? data['first_air_date'],
        'revenue': data['revenue'],
        'runtime': data['runtime'] ??
            (data['episode_run_time'] != null &&
                    (data['episode_run_time'] as List).isNotEmpty
                ? data['episode_run_time'][0]
                : 0),
        'seasons': data['seasons'],
        'production_companies': data['production_companies'],
        'popularity': data['popularity'],
        'external_ids': data['external_ids'],
        'keywords':
            data['keywords']?['keywords'] ?? data['keywords']?['results'] ?? [],
        'certification': widget.mediaType == 'movie'
            ? _getCertification(data['release_dates']?['results'] ?? [])
            : _getTVCertification(data['content_ratings']?['results'] ?? []),
      });
    }
  }

  String _getTVCertification(List<dynamic> results) {
    try {
      var us = results.firstWhere((e) => e['iso_3166_1'] == 'US',
          orElse: () => null);
      if (us != null) return us['rating'];
      if (results.isNotEmpty) return results[0]['rating'];
    } catch (_) {}
    return "N/A";
  }

  String _getCertification(List<dynamic> results) {
    try {
      var us = results.firstWhere((e) => e['iso_3166_1'] == 'US',
          orElse: () => null);
      if (us != null && us['release_dates'].isNotEmpty) {
        return us['release_dates'][0]['certification'];
      }
      var india = results.firstWhere((e) => e['iso_3166_1'] == 'IN',
          orElse: () => null);
      if (india != null && india['release_dates'].isNotEmpty) {
        return india['release_dates'][0]['certification'];
      }
    } catch (_) {}
    return "N/A";
  }

  Future<void> fetchUserReviews() async {
    var url =
        "https://api.themoviedb.org/3/${widget.mediaType}/${widget.movieid}/reviews?api_key=${apikey}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var tempdata = jsonDecode(response.body);
      var resultdata = tempdata["results"];
      userReviews.clear();
      for (var review in resultdata) {
        userReviews.add({
          "name": review['author'],
          "username": review['author_details']['username'],
          "review": review['content'],
          "rating":
              review['author_details']['rating']?.toString() ?? "Not Rated",
          "created_at": review['created_at'],
          "url": review['url'],
          "total_results": tempdata['total_results'],
          "total_pages": tempdata['total_pages'],
          "avatar": review['author_details']['avatar_path'] == null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500${review['author_details']['avatar_path']}",
        });
      }
    }
  }

  Future<void> fetchCrewData() async {
    var url =
        "https://api.themoviedb.org/3/${widget.mediaType}/${widget.movieid}/credits?api_key=${apikey}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var tempdata = jsonDecode(response.body);
      var resultdata = tempdata["cast"];
      crewdata.clear();
      for (var member in resultdata) {
        crewdata.add({
          'gender': member['gender'],
          'id': member['id'],
          'name': member['name'],
          'original_name': member['original_name'],
          'character': member['character'],
          'cast_id': member['cast_id'],
          'popularity': member['popularity'],
          'known_for_department': member['known_for_department'],
          'profile_path': member['profile_path'] == null
              ? "https://i.pinimg.com/736x/d6/64/b2/d664b27cca7eaf4d64c41622b5bb9b6c.jpg"
              : "https://image.tmdb.org/t/p/w500${member['profile_path']}",
        });
      }
    }
  }

  Future<void> _checkWatchlistStatus() async {
    final status = await _watchlistService.isInWatchlist(widget.movieid);
    if (mounted) {
      setState(() => isInWatchlist = status);
    }
  }

  Future<void> _toggleWatchlist() async {
    if (isInWatchlist) {
      await _watchlistService.removeFromWatchlist(widget.movieid);
    } else {
      await _watchlistService.addToWatchlist({
        'id': widget.movieid,
        'title': widget.title ?? "Movie",
        'poster_path': widget.imageurl ?? "",
        'backdrop_path': widget.backdroppath ?? "",
        'vote_average':
            movieDetails.isNotEmpty ? movieDetails[0]['vote_average'] : 0.0,
        'media_type': widget.mediaType,
      });
    }
    _checkWatchlistStatus();
  }

  Future<void> _extractPosterColors() async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage("https://image.tmdb.org/t/p/w500/${widget.posterpath}"),
      );

      posterColors.value = [
        paletteGenerator.dominantColor?.color ?? Colors.transparent,
        paletteGenerator.darkVibrantColor?.color ?? Colors.transparent,
      ];
    } catch (_) {}
  }

  @override
  void dispose() {
    posterColors.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  expandedHeight: 0.55.sh,
                  pinned: true,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: LayoutBuilder(builder: (context, constraints) {
                      return constraints.maxHeight <=
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top +
                                  10
                          ? Text(
                              widget.title ?? "Movie",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Apercu',
                              ),
                            )
                          : const SizedBox();
                    }),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: widget.heroTag ?? widget.movieid.toString(),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://image.tmdb.org/t/p/original/${widget.backdroppath}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Back button only visible when expanded? Actually, it's in the leading now.
                        // But if we want it to stay in the hero area, we can keep it here.
                        // I'll keep it here but remove the kToolbarHeight check for simplicity or just rely on the leading.
                        // Let's remove this Positioned back button since it's in kToolbarHeight now.

                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          right: 16.w,
                          child: GestureDetector(
                            onTap: _toggleWatchlist,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 46.w,
                              height: 46.w,
                              decoration: BoxDecoration(
                                color: isInWatchlist
                                    ? const Color(0xFFE50914)
                                    : Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isInWatchlist
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: isInWatchlist
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFE50914)
                                              .withOpacity(0.4),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Icon(
                                  isInWatchlist
                                      ? Icons.bookmark_added_rounded
                                      : Icons.bookmark_add_outlined,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 20.h,
                          left: 16.w,
                          right: 16.w,
                          child: Column(
                            children: [
                              Text(
                                widget.title ?? "Movie",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Apercu',
                                ),
                              ),
                              SizedBox(height: 16.h),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPage(
                                        movieId: widget.movieid,
                                        backdropPath: widget.backdroppath ?? "",
                                        mediaType: widget.mediaType,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE50914),
                                    borderRadius: BorderRadius.circular(100.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE50914)
                                            .withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow_rounded,
                                          color: Colors.white, size: 28.sp),
                                      SizedBox(width: 6.w),
                                      Text(
                                        "Play Trailer",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Apercu',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    if (movieDetails.isNotEmpty)
                      movienameandotherdetails(movieDetails: movieDetails),
                    CrewDeatilswidget(crewdata: crewdata),
                    if (widget.mediaType == 'tv' &&
                        movieDetails.isNotEmpty &&
                        movieDetails[0]['seasons'] != null)
                      SeasonsWidget(
                        seasons: movieDetails[0]['seasons'],
                        showName: widget.title ?? "Show",
                      ),
                    SizedBox(height: 10.h),
                    if (movieDetails.isNotEmpty &&
                        movieDetails[0]['production_companies'] != null)
                      ProductionWidget(movieDetails: movieDetails),
                    SimilarAndRecommend(
                      title: widget.mediaType == 'movie'
                          ? "Similar Movies"
                          : "Similar Shows",
                      links:
                          "https://api.themoviedb.org/3/${widget.mediaType}/${widget.movieid}/similar?api_key=${apikey}",
                    ),
                    SimilarAndRecommend(
                      title: widget.mediaType == 'movie'
                          ? "Recommended Movies"
                          : "Recommended Shows",
                      links:
                          "https://api.themoviedb.org/3/${widget.mediaType}/${widget.movieid}/recommendations?api_key=${apikey}",
                    ),
                    SizedBox(height: 40.h),
                  ]),
                )
              ],
            ),
    );
  }
}

String formatRuntime(int runtime) {
  if (runtime <= 0) return '';
  int hours = runtime ~/ 60;
  int minutes = runtime % 60;
  String formattedTime = '';
  if (hours > 0) formattedTime += '${hours}h ';
  if (minutes > 0) formattedTime += '${minutes}m';
  return formattedTime.trim();
}

String getYearFromDate(String? releaseDate) {
  if (releaseDate == null || releaseDate.isEmpty) return '';
  try {
    DateTime date = DateTime.parse(releaseDate);
    return date.year.toString();
  } catch (e) {
    return '';
  }
}
