import 'dart:convert';
import 'package:mojocinema/Pages/Home/Widgets/movieWidget.dart';
import 'package:mojocinema/api/apikey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$query&include_adult=false'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        setState(() {
          _searchResults = results
              .where((item) =>
                  item['media_type'] == 'movie' || item['media_type'] == 'tv')
              .map((item) => {
                    'id': item['id'],
                    'title': item['title'] ?? item['name'],
                    'poster_path': item['poster_path'],
                    'backdrop_path': item['backdrop_path'],
                    'vote_average':
                        (item['vote_average'] as num?)?.toDouble() ?? 0.0,
                    'release_date':
                        item['release_date'] ?? item['first_air_date'],
                    'media_type': item['media_type'],
                  })
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies, TV shows...',
            hintStyle: TextStyle(color: Colors.white38, fontSize: 16.sp),
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.search_status,
                          size: 64.sp, color: Colors.white10),
                      SizedBox(height: 16.h),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Search for your favorites'
                            : 'No results found',
                        style:
                            TextStyle(color: Colors.white38, fontSize: 16.sp),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    return moviecard(
                      imageurl: item['poster_path'] ?? "",
                      title: item['title'] ?? "Unknown",
                      rate: item['vote_average'],
                      vote_count: 0,
                      movieid: item['id'],
                      backdrop: item['backdrop_path'] ?? "",
                      heroTag: 'search_${item['id']}',
                      mediaType: item['media_type'] ?? 'movie',
                    );
                  },
                ),
    );
  }
}
