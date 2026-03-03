import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/Home/Widgets/movieWidget.dart';
import 'package:mojocinema/api/apikey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class ActorDetailPage extends StatefulWidget {
  final int actorId;
  final String actorName;
  final String profilePath;

  const ActorDetailPage({
    super.key,
    required this.actorId,
    required this.actorName,
    required this.profilePath,
  });

  @override
  State<ActorDetailPage> createState() => _ActorDetailPageState();
}

class _ActorDetailPageState extends State<ActorDetailPage> {
  Map<String, dynamic>? actorDetails;
  List<Map<String, dynamic>> knownFor = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchActorDetails(),
      _fetchActorMovies(),
    ]);
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchActorDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/${widget.actorId}?api_key=$apikey'));
    if (response.statusCode == 200) {
      actorDetails = json.decode(response.body);
    }
  }

  Future<void> _fetchActorMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/${widget.actorId}/movie_credits?api_key=$apikey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cast = data['cast'] as List;
      knownFor = cast
          .map((item) => {
                'id': item['id'],
                'title': item['title'],
                'poster_path': item['poster_path'],
                'backdrop_path': item['backdrop_path'],
                'vote_average':
                    (item['vote_average'] as num?)?.toDouble() ?? 0.0,
                'popularity': item['popularity'],
              })
          .toList();
      knownFor.sort((a, b) => b['popularity'].compareTo(a['popularity']));
    }
  }

  int _calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) return 0;
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
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
                  expandedHeight: 450.h,
                  pinned: true,
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/original/${widget.profilePath}",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.actorName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Apercu',
                                ),
                              ),
                              if (actorDetails?['place_of_birth'] != null)
                                Text(
                                  actorDetails!['place_of_birth'],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                              Iconsax.user,
                              actorDetails?['known_for_department'] ?? "Actor",
                            ),
                            _buildInfoChip(
                              Iconsax.calendar,
                              "${_calculateAge(actorDetails?['birthday'])} years old",
                            ),
                            _buildInfoChip(
                              Iconsax.location,
                              actorDetails?['place_of_birth']
                                      ?.split(',')
                                      .last
                                      .trim() ??
                                  "N/A",
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Biography",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          actorDetails?['biography'] ??
                              "No biography available.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15.sp,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          "Known For",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 220.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: knownFor.length,
                            itemBuilder: (context, index) {
                              final movie = knownFor[index];
                              return moviecard(
                                imageurl: movie['poster_path'] ?? "",
                                title: movie['title'] ?? "",
                                rate: movie['vote_average'],
                                vote_count: 0,
                                movieid: movie['id'],
                                backdrop: movie['backdrop_path'] ?? "",
                                heroTag:
                                    'actor_${widget.actorId}_${movie['id']}',
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
