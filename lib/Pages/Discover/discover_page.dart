import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mojocinema/Pages/details/MovieDeatils.dart';
import 'package:mojocinema/api/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DiscoverPage extends StatefulWidget {
  final int? initialGenreId;
  final String? initialGenreName;
  final String mediaType; // "movie" or "tv"

  const DiscoverPage({
    super.key,
    this.initialGenreId,
    this.initialGenreName,
    this.mediaType = "movie",
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  static const _pageSize = 20;

  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 1);

  int? selectedYear;
  double minRating = 0.0;
  List<int> selectedGenres = [];
  List<Map<String, dynamic>> allGenres = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialGenreId != null) {
      selectedGenres.add(widget.initialGenreId!);
    }
    _fetchGenres();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchGenres() async {
    final url = widget.mediaType == "tv" ? tvGenreUrl : genreurl;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allGenres = List<Map<String, dynamic>>.from(data['genres']);
      });
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final url = buildDiscoverUrl(
        page: pageKey,
        year: selectedYear,
        minRating: minRating > 0 ? minRating : null,
        genreIds: selectedGenres.isNotEmpty ? selectedGenres.join(',') : null,
        mediaType: widget.mediaType,
      );

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        final List<Map<String, dynamic>> newItems =
            results.cast<Map<String, dynamic>>();

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        _pagingController.error = 'Failed to load movies';
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _applyFilters() {
    _pagingController.refresh();
    Navigator.pop(context); // Close bottom sheet
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
          "Discover",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Apercu'),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Iconsax.filter, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedGenres.isNotEmpty ||
              selectedYear != null ||
              minRating > 0)
            _buildActiveFiltersRow(),
          Expanded(
            child: PagedGridView<int, Map<String, dynamic>>(
              padding: EdgeInsets.all(12.w),
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, item, index) => _buildMovieCard(item),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(color: Colors.red)),
                newPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow() {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (selectedYear != null)
            _buildFilterChip("Year: $selectedYear", () {
              setState(() => selectedYear = null);
              _pagingController.refresh();
            }),
          if (minRating > 0)
            _buildFilterChip("Rating: $minRating+", () {
              setState(() => minRating = 0.0);
              _pagingController.refresh();
            }),
          ...selectedGenres.map((id) {
            final name = allGenres.firstWhere((g) => g['id'] == id)['name'];
            return _buildFilterChip(name, () {
              setState(() => selectedGenres.remove(id));
              _pagingController.refresh();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Chip(
        label:
            Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
        backgroundColor: const Color(0xFFE50914),
        deleteIcon: Icon(Icons.close, size: 14.sp, color: Colors.white),
        onDeleted: onDeleted,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => movieDetailPage(
              movieid: movie['id'],
              title: movie['title'] ?? movie['name'] ?? 'Movie',
              imageurl: movie['poster_path'] ?? "",
              posterpath: movie['poster_path'] ?? "",
              backdroppath: movie['backdrop_path'] ?? "",
              heroTag: 'discover_${movie['id']}',
              mediaType: widget.mediaType,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'discover_${movie['id']}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: "https://image.tmdb.org/t/p/w500/${movie['poster_path']}",
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[900],
              child: const Icon(Icons.movie, color: Colors.white24),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(20.w),
          height: 0.7.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filters",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20.h),
              Text("Year",
                  style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
              _buildYearGrid(setModalState),
              SizedBox(height: 20.h),
              Text("Minimum Rating: ${minRating.toStringAsFixed(1)}",
                  style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
              Slider(
                value: minRating,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: Colors.red,
                inactiveColor: Colors.white10,
                onChanged: (val) => setModalState(() => minRating = val),
              ),
              SizedBox(height: 20.h),
              Text("Genres",
                  style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
              Expanded(child: _buildGenreWrap(setModalState)),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r))),
                  onPressed: _applyFilters,
                  child: Text("Apply Filters",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearGrid(StateSetter setModalState) {
    final years = List.generate(15, (index) => 2025 - index);
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = selectedYear == year;
          return GestureDetector(
            onTap: () =>
                setModalState(() => selectedYear = isSelected ? null : year),
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.white10,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                  child: Text(year.toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreWrap(StateSetter setModalState) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8.w,
        runSpacing: 0,
        children: allGenres.map((genre) {
          final isSelected = selectedGenres.contains(genre['id']);
          return FilterChip(
            label: Text(genre['name']),
            selected: isSelected,
            onSelected: (val) {
              setModalState(() {
                if (val) {
                  selectedGenres.add(genre['id']);
                } else {
                  selectedGenres.remove(genre['id']);
                }
              });
            },
            selectedColor: Colors.red,
            checkmarkColor: Colors.white,
            backgroundColor: Colors.white10,
            labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12.sp),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
