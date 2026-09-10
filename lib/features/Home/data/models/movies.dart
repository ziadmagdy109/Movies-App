class Movies {
  late String largeCoverImage;
  late num rating;

  Movies.fromJson(Map<String, dynamic> json) {
    largeCoverImage = json["large_cover_image"];
    rating = json["rating"];
  }
}
