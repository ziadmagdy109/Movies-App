class SuggestedMovieModel {
  final String image;
  final double rating;
final int id;

  SuggestedMovieModel({
    required this.image,
    required this.rating,
    required this.id,
  });

  factory SuggestedMovieModel.fromJson(Map<String, dynamic> json) {
    return SuggestedMovieModel(
      id: json['id'],
      image: json['medium_cover_image'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}