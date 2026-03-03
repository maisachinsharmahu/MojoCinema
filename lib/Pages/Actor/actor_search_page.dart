import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/Actor/actor_detail_page.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class ActorSearchPage extends StatefulWidget {
  const ActorSearchPage({super.key});

  @override
  State<ActorSearchPage> createState() => _ActorSearchPageState();
}

class _ActorSearchPageState extends State<ActorSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  void _searchActors(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(searchPersonUrl(query)));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _results = List<Map<String, dynamic>>.from(data['results']);
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              "Search Actors",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Apercu',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                onChanged: _searchActors,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for a star...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon:
                      const Icon(Iconsax.search_normal, color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child:
                  Center(child: CircularProgressIndicator(color: Colors.red)),
            )
          else if (_results.isEmpty && _searchController.text.isNotEmpty)
            const SliverFillRemaining(
              child: Center(
                  child: Text("No actors found",
                      style: TextStyle(color: Colors.white38))),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final actor = _results[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActorDetailPage(
                              actorId: actor['id'],
                              actorName: actor['name'] ?? "Unknown",
                              profilePath: actor['profile_path'] ?? "",
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(20.r),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'actor_${actor['id']}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r)),
                                  child: CachedNetworkImage(
                                    imageUrl: actor['profile_path'] != null
                                        ? "https://image.tmdb.org/t/p/w500${actor['profile_path']}"
                                        : "https://i.pinimg.com/736x/d6/64/b2/d664b27cca7eaf4d64c41622b5bb9b6c.jpg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    actor['name'] ?? "Unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    actor['known_for_department'] ?? "Actor",
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _results.length,
                ),
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 40.h)),
        ],
      ),
    );
  }
}
