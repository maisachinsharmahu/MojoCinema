import 'package:mojocinema/Pages/Discover/discover_page.dart';
import 'package:mojocinema/Pages/Home/home_page.dart';

import 'package:mojocinema/Pages/Home/Widgets/bottom_nav.dart';
import 'package:mojocinema/Pages/Home/Widgets/drawer_widget.dart';
import 'package:mojocinema/Pages/Videospage/trailers_hub.dart';
import 'package:mojocinema/Pages/Watchlist/watchlist_page.dart';
import 'package:flutter/material.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // The pages to be displayed in the IndexedStack
  final List<Widget> _pages = [
    const HomePage(),
    const DiscoverPage(),
    const TrailersHubPage(),
    const WatchlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const MojocinemaDrawer(), // Added drawer
      // extendBody allows the bottom nav (if translucent) to sit on top of the content
      extendBody: true,
      body: IndexedStack(
        // Kept IndexedStack as CustomScrollView would require more changes not specified
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: MojocinemaBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
