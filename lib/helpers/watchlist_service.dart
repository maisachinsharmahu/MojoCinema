import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistService {
  static const String _watchlistKey = 'movie_watchlist';

  // Singleton pattern
  static final WatchlistService _instance = WatchlistService._internal();
  factory WatchlistService() => _instance;
  WatchlistService._internal();

  /// Save a movie to the watchlist.
  /// movieData should be a Map containing id, title, poster_path, backdrop_path, vote_average, etc.
  Future<void> addToWatchlist(Map<String, dynamic> movieData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];

    // Check if heroTag exists (for carousel hero transition)
    if (!movieData.containsKey('id')) return;

    // Check if movie already exists using its ID
    final String movieId = movieData['id'].toString();
    bool exists = watchlist.any((item) {
      final decoded = jsonDecode(item);
      return decoded['id'].toString() == movieId;
    });

    if (!exists) {
      // Store relevant data as JSON string
      watchlist.add(jsonEncode({
        'id': movieData['id'],
        'title': movieData['title'] ?? movieData['name'] ?? 'Movie',
        'poster_path': movieData['poster_path'],
        'backdrop_path': movieData['backdrop_path'],
        'vote_average': movieData['vote_average'],
        'release_date': movieData['release_date'],
        'media_type': movieData['media_type'] ?? 'movie',
        'timestamp': DateTime.now().toIso8601String(),
      }));
      await prefs.setStringList(_watchlistKey, watchlist);
    }
  }

  /// Remove a movie from the watchlist
  Future<void> removeFromWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];

    watchlist.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == movieId;
    });

    await prefs.setStringList(_watchlistKey, watchlist);
  }

  /// Check if a movie is in the watchlist
  Future<bool> isInWatchlist(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];

    return watchlist.any((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == movieId;
    });
  }

  /// Get all movies in the watchlist
  Future<List<Map<String, dynamic>>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];

    return watchlist
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList()
        .reversed
        .toList();
  }
}
