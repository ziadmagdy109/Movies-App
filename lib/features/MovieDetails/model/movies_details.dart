import 'cast_model.dart';

class MoviesDetails {
late String title_long;
late double rating;
late int runtime;
late int like_count;
late String description_full;
late String large_cover_image;
late String large_screenshot_image1;
late String large_screenshot_image2;
late String large_screenshot_image3;
List<CastModel>? cast;
late List<String> genres;
 MoviesDetails.fromJson(Map<String, dynamic> json) {
    title_long = json["title_long"];
    rating = json["rating"];
    runtime = json["runtime"];
    like_count = json["like_count"];
    description_full = json["description_full"];
    large_cover_image = json["large_cover_image"];
    large_screenshot_image1 = json["large_screenshot_image1"];
    large_screenshot_image2 = json["large_screenshot_image2"];
    large_screenshot_image3 = json["large_screenshot_image3"];
    cast = (json['cast'] as List)
        .map((e) => CastModel.fromJson(e))
        .toList();
    genres = json["genres"].cast<String>();

 }


}