import 'package:mojocinema/api/apikey.dart';

String trendingweekurl =
    "https://api.themoviedb.org/3/trending/all/week?api_key=$apikey";
String trendingday =
    "https://api.themoviedb.org/3/trending/all/day?api_key=$apikey";
String populartv = "https://api.themoviedb.org/3/tv/popular?api_key=$apikey";
String topratedtv = "https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey";
String trendingmovieurl =
    "https://api.themoviedb.org/3/trending/movie/week?api_key=$apikey";
String trendingtvurl =
    "https://api.themoviedb.org/3/trending/tv/week?api_key=$apikey";
String popularmovieurl =
    "https://api.themoviedb.org/3/movie/popular?api_key=$apikey";
String topratedmovie =
    "https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey";
String upcomingmoviesurl =
    "https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey";
String onTheAirTV =
    "https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey";
String airingTodayTV =
    "https://api.themoviedb.org/3/tv/airing_today?api_key=$apikey";

String genreurl =
    "https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey";
String tvGenreUrl =
    "https://api.themoviedb.org/3/genre/tv/list?api_key=$apikey";

String horrorURL =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&language=en-US&with_genres=27";
String indianmovieurl =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&language=en-US&with_original_language=hi";
String indianTVurl =
    "https://api.themoviedb.org/3/discover/tv?api_key=$apikey&language=en-US&with_original_language=hi";
String upcomingindianurl =
    "https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey&language=en-US&region=IN";
String hindihorrorurl =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&language=en-US&with_original_language=hi&with_genres=27";
String indianAnimationUrl =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&with_original_language=hi&with_genres=16";
String indianActionUrl =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&with_original_language=hi&with_genres=28";
String indianComedyUrl =
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&with_original_language=hi&with_genres=35";

String buildDiscoverUrl({
  required int page,
  int? year,
  double? minRating,
  String? genreIds,
  String mediaType = "movie",
}) {
  String url =
      "https://api.themoviedb.org/3/discover/$mediaType?api_key=$apikey&language=en-US&page=$page&sort_by=popularity.desc";
  if (year != null) {
    if (mediaType == "movie") {
      url += "&primary_release_year=$year";
    } else {
      url += "&first_air_date_year=$year";
    }
  }
  if (minRating != null) {
    url += "&vote_average.gte=$minRating";
  }
  if (genreIds != null && genreIds.isNotEmpty) {
    url += "&with_genres=$genreIds";
  }
  return url;
}

String searchPersonUrl(String query) =>
    "https://api.themoviedb.org/3/search/person?api_key=$apikey&query=$query";

String getActorDetailsUrl(int actorId) =>
    "https://api.themoviedb.org/3/person/$actorId?api_key=$apikey&append_to_response=combined_credits,external_ids";

String getCollectionUrl(int collectionId) =>
    "https://api.themoviedb.org/3/collection/$collectionId?api_key=$apikey";

String getProductionMoviesUrl(int companyId, int page) =>
    "https://api.themoviedb.org/3/discover/movie?api_key=$apikey&with_companies=$companyId&page=$page";

String getProductionDetailsUrl(int companyId) =>
    "https://api.themoviedb.org/3/company/$companyId?api_key=$apikey";
