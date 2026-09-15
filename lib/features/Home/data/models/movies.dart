class Movies {
  late String largeCoverImage;
  late num rating;
  late int id;

  Movies.fromJson(Map<String, dynamic> json) {
    id=json["id"];
    largeCoverImage = json["large_cover_image"];
    rating = json["rating"];
  }
}
