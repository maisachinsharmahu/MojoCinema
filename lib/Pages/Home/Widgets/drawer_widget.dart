import 'package:mojocinema/Pages/Actor/actor_search_page.dart';
import 'package:mojocinema/Pages/Discover/discover_page.dart';
import 'package:mojocinema/Pages/Videospage/trailers_hub.dart';
import 'package:mojocinema/Pages/Watchlist/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class MojocinemaDrawer extends StatelessWidget {
  const MojocinemaDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Iconsax.home,
                  title: "Home",
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Iconsax.discover,
                  title: "Discover Movies",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const DiscoverPage(mediaType: "movie"),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Iconsax.video_play,
                  title: "TV Series Hub",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const DiscoverPage(mediaType: "tv"),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Iconsax.play_circle,
                  title: "Trailers Hub",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrailersHubPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Iconsax.user_search,
                  title: "Actor Search",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActorSearchPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Iconsax.archive_book,
                  title: "My Watchlist",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WatchlistPage(),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white10),
                _buildDrawerItem(
                  icon: Iconsax.info_circle,
                  title: "About Mojocinema",
                  onTap: () {},
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(top: 60.h, bottom: 30.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE50914),
            const Color(0xFFE50914).withOpacity(0.8),
            Colors.black,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/2503/2503508.png",
                  width: 30.w,
                  height: 30.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "MOJOCINEMA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontFamily: 'Apercu',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "Your Ultimate Cinema Guide",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      hoverColor: Colors.white10,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          const Divider(color: Colors.white10),
          SizedBox(height: 10.h),
          Text(
            "Version 2.0.0",
            style: TextStyle(color: Colors.white24, fontSize: 10.sp),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
