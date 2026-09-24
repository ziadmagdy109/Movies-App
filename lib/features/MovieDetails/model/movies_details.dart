import 'cast_model.dart';

class MoviesDetails {
  String title_long = '';
  String url = '';
  String imdb_code = '';
  dynamic rating = 0;
  dynamic runtime = 0;
  dynamic like_count = 0;
  int year = 0;
  String description_full = '';
  String large_cover_image = '';
  String large_screenshot_image1 = '';
  String large_screenshot_image2 = '';
  String large_screenshot_image3 = '';
  List<CastModel> cast = [];
  List<String> genres = [];

  MoviesDetails.fromJson(Map<String, dynamic> json) {
    title_long = json["title_long"] as String? ?? '';
    imdb_code = json["imdb_code"] as String? ?? '';
    url = json["url"] as String? ?? '';
    rating = json["rating"] ?? 0;
    runtime = json["runtime"] ?? 0;
    like_count = json["like_count"] ?? 0;
    year = (json["year"] as num?)?.toInt() ?? 0;
    description_full = json["description_full"] as String? ?? '';
    large_cover_image = json["large_cover_image"] as String? ?? '';
    large_screenshot_image1 = json["large_screenshot_image1"] as String? ?? '';
    large_screenshot_image2 = json["large_screenshot_image2"] as String? ?? '';
    large_screenshot_image3 = json["large_screenshot_image3"] as String? ?? '';

    final Object? rawCast = json['cast'];
    cast = rawCast is List
        ? rawCast
            .whereType<Map<String, dynamic>>()
            .map((e) => CastModel.fromJson(e))
            .toList()
        : <CastModel>[];

    final Object? rawGenres = json["genres"];
    genres = rawGenres is List
        ? rawGenres.whereType<String>().toList()
        : <String>[];
  }
}