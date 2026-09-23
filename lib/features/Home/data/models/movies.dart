class Movies {
  late String largeCoverImage;
  late num rating;
  late int id;
  String title = '';

  Movies({
    required this.id,
    required this.rating,
    required this.largeCoverImage,
    this.title = '',
  });

  Movies.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    largeCoverImage = json["large_cover_image"];
    rating = json["rating"];
    title = json["title"] ?? '';
  }
}