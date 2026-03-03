import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/helpers/watchlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final WatchlistService _watchlistService = WatchlistService();
  List<Map<String, dynamic>> _watchlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    setState(() => _isLoading = true);
    final list = await _watchlistService.getWatchlist();
    setState(() {
      _watchlist = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : null,
        title: Text(
          "My List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'Apercu',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _watchlist.isEmpty
              ? _buildEmptyState()
              : _buildWatchlistGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.archive_book, size: 80.sp, color: Colors.white24),
          SizedBox(height: 20.h),
          Text(
            "Your list is empty",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Movies you bookmark will appear here.",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: _watchlist.length,
      itemBuilder: (context, index) {
        final movie = _watchlist[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => movieDetailPage(
                  movieid: movie['id'],
                  title: movie['title'],
                  imageurl: movie['poster_path'],
                  posterpath: movie['poster_path'],
                  backdroppath: movie['backdrop_path'],
                  heroTag: 'watchlist_${movie['id']}',
                  mediaType: movie['media_type'] ?? 'movie',
                ),
              ),
            );
            _loadWatchlist(); // Reload in case it was removed
          },
          child: Hero(
            tag: 'watchlist_${movie['id']}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
                    fit: BoxFit.cover,
                  ),
                  _buildRatingBadge(movie['vote_average']),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBadge(dynamic rating) {
    if (rating == null) return const SizedBox();
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 12.sp),
            SizedBox(width: 2.w),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
